//
//  MapViewController.swift
//  PDP
//
//  Created by Евгений Самарин on 21.04.2022.
//  
//

import UIKit
import MapKit
import CoreLocation
import SnapKit
import AVKit

class MapViewController: UIViewController, MapViewProtocol {

    // MARK: - Instance Properties

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
//        let center: CLLocationCoordinate2D =        CLLocationCoordinate2DMake(kDefault_latitude, kDefault_longitude)
//
//        mapView.setCenter(center, animated: true)
//
//        let mySpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let myRegion: MKCoordinateRegion = MKCoordinateRegionMake(center, mySpan)
//
//        mapView.region = myRegion
//
//        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
//        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
//
//        mapView.addGestureRecognizer(myLongPress)
        return mapView
    }()

    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()

    // MARK: -

    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    private let coordinates = [CLLocationCoordinate2D(latitude: 37.7907, longitude: 122.4056),
                               CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
                               CLLocationCoordinate2D(latitude: 55.796391, longitude: 49.108891),
                               CLLocationCoordinate2D(latitude: 60.165249, longitude: 24.936056),
                               CLLocationCoordinate2D(latitude: 24.466667, longitude: 54.366669)]
    private var steps: [MKRoute.Step] = []
    private var stepCounter = 0
    private var route: MKRoute?
    private var showMapRoute = false
    private var navigationStarted = false
    private var speechSynth = AVSpeechSynthesizer()
    private var locationDistance: Double = 500

    // MARK: -

    var presenter: MapPresenterProtocol!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.configureView()
        self.configureMapView()
        self.configureLocationManager()
        self.setupView()
        self.handleAuthStatus(with: self.locationManager)
    }

    // MARK: - Instance Methods

    private func setupView() {
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.centerMapButton)

        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.centerMapButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(10)
        }
        self.addTestPinToCard()
    }

    private func configureMapView() {
        self.mapView.delegate = self
    }

    private func configureLocationManager() {
        self.locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.handleAuthStatus(with: self.locationManager)
    }

    // MARK: -

    @objc func handleCenterLocation() {
        guard let center = self.locationManager.location?.coordinate else { return }
        self.centerMapOnUserLocation(center: center)
        self.centerMapButton.alpha = 0
    }

    private func centerMapOnUserLocation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: self.locationDistance, longitudinalMeters: self.locationDistance)
        self.mapView.setRegion(region, animated: true)
    }

    private func getRouteOnMap(with annotation: MKAnnotation) {
        self.showMapRoute = true
//        let geoCoder = CLGeocoder()
        let destinationCoordinate = annotation.coordinate
        self.mapRoute(destinationCoordinate: destinationCoordinate)
    }

    private func mapRoute(destinationCoordinate: CLLocationCoordinate2D) {
        guard let sourceCoordinate = self.locationManager.location?.coordinate else { return }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)

        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)

        let routeRequest = MKDirections.Request()
        routeRequest.source = sourceItem
        routeRequest.destination = destinationItem
        routeRequest.transportType = .any

        let direction = MKDirections(request: routeRequest)
        direction.calculate { [weak self] (response, error) in
            if let error = error {
                print("---> ERROR CALCULATE DIRECTION: \(error.localizedDescription)")
                return
            }
            guard let response = response,
                  let route = response.routes.first else { return }
            self?.route = route
            self?.mapView.addOverlay(route.polyline)
            self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                            edgePadding: UIEdgeInsets(top: 16,
                                                                                                      left: 16,
                                                                                                      bottom: 16,
                                                                                                      right: 16),
                                            animated: true)
            self?.getRouteSteps(route: route)
        }
    }

    private func getRouteSteps(route: MKRoute) {
        
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.centerMapButton.alpha = 1
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
              !(annotation is MKUserLocation) else {
                  return
              }
//        guard !(view is MKUserLocationView) else {
//            return
//        }
        print("---> SELECT VIEW: \(view)")
        let vc = MapDetailInfoConfigurator().configure()
        let navController = BottomSheetNavigationController(rootViewController: vc)
        let geoCoder = CLGeocoder()

        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitionDelegate
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { response, error in
            guard let response = response else { return }
            for placemark in response {
                print("ADDRESS: \(placemark.country ?? "" ) \(placemark.locality ?? "") \(placemark.thoroughfare ?? "" ) \(placemark.subThoroughfare ?? "" )")
            }
        }
        self.getRouteOnMap(with: annotation)
        self.present(navController, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapCustomPin")
        if annotationView == nil {
            // MARK: - REFACTOR THIS
            annotationView = MKAnnotationView(annotation: annotation,
                                              reuseIdentifier: "mapCustomPin")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = #imageLiteral(resourceName: "AirPods").withRenderingMode(.alwaysOriginal)
        annotationView?.layer.backgroundColor = UIColor.white.cgColor
        annotationView?.layer.cornerRadius = annotationView?.frame.width ?? 0 / 2
        annotationView?.layer.shadowRadius = 2
        annotationView?.canShowCallout = false
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemPink
        return renderer
    }

    // MARK: - MOCK PIN DATA

    func addTestPinToCard() {
        for coordinate in self.coordinates {
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            pin.title = "Title"
            pin.subtitle = "Subtitle"
            self.mapView.addAnnotation(pin)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    private func handleAuthStatus(with locationManager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("---> Location status is notDetermined")
            self.locationManager.requestWhenInUseAuthorization()

        case .restricted:
            print("---> Location status is restricted")
        case .denied:
            print("---> Location status is denied")
        case .authorizedAlways:
            print("---> Location status is authorizedAlways")
        case .authorizedWhenInUse:
            print("---> Location status is authorizedWhenInUse")
            if let center = locationManager.location?.coordinate {
                self.centerMapOnUserLocation(center: center)
            }
        @unknown default:
            print("---> Location status is default")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.location != nil else { return }
        if let center = manager.location?.coordinate {
            self.centerMapOnUserLocation(center: center)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.showMapRoute {
            if let location = locations.last {
                let center = location.coordinate
//                self.centerMapOnUserLocation(center: center)
            }
        }
    }
}

// MARK: - BottomSheetPresentationControllerFactory

extension MapViewController: BottomSheetPresentationControllerFactory {

    func makeBottomSheetPresentationController(
            presentedViewController: UIViewController,
            presentingViewController: UIViewController?
        ) -> BottomSheetPresentationController {
            .init(
                presentedViewController: presentedViewController,
                presentingViewController: presentingViewController,
                dismissalHandler: self
            )
        }
}

// MARK: - BottomSheetModalDismissalHandler

extension MapViewController: BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { true }

    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
}

//
//  MainViewController.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import Foundation
import UIKit
import SnapKit

final class MainViewController: UIViewController, MainViewProtocol {

    // MARK: - Nested Types

    private enum Section: Int, CaseIterable {

        // MARK: - Type Properties

        case myDevices
        case otherDevices
    }

    // MARK: - TypeAliases

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, DevicePreview>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DevicePreview>

    // MARK: - Instance Properties

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCompositionalLayout())
    private lazy var dataSource = self.makeDataSource()
    private var longPressEnabled: Bool = false
    private let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        return control
    }()

    // MARK: -

    var presenter: MainPresenterProtocol!
    var configurator: MainConfiguratorProtocol = MainConfigurator()
    var bluetoothManager: BluetoothManagerProtocol = BluetoothManager.shared

    // MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurator.configure(with: self)
        self.presenter.viewLoaded()
        self.setupCollectionView()
//        self.testBluettoth()
//        self.subscribe()
        self.selectionFeedbackGenerator.prepare()
    }

    // MARK: - Instance Methods

    func update(myDevices: [DevicePreview], otherDevices: [DevicePreview]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DevicePreview>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(myDevices, toSection: .myDevices)
        snapshot.appendItems(otherDevices, toSection: .otherDevices)

        self.dataSource.apply(snapshot)
    }

    private func setupCollectionView() {
        self.collectionView.backgroundColor = .adaptedFor(light: .darkPurple, dark: .darkPurple)
        self.collectionView.dataSource = self.dataSource
        self.collectionView.register(MyDevicesCell.self, OtherDevicesCell.self)
        self.collectionView.register(MyDevicesHeaderView.self, withKind: UICollectionView.elementKindSectionHeader)
        self.collectionView.delegate = self

        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        self.collectionView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }

    // MARK: -

    func testBluettoth() {
        bluetoothManager.scanForPeripherals(withServices: Constants.BLE.servicesForScan, options: Constants.BLE.optionsForScanPeripherals)
    }

    func subscribe() {
        bluetoothManager.centralManagerDidUpdateState = { [weak self] (state) in
            if (state == .poweredOn) {
                self?.testBluettoth()
            } else {
                return
            }
        }
    }

    @objc private func longTap(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndex = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                return
            }
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndex)
            self.selectionFeedbackGenerator.impactOccurred()

        case .changed:
            guard let gestureView = gesture.view else {
                fallthrough
            }
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gestureView))

        case .ended:
            self.collectionView.endInteractiveMovement()
            self.longPressEnabled = true
            self.collectionView.reloadData()

        @unknown default:
            self.collectionView.cancelInteractiveMovement()
        }
    }

    @objc private func refreshData() {
        self.presenter.reloadView()
    }
}

// MARK: - Compositional Layout

extension MainViewController {

    // MARK: - Instance Methods

    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            let sectionType = Section(rawValue: sectionIndex)

            switch sectionType {
            case .myDevices:
                return self.makeMyDevicesLayoutSection()

            case .otherDevices:
                return self.makeOtherDevicesLayoutSection()

            case .none:
                return nil
            }
        }
    }

    private func makeMyDevicesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(244), heightDimension: .estimated(154))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 35
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)

        return section
    }

    private func makeOtherDevicesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(35))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .topLeading)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 20

        return section
    }
}

// MARK: - CollectionViewDataSource

extension MainViewController {

    // MARK: - Instance Methods

    private func makeDataSource() -> DataSource {
        let otherDevicesCellRegistration = UICollectionView.CellRegistration<OtherDevicesCell, DevicePreview> { (cell, indexPath, item) in
            cell.item = item
            
        }

        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, device in
            let sectionType = Section(rawValue: indexPath.section)

            switch sectionType {
            case .myDevices:
                let cell = collectionView.dequeue(MyDevicesCell.self, for: indexPath)
                    .updated(with: device.deviceLogo, deviceCompanyImage: device.deviceCompanyLogo, deviceName: device.deviceName)
                if self.longPressEnabled {
                    cell.startAnimate()
                } else {
                    cell.stopAnimate()
                }
                return cell

            case .otherDevices:
                let cell = collectionView.dequeueConfiguredReusableCell(using: otherDevicesCellRegistration,
                                                                        for: indexPath,
                                                                        item: device)
                return cell
            case .none:
                return nil
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  Section(rawValue: indexPath.section) == .otherDevices else { return nil }
            return collectionView.dequeue(MyDevicesHeaderView.self, ofKind: kind, indexPath: indexPath)
                .updated(with: "Другие девайсы")
        }
        return dataSource
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(#function, Self.self, "---> SELECT ITEM AT: ", indexPath.item)
        if self.longPressEnabled {
            self.longPressEnabled = false
            collectionView.reloadData()
        }
        switch indexPath.section {
        case Section.myDevices.rawValue:
            self.presenter.myDeviceCellTapped(with: indexPath.item)

        case Section.otherDevices.rawValue:
            guard let cell = collectionView.cellForItem(at: indexPath) as? OtherDevicesCell,
                  let device = cell.item
            else {
                return
            }
            self.presenter.otherDeviceCellTapped(with: device)

        default:
            break
        }
    }
}

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

    enum MainSection: Int, CaseIterable {

        // MARK: - Type Properties

        case myDevices
        case otherDevices
    }

    // MARK: - TypeAliases

    private typealias DataSource = UICollectionViewDiffableDataSource<MainSection, DevicePreview>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MainSection, DevicePreview>

    // MARK: - Instance Properties

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.makeCompositionalLayout())
    private lazy var dataSource = self.makeDataSource()
    private lazy var mapButton: Button = {
        let button = Button()
        button.backgroundColor = .red
        return button
    }()

    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        return control
    }()

    // MARK: -

    var presenter: MainPresenterProtocol!
    var bluetoothManager: BluetoothManagerProtocol = BluetoothManager.shared

    // MARK: - LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.viewLoaded()
        self.setupUI()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.backButtonTitle = ""
//        self.testBluettoth()
//        self.subscribe()
    }

    // MARK: - Instance Methods

    func update(myDevices: [DevicePreview], otherDevices: [DevicePreview]) {
        var snapshot = NSDiffableDataSourceSnapshot<MainSection, DevicePreview>()
        snapshot.appendSections(MainSection.allCases)
        snapshot.appendItems(myDevices, toSection: .myDevices)
        snapshot.appendItems(otherDevices, toSection: .otherDevices)

        self.dataSource.apply(snapshot)
    }

    private func setupUI() {
        self.collectionView.backgroundColor = .adaptedFor(light: .darkPurple, dark: .darkPurple)
        self.collectionView.dataSource = self.dataSource
        self.collectionView.register(MyDevicesCell.self, OtherDevicesCell.self)
        self.collectionView.register(MyDevicesHeaderView.self, withKind: UICollectionView.elementKindSectionHeader)
        self.collectionView.delegate = self

        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.mapButton)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.mapButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(40)
            make.centerX.equalToSuperview()
        }

//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
//        self.collectionView.addGestureRecognizer(longPressGesture)
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

    @objc private func refreshData() {
        self.presenter.reloadView()
    }
}

// MARK: - Compositional Layout

extension MainViewController {

    // MARK: - Instance Methods

    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            let sectionType = MainSection(rawValue: sectionIndex)

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
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -30, bottom: 0, trailing: -30)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
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
            let sectionType = MainSection(rawValue: indexPath.section)

            switch sectionType {
            case .myDevices:
                let cell = collectionView.dequeue(MyDevicesCell.self, for: indexPath)
                    .updated(with: device.deviceLogo, deviceCompanyImage: device.deviceCompanyLogo, deviceName: device.deviceName)
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
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            switch MainSection(rawValue: indexPath.section) {
            case .otherDevices:
                return collectionView.dequeue(MyDevicesHeaderView.self, ofKind: kind, indexPath: indexPath)
                    .updated(with: "Другие девайсы", rightButtonIsHidden: true)

            case .myDevices:
                return collectionView.dequeue(MyDevicesHeaderView.self, ofKind: kind, indexPath: indexPath)
                    .updated(with: "Мои девайсы", rightButtonIsHidden: false)

            case .none:
                break
            }
            return nil
        }
        return dataSource
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(#function, Self.self, "---> SELECT ITEM AT: ", indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? MyDevicesCell {
            if cell.isAnimate {
                cell.stopAnimate()
                return
            }
        }
        switch indexPath.section {
        case MainSection.myDevices.rawValue:
            self.presenter.myDeviceCellTapped(with: indexPath.item)

        case MainSection.otherDevices.rawValue:
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

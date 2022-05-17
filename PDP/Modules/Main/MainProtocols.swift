//
//  MainProtocols.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import UIKit

// MARK: - MainViewProtocol

protocol MainViewProtocol: AnyObject {
//    func updateMyDevices(with devices: [DevicePreview])
//    func updateOtherDevices(with devices: [DevicePreview])
    func update(myDevices: [DevicePreview], otherDevices: [DevicePreview])
}

// MARK: - MainPresenterProtocol

protocol MainPresenterProtocol: AnyObject {

    // MARK: - MainPresenterProtocol Methods

    func viewLoaded()
    func myDeviceCellTapped(with index: Int)
    func otherDeviceCellTapped(with device: DevicePreview)
    func reloadView()
    func deleteFromMyDevice()
//    func getLiquidDataSource() -> LiquidSwipeContainerDataSource

    func showErrorAlert()
    func outputMyDevicesUpdated()
    func outputOtherDevicesUpdated()
}

// MARK: - MainInteractorProtocol

protocol MainInteractorProtocol: AnyObject {

    // MARK: - MainInteractorProtocol Properties

    var outputMyDevices: [DevicePreview] { get }
    var outputOtherDevices: [DevicePreview] { get }

    // MARK: - MainInteractorProtocol Method

    func getMyDevices()
    func getOtherDevices()
}

// MARK: - MainRouterProtocol

protocol MainRouterProtocol: AnyObject {

    // MARK: - MainRouterProtocol Methods

    func showBottomSheetDeviceMenu(with device: DevicePreview)
    func showMyDeviceDetailsInfo()
}

// MARK: - MainConfiguratorProtocol

protocol MainConfiguratorProtocol: AnyObject {
    func configure() -> UIViewController
}

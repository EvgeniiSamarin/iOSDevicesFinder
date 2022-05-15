//
//  OtherDetailsInfoProtols.swift
//  PDP
//
//  Created by Евгений Самарин on 12.05.2022.
//  
//

import UIKit

// MARK: - OtherDetailsInfoViewProtocol

protocol OtherDetailsInfoViewProtocol: AnyObject {
//    func updateMyDevices(with devices: [DevicePreview])
//    func updateOtherDevices(with devices: [DevicePreview])
//    func update(myDevices: [DevicePreview], otherDevices: [DevicePreview])
}

// MARK: - OtherDetailsInfoPresenterProtocol

protocol OtherDetailsInfoPresenterProtocol: AnyObject {

    // MARK: - OtherDetailsInfoPresenterProtocol Methods

    func addButtonTapped()
    func deleteButtonTapped()
}

// MARK: - OtherDetailsInfoInteractorProtocol

protocol OtherDetailsInfoInteractorProtocol: AnyObject {

    // MARK: - OtherDetailsInfoInteractorProtocol Properties

    // MARK: - OtherDetailsInfoInteractorProtocol Method

}

// MARK: - OtherDetailsInfoRouterProtocol

protocol OtherDetailsInfoRouterProtocol: AnyObject {

    // MARK: - OtherDetailsInfoRouterProtocol Methods

//    func showBottomSheetDeviceMenu(with device: DevicePreview)
    func dismissViewController()
}

// MARK: - OtherDetailsInfoConfiguratorProtocol

protocol OtherDetailsInfoConfiguratorProtocol: AnyObject {
    func configure(with initialHeight: CGFloat) -> UIViewController
}

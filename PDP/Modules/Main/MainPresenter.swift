//
//  MainPresenter.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import Foundation

final class MainPresenter: MainPresenterProtocol {

    // MARK: - Instance Properties

    weak var view: MainViewProtocol!
    var interactor: MainInteractorProtocol!
    var router: MainRouterProtocol!

    // MARK: -

    var outputMyDevicesPreview: [DevicePreview] {
        get {
            return self.interactor.outputMyDevices
        }
    }

    var outputOtherDevicesPreview: [DevicePreview] {
        get {
            return self.interactor.outputOtherDevices
        }
    }

    // MARK: - Initializer

    required init(view: MainViewProtocol) {
        self.view = view
    }

    func viewLoaded() {
        debugPrint(#function, Self.self)
        self.interactor.getOtherDevices()
    }

    func myDeviceCellTapped(with index: Int) {
        self.router.showMyDeviceDetailsInfo()
        debugPrint(#function, Self.self, "INDEX MY DEVICE: ", index)
    }

    func otherDeviceCellTapped(with device: DevicePreview) {
        debugPrint(#function, Self.self, "INDEX OTHER DEVICE: ", device)
        self.router.showBottomSheetDeviceMenu(with: device)
    }

    func reloadView() {
        debugPrint(#function, Self.self)
    }

    func deleteFromMyDevice() {
        debugPrint(#function, Self.self)
    }

    func showBottomSheetDeviceMenu() {
        debugPrint(#function, Self.self)
    }

    func showErrorAlert() {
        debugPrint(#function, Self.self)
    }

    func outputMyDevicesUpdated() {
        debugPrint(#function, Self.self)
        self.view.update(myDevices: self.outputMyDevicesPreview, otherDevices: self.outputOtherDevicesPreview)
    }

    func outputOtherDevicesUpdated() {
        debugPrint(#function, Self.self)
        self.view.update(myDevices: self.outputMyDevicesPreview, otherDevices: self.outputOtherDevicesPreview)
    }
}

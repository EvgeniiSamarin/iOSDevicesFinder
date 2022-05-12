//
//  MainInteractor.swift
//  PDP
//
//  Created by Евгений Самарин on 20.02.2022.
//

import Foundation

final class MainInteractor: MainInteractorProtocol {

    // MARK: - Instance Properties

    weak var presenter: MainPresenterProtocol!
    var bluetoothManager: BluetoothManagerProtocol = BluetoothManager.shared

    // MARK: -

    var outputMyDevices: [DevicePreview] {
        get {
            let devices = DevicePreview.mockMyDevices()
            return devices
        }
    }

    var outputOtherDevices: [DevicePreview] {
        get {
            let devices = DevicePreview.mockOtherDevices()
            return devices
        }
    }

    // MARK: - Initializer

    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Instance Methods

    func getMyDevices() {
        self.presenter.outputMyDevicesUpdated()
    }

    func getOtherDevices() {
        self.presenter.outputOtherDevicesUpdated()
    }
}

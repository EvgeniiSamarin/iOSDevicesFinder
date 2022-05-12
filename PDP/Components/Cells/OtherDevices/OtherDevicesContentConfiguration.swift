//
//  OtherDevicesContentConfiguration.swift
//  PDP
//
//  Created by Евгений Самарин on 11.05.2022.
//

import Foundation
import UIKit

struct OtherDevicesContentConfiguration: UIContentConfiguration, Hashable {

    var deviceName: String?
    var deviceType: String?
    var deviceImage: UIImage?
    var deviceNameColor: UIColor?

    func makeContentView() -> UIView & UIContentView {
        return OtherDevicesCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {

        guard let state = state as? UICellConfigurationState else {
            return self
        }

        var updatedConfiguration = self
        if state.isSelected {
            updatedConfiguration.deviceNameColor = .systemPink
        } else {
            updatedConfiguration.deviceNameColor = .white
        }

        return updatedConfiguration
    }
}

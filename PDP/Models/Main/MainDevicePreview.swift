//
//  MainDevicePreview.swift
//  PDP
//
//  Created by Евгений Самарин on 30.03.2022.
//

import UIKit

struct MainDevicesPreview: Hashable {

    // MARK: - Instance Properties

    let id: String
    let deviceName: String
    let deviceType: DeviceType
    let deviceCompanyLogo: UIImage
    let deviceLogo: UIImage
}

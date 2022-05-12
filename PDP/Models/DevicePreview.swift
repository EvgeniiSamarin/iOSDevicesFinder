//
//  DevicePreview.swift
//  PDP
//
//  Created by Евгений Самарин on 17.03.2022.
//

import UIKit

enum DeviceType: Int {
    case apple
    case other
}

struct DevicePreview: Hashable {

    // MARK: - Instance Properties

    let id: String
    let deviceName: String
    let deviceType: DeviceType
    let deviceCompanyLogo: UIImage
    let deviceLogo: UIImage

    init(id: String, deviceName: String, deviceType: DeviceType, deviceCompanyLogo: UIImage, deviceLogo: UIImage) {
        self.id = id
        self.deviceName = deviceName
        self.deviceType = deviceType
        self.deviceCompanyLogo = deviceCompanyLogo
        self.deviceLogo = deviceLogo
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

//    static func == (lhs: DevicePreview, rhs: DevicePreview) -> Bool {
//        lhs.id == rhs.id
//    }
}

// MARK: - Mock

extension DevicePreview {

    static func mockOtherDevices() -> [DevicePreview] {
        return [
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage()),
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage()),
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage()),
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage()),
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage()),
            DevicePreview(id: UUID().uuidString, deviceName: "AirPods", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AirPods") ?? UIImage())
        ]
    }

    static func mockMyDevices() -> [DevicePreview] {
        return [
            DevicePreview(id: UUID().uuidString, deviceName: "AppleWatch", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AppleWatchMyDeviceLogo") ?? UIImage())
//            DevicePreview(id: UUID().uuidString, deviceName: "AppleWatch", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AppleWatchMyDeviceLogo") ?? UIImage()),
//            DevicePreview(id: UUID().uuidString, deviceName: "AppleWatch", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AppleWatchMyDeviceLogo") ?? UIImage()),
//            DevicePreview(id: UUID().uuidString, deviceName: "v", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AppleWatchMyDeviceLogo") ?? UIImage()),
//            DevicePreview(id: UUID().uuidString, deviceName: "AppleWatch", deviceType: .apple, deviceCompanyLogo: UIImage(named: "AppleCompanyLogo") ?? UIImage(), deviceLogo: UIImage(named: "AppleWatchMyDeviceLogo") ?? UIImage())
        ]
    }
}

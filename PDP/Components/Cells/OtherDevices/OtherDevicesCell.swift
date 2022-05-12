//
//  OtherDevicesCell.swift
//  PDP
//
//  Created by Евгений Самарин on 17.03.2022.
//

import UIKit

final class OtherDevicesCell: UICollectionViewListCell {

    var item: DevicePreview?
    
    override func updateConfiguration(using state: UICellConfigurationState) {

        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .clear
        backgroundConfiguration = newBgConfiguration

        var newConfiguration = OtherDevicesContentConfiguration().updated(for: state)

        newConfiguration.deviceName = item?.deviceName
        newConfiguration.deviceType = item?.deviceName
        newConfiguration.deviceImage = item?.deviceLogo

        contentConfiguration = newConfiguration
    }
}

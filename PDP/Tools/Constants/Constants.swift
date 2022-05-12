//
//  Constants.swift
//  PDP
//
//  Created by Евгений Самарин on 11.05.2022.
//

import Foundation
import CoreBluetooth

struct Constants {
    
    struct BLE {
        // Services //
        static let UUID_SERVICE_HEART_RATE: CBUUID = CBUUID(string: "180D")
        // End Services //
        // Characteristic //
        static let UUID_CHARACTERISTIC_HEART_RATE_CONTROL: CBUUID = CBUUID(string: "2A39")
        static let UUID_CHARACTERISTIC_HEART_RATE_DATA: CBUUID = CBUUID(string: "2A37")
        // End Characteristic //
        static let cbCentralManagerOptions: [String : Any]? = [CBCentralManagerOptionShowPowerAlertKey : NSNumber(value: true)]
        static let servicesForScan: [CBUUID]? = nil
        static let discoverServices: [CBUUID]? = [UUID_SERVICE_HEART_RATE]
        static let optionsForScanPeripherals: [String: Any]? = [CBCentralManagerScanOptionAllowDuplicatesKey : false]
        // Identifier
        static let MI_BAND_4_DEVICE_IDENTIFIER: UUID = .init(uuidString: "0C565851-6C95-DA45-02DF-4EDCA9EF37E9")!
    }
    
}

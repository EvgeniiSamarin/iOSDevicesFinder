//
//  BluetoothManagerProtocol.swift
//  PDP
//
//  Created by Евгений Самарин on 11.05.2022.
//

import CoreBluetooth

protocol BluetoothManagerProtocol {
    func isPoweredOn() -> Bool
    func scanForPeripherals(withServices: [CBUUID]?, options: [String : Any]?)
    func connect(_ peripheral: CBPeripheral, options: [String : Any]?)
    func stopScan()
    var centralManagerDidUpdateState: ((CBManagerState) -> Void)? { get set }
}

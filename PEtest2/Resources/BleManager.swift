//
//  BleManager.swift
//  PEtest2
//
//  Created by Feng ping xiong on 7/30/21.
//

import Foundation
import CoreBluetooth

var manager:CBCentralManager?
var myPeripheral:CBPeripheral?
var myCharacteristic:CBCharacteristic?
let serviceUUID = [CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b"), CBUUID(string: "0ad9287e-58ef-412a-b3bd-89c40702d686"), CBUUID(string: "8d5b0ffb-b4ca-4edd-8871-d716db6d4f3a"), CBUUID(string: "19aff77b-a4e6-4a48-a9a7-5733117e5da5")]


final class BleManager: NSObject, ObservableObject, CBCentralManagerDelegate {
//    static let shared = BleManager()
    public var UserDeviceName = ""
    public var connectedText = ""
    public var notificationText = ""
//    public var ScanText = ""
    

    struct DeviceInfo {
        let DeviceName: String
        let serviceUUID: String
        let peripheralUUID: String
        let CharaUUID: String
    }
    
    var UserDevice: [DeviceInfo] = [DeviceInfo(DeviceName: "myESP32", serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b", peripheralUUID: "5432A3E0-45C0-BA0D-B7C3-36D8225221FB", CharaUUID: "beb5483e-36e1-4688-b7f5-ea07361b26a8"),
                                    DeviceInfo(DeviceName: "myESP32-1", serviceUUID: "0ad9287e-58ef-412a-b3bd-89c40702d686", peripheralUUID: "2B64E68B-8817-F415-BD94-45DAB71D1598", CharaUUID: "0198d73a-8194-4cbf-95d6-4e738707fe4e"), DeviceInfo(DeviceName: "myESP32-2", serviceUUID: "8d5b0ffb-b4ca-4edd-8871-d716db6d4f3a", peripheralUUID: "C18D98CE-2419-6FE0-A7D8-71A34EC30F78", CharaUUID: "526394f2-e5db-480f-adcd-715c680aa3e5"), DeviceInfo(DeviceName: "myESP32-3", serviceUUID: "19aff77b-a4e6-4a48-a9a7-5733117e5da5", peripheralUUID: "E913A16B-F6C5-B3F4-B6FA-57728A5366CA", CharaUUID: "13e3860b-e4d4-40fb-b16b-302bc7400eef")

    ]
    
    override init() {
        super.init()

        manager = CBCentralManager(delegate: self, queue: nil)
        manager?.delegate = self
//        print("delegated")
        }
    
    func startScanning() {
        manager?.stopScan()
        manager?.scanForPeripherals(withServices: serviceUUID, options: nil)
//        ScanText = "Scanning"
//        print("scanned")
    }
    
    func sendText(text: String) {
            if (myPeripheral != nil && myCharacteristic != nil) {
                let data = text.data(using: .utf8)
                myPeripheral!.writeValue(data!,  for: myCharacteristic!, type: CBCharacteristicWriteType.withResponse)
//                print("11")
            }
        }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for DeviceInfo in UserDevice {
            if peripheral.identifier.uuidString == DeviceInfo.peripheralUUID {
                myPeripheral = peripheral
                myPeripheral?.delegate = self
                manager?.connect(myPeripheral!, options: nil)
                UserDeviceName = DeviceInfo.DeviceName
                manager?.stopScan()
//                print("deviceName:\(UserDeviceName)")
            }
        }
        //
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
            case .poweredOff:
                print("Bluetooth is switched off")
            case .poweredOn:
                print("Bluetooth is switched on")
            case .resetting:
                print("resetting")
            case .unauthorized:
                print("unauthorized")
            case .unsupported:
                print("Bluetooth is not supported")
            case .unknown:
                print("Unknown state")
            @unknown default:
                fatalError()
            }
        }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(serviceUUID)
        connectedText = "Connected"
//        connectedText = "\(UserDeviceName) has connected"
        print("Connected to " +  peripheral.name!)
//        print("text:\(UserDeviceName)")
       }
    
//    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
////        LocalNotification.shared.showNotification(id: "willrestorestate", title: "Manager will restore state", body: "", timeInterval: 1.0)
//
////        let systemSoundID: SystemSoundID = 1321
////        AudioServicesPlaySystemSound (systemSoundID)
//
//        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
//            peripherals.forEach { (awakedPeripheral) in
//                print(". - Awaked peripheral \(String(describing: awakedPeripheral.name))")
//                guard let localName = awakedPeripheral.name,
//                localName == UserDeviceName else {
//                    return
//                }
//
//                myPeripheral = awakedPeripheral
//            }
//        }
//    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from " +  peripheral.name!)
        myPeripheral = nil
        myCharacteristic = nil
//        myPeripheral = peripheral
//        myCharacteristic = service.characteristics
        }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            print(error!)
        }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        // Deal with errors (if any)
//
//        if (myPeripheral != nil && myCharacteristic != nil) {
//            myPeripheral!.readValue( for: myCharacteristic!)
//            guard let receivedData = myCharacteristic?.value,
//                let stringFromData = String(data: receivedData, encoding: .utf8) else { return }
//
////            os_log("Received %d bytes: %s", receivedData.count, stringFromData)
//            if stringFromData == "0" {
//                DispatchQueue.main.async() {
//                            print("get0")
//                        }
//            }
//        }
//    }

}

extension BleManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            guard let services = peripheral.services else { return }
            
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
        
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            guard let characteristics = service.characteristics else { return }
            myCharacteristic = characteristics[0]

        }
}

//
//  PairStartViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 7/13/21.
//

import UIKit
import CoreBluetooth

//ESP32
//let serviceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
//let peripheralUUID = CBUUID(string: "5432A3E0-45C0-BA0D-B7C3-36D8225221FB")
//ESP32-1
//let serviceUUID = CBUUID(string: "0ad9287e-58ef-412a-b3bd-89c40702d686")
//let peripheralUUID = CBUUID(string: "2B64E68B-8817-F415-BD94-45DAB71D1598")

@available(iOS 13.0, *)
class PairStartViewController: UIViewController {
    
    var bleManager = BleManager()
    
    @IBOutlet weak var AllDoneView: UIView!
    @IBOutlet weak var DeviceTableView: UITableView!
    @IBOutlet weak var AlldoneLabel: UILabel!
    @IBOutlet weak var WaitLabel: UILabel!
    @IBOutlet weak var sendText: UIButton!
    
    
//    var UserDeviceEmpty: [DeviceInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        manager = CBCentralManager(delegate: self, queue: nil)
//        DeviceTableView.dataSource = self
        title = "Pair Device"
        AllDoneView.isHidden = true
        WaitLabel.isHidden = true
//        sendText.isHidden = true
    }
    
    
    @IBAction func PairStartButtontapped(_ sender: UIButton) {
        bleManager.startScanning()
        WaitLabel.isHidden = false
//        self.DeviceTableView.reloadData()
        DispatchQueue.main.async {
//        if bleManager.centralManagerDidUpdateState()
            self.AlldoneLabel.text = self.bleManager.connectedText
            print("\(self.bleManager.connectedText)")
            self.AllDoneView.isHidden = false
//            self.AlldoneLabel.text = "\(self.bleManager.UserDeviceName) disconnected"
        }
        
    }
    
    
    @IBAction func SendText(_ sender: Any) {
        bleManager.sendText(text: "77")
//        print("11")
    }
    

}


//extension PairStartViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return UserDevice.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
//        cell.textLabel?.text = UserDevice[indexPath.row].DeviceName
//        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        return cell
//    }    
//}

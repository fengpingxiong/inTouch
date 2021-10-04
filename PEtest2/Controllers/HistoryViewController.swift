//
//  HistoryViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/28/21.
//

import UIKit
import Firebase
import CoreBluetooth


class HistoryViewController: UIViewController {
    
    var blemanager = BleManager()
    public var userName: String = ""
    public var userProfile = UIImage(named: "Image")
//    var messageContent = ""
    var currentMessageContent = ""
    private var name: String = ""
    private var messageContentArray = [String]()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var DeviceLabel: UILabel!
    
    let db = Firestore.firestore()
    
    var historyText: [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "History"
        tableView.dataSource = self
        tableView.delegate = self
        
        UserName.text = userName
        profilePicture.image = userProfile
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2.0
        
        loadHistory()
    }
    
    @IBAction func DeviceButton(_ sender: UIButton) {
        blemanager.startScanning()
        DispatchQueue.main.async {
            self.DeviceLabel.text = self.blemanager.connectedText
            print("\(self.blemanager.connectedText)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.backBarButtonItem?.tintColor = UIColor.white

        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "#EB9D1E", Alpha:1.0)
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.shadowImage = nil
    }

    
    func callDevice(_ sender: Any) {
        print("number")
        blemanager.sendText(text: "\(currentMessageContent)")
        print("\(currentMessageContent)")
        
    }
    
    
//    func dismissSelf() {
//        dismiss(animated:false, completion: nil)
//    }
    
    
    func loadHistory() {
        db.collection("messageSend")
            .order(by:"DateTime")
            .addSnapshotListener{ (querySnapshot,error) in
            self.historyText = []
            if let e = error {
                print("There was an issue retrieving data from firestore, \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        let findSenderEmail = data["senderEmail"] as? String
                        let receiverName = data["receiverName"] as? String
                        let findReceiverEmail = data["receiverEmail"] as? String
                        let userName = data["userName"] as? String
                        let authEmail = Auth.auth().currentUser?.email
                        let safeReceiverEmail = DatabaseManager.safeEmail(emailAddress: authEmail ?? "0@gmail.com")
                        let timeData = data["DateTime"] as? String
                        let messageContent = data["messageContent"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            
                            if findSenderEmail == authEmail {
                                let tableViewSentText = History(historyType: "You sent to \(receiverName ?? "0@gmail.com") an inTouch", historyTime: timeData ?? "0")
                                self.historyText.append(tableViewSentText)
                                self.messageContentArray.append("0")
                            }
                            if findReceiverEmail == safeReceiverEmail {
                                let tableViewReceiveText = History(historyType: "You received an inTouch from \(userName ?? "")", historyTime: timeData ?? "0")
                                self.historyText.append(tableViewReceiveText)
                                self.messageContentArray.append(messageContent)
                                self.name = userName ?? ""
                                
                                
                            }
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                        
                }
                    
            }
                
        }
        
    }
    
    func hexStringToUIColor (hex:String, Alpha:Float) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(Alpha)
        )
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("run2")
        return historyText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("run1")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        let itemColors = UIColor.orange
        let HistoryText = historyText[indexPath.row].historyType
        cell.textLabel?.text = HistoryText + " " + historyText[indexPath.row].historyTime
        if HistoryText == "You received an inTouch from \(name)" {
            cell.textLabel?.textColor = itemColors
        } else {
            cell.isUserInteractionEnabled = false
        }
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print("run")
        let HistoryText = historyText[indexPath.row].historyType
//        print("history")
        let PurpleColor = UIColor(red: 229, green: 226, blue: 246, alpha: 1)
        if HistoryText == "You received an inTouch from \(name)" {
//            print("text")
            tableView.backgroundView?.backgroundColor = PurpleColor
//            print("can pressed")
            let rowNumber : Int = indexPath.row
            currentMessageContent  = "\(messageContentArray[rowNumber])"
            print(messageContentArray)
            callDevice((Any).self)
//            print("can pressed")
        }
//        dismissSelf()
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let targetUserData = results[indexPath.row]
//        print("selected")
//
//        completion?(targetUserData)
//        searchResultTable.isHidden = true
//
//        addFriends(result: targetUserData)
//
//    }
    
}


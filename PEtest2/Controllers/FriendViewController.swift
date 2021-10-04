//
//  FriendViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/30/21.
//

import UIKit
import MessageKit
import Firebase

class FriendViewController: UIViewController{
    
    public var otherUserEmail: String = ""
    public var messageContent: String = ""
    public var otherUserName: String = ""
    public var userName1: String = ""
    private var count: Int = 0
    private var countDown: Int = 6
    private var toneArray = [UIImage]()
    
    
    public static let dateFormatter: DateFormatter = {
        let formattre = DateFormatter()
        formattre.dateStyle = .medium
        formattre.timeStyle = .long
        formattre.locale = .current
        return formattre
    }()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var friendBackGroundImage: UIImageView!
    @IBOutlet weak var tone1: UIImageView!
    @IBOutlet weak var tone2: UIImageView!
    @IBOutlet weak var tone3: UIImageView!
    @IBOutlet weak var tone4: UIImageView!
    @IBOutlet weak var tone5: UIImageView!
    @IBOutlet weak var tone6: UIImageView!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = otherUserName
        friendBackGroundImage = uploadProfileImage()
//        vibrationChioces.isHidden = true
//        vibrationChiocesRed.isHidden = true
//        vibrationChiocesPurple.isHidden = true
//        countDownLabel.text = "\(countDown)"
        
        
    }
    
    func uploadProfileImage() -> UIImageView? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//        let filename = safeEmail + "_profile_picture.png"
        let filename = otherUserEmail + "_profile_picture.png"
        let path = "image/" + filename
        
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case . success(let url):
                self?.downloadImage(imageView:(self?.friendBackGroundImage)!, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return friendBackGroundImage
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
            
        }).resume()
    }
    
    func showToneImage() {
        if countDown == 5 {
            if toneArray[0] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone1.frame.size = size
                tone1.image = toneArray[0]
                messageContent = "11"
            }
            if toneArray[0] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone1.frame.size = size
                tone1.image = toneArray[0]
                messageContent = "22"
            }
            if toneArray[0] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone1.frame.size = size
                tone1.image = toneArray[0]
                messageContent = "33"
            }
            
        }
        if countDown == 4 {
            if toneArray[1] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone2.frame.size = size
                tone2.image = toneArray[1]
                messageContent = messageContent + "," + "11"
            }
            if toneArray[1] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone2.frame.size = size
                tone2.image = toneArray[1]
                messageContent = messageContent + "," + "22"
            }
            if toneArray[1] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone2.frame.size = size
                tone2.image = toneArray[1]
                messageContent = messageContent + "," + "33"
            }
        }
        if countDown == 3 {
            if toneArray[2] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone3.frame.size = size
                tone3.image = toneArray[2]
                messageContent = messageContent + "," + "11"
            }
            if toneArray[2] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone3.frame.size = size
                tone3.image = toneArray[2]
                messageContent = messageContent + "," + "22"
            }
            if toneArray[2] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone3.frame.size = size
                tone3.image = toneArray[2]
                messageContent = messageContent + "," + "33"
            }
        }
        if countDown == 2 {
            if toneArray[3] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone4.frame.size = size
                tone4.image = toneArray[3]
                messageContent = messageContent + "," + "11"
            }
            if toneArray[3] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone4.frame.size = size
                tone4.image = toneArray[3]
                messageContent = messageContent + "," + "22"
            }
            if toneArray[3] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone4.frame.size = size
                tone4.image = toneArray[3]
                messageContent = messageContent + "," + "33"
            }
        }
        if countDown == 1 {
            if toneArray[4] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone5.frame.size = size
                tone5.image = toneArray[4]
                messageContent = messageContent + "," + "11"
            }
            if toneArray[4] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone5.frame.size = size
                tone5.image = toneArray[4]
                messageContent = messageContent + "," + "22"
            }
            if toneArray[4] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone5.frame.size = size
                tone5.image = toneArray[4]
                messageContent = messageContent + "," + "33"
            }
        }
        if countDown == 0 {
            if toneArray[5] == #imageLiteral(resourceName: "vibrationChioces") {
                let size = CGSize(width: 20, height: 20)
                tone6.frame.size = size
                tone6.image = toneArray[5]
                messageContent = messageContent + "," + "11"
                yellowButton.isHidden = true
                redButton.isHidden = true
                purpleButton.isHidden = true
            }
            if toneArray[5] == #imageLiteral(resourceName: "vibrationChoicesRed") {
                let size = CGSize(width: 25, height: 25)
                tone6.frame.size = size
                tone6.image = toneArray[5]
                messageContent = messageContent + "," + "22"
                yellowButton.isHidden = true
                redButton.isHidden = true
                purpleButton.isHidden = true
            }
            if toneArray[5] == #imageLiteral(resourceName: "vibrationChiocesPurple") {
                let size = CGSize(width: 30, height: 30)
                tone6.frame.size = size
                tone6.image = toneArray[5]
                messageContent = messageContent + "," + "33"
                yellowButton.isHidden = true
                redButton.isHidden = true
                purpleButton.isHidden = true
            }
        }
    }
    
    @IBAction func HappyEmoji(_ sender: UIButton) {
        messageContent = "55"
    }
    @IBAction func CalmEmoji(_ sender: UIButton) {
        messageContent = "66"
    }
    @IBAction func SadEmoji(_ sender: UIButton) {
        messageContent = "77"
    }
    @IBAction func AngerEmoji(_ sender: UIButton) {
        messageContent = "44"
    }
    
    @IBAction func yellowButton(_ sender: UIButton) {
        if count > 5 {
            sender.isUserInteractionEnabled = false
        } else {
            count += 1
            countDown -= 1
            self.toneArray.append(#imageLiteral(resourceName: "vibrationChioces"))
            showToneImage()
            }
        
    }
    
    
    @IBAction func redButton(_ sender: UIButton) {
//        if countDown <= 0 {
//            sender.isUserInteractionEnabled = false
//        }
        
        if count > 5 {
            sender.isUserInteractionEnabled = false
        } else {
            count += 1
            countDown -= 1
            self.toneArray.append(#imageLiteral(resourceName: "vibrationChoicesRed"))
            showToneImage()
        }
    }
    
    @IBAction func purpleButton(_ sender: UIButton) {
//        if countDown <= 0 {
//            sender.isUserInteractionEnabled = false
//        }
        
        if count > 5 {
            sender.isUserInteractionEnabled = false
            
        } else {
            count += 1
            countDown -= 1
            self.toneArray.append(#imageLiteral(resourceName: "vibrationChiocesPurple"))
            showToneImage()
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        count = 0
        countDown = 6
        toneArray.removeAll()
        tone1.frame.size = CGSize(width: 30, height: 30)
        tone2.frame.size = CGSize(width: 30, height: 30)
        tone3.frame.size = CGSize(width: 30, height: 30)
        tone4.frame.size = CGSize(width: 30, height: 30)
        tone5.frame.size = CGSize(width: 30, height: 30)
        tone6.frame.size = CGSize(width: 30, height: 30)
        tone1.image = #imageLiteral(resourceName: "history-profile")
        tone2.image = #imageLiteral(resourceName: "history-profile")
        tone3.image = #imageLiteral(resourceName: "history-profile")
        tone4.image = #imageLiteral(resourceName: "history-profile")
        tone5.image = #imageLiteral(resourceName: "history-profile")
        tone6.image = #imageLiteral(resourceName: "history-profile")
        yellowButton.isHidden = false
        redButton.isHidden = false
        purpleButton.isHidden = false
        
    }
    
    
    @IBAction func sendTouchtapped(_ sender: UIButton) {
        if otherUserName != "" {
//            messageContent = "11"
            let dateString = Self.dateFormatter.string(from: Date())
            if let NameEmail = Auth.auth().currentUser?.email {
                db.collection("messageSend").addDocument(data: ["receiverEmail":otherUserEmail,
                     "senderEmail":NameEmail,
                     "messageContent":messageContent,
                     "receiverName": otherUserName,
                     "userName": userName1,
                     "DateTime":dateString]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        self.performSegue(withIdentifier: "goToSuccessSent", sender: self)
                    }
                }
            }
        }
        else {return}
    }
        
}

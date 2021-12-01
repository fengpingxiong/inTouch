//
//  HomeViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/28/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITextFieldDelegate {
    
    public var completion:(([String: String]) -> (Void))?
//    public var targetUserData = [[String: String]]()
    
    private var otherUserEmail: String = ""
    private var otherUserName: String = ""
    private var userName1: String = ""
    
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    private var friendProfileArray = [UIImageView]()
    private var friendsEmail = [String]()
//    private var friendImage: UIImage? = nil
    private var UserProfile = UIImage(named: "MyImage")
    
    
    let friends: [GetFriendsList.Friend] = [
        GetFriendsList.Friend(email: "email-0"),
        GetFriendsList.Friend(email: "email-1"),
        GetFriendsList.Friend(email: "email-2"),
        GetFriendsList.Friend(email: "email-3"),
        GetFriendsList.Friend(email: "email-4"),
        GetFriendsList.Friend(email: "email-5"),
        GetFriendsList.Friend(email: "email-6"),
        GetFriendsList.Friend(email: "email-7"),
    ]
    
    @IBOutlet weak var friendImage0: UIImageView!
    @IBOutlet weak var friendName0: UILabel!
    @IBOutlet weak var friendImage1: UIImageView!
    @IBOutlet weak var friendName1: UILabel!
    @IBOutlet weak var friendImage2: UIImageView!
    @IBOutlet weak var friendName2: UILabel!
    @IBOutlet weak var friendImage3: UIImageView!
    @IBOutlet weak var friendName3: UILabel!
    @IBOutlet weak var friendImage4: UIImageView!
    @IBOutlet weak var friendName4: UILabel!
    @IBOutlet weak var friendImage5: UIImageView!
    @IBOutlet weak var friendName5: UILabel!
    @IBOutlet weak var friendImage6: UIImageView!
    @IBOutlet weak var friendName6: UILabel!
    @IBOutlet weak var friendImage7: UIImageView!
    @IBOutlet weak var friendName7: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var searchFriends: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var searchResultTable: UITableView!
    @IBOutlet weak var historyButton: UIView!
    @IBOutlet weak var DeviceButton: UIView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Homepage"
        
//        navigationItem.hidesBackButton = true
        
        logout.title = "Logout"
//        leftButton.imageEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0);
        
//        searchFriends.placeholder.color
        
        searchResultTable.isHidden = true
        
        searchFriends.delegate = self
        searchResultTable.delegate = self
        searchResultTable.dataSource = self
        historyButton.isHidden = true
        DeviceButton.isHidden = true
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width/2.0
        friendImage0.layer.masksToBounds = true
        friendImage0.layer.cornerRadius = friendImage0.frame.width/2.0
        friendImage1.layer.masksToBounds = true
        friendImage1.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage2.layer.masksToBounds = true
        friendImage2.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage3.layer.masksToBounds = true
        friendImage3.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage4.layer.masksToBounds = true
        friendImage4.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage5.layer.masksToBounds = true
        friendImage5.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage6.layer.masksToBounds = true
        friendImage6.layer.cornerRadius = friendImage1.frame.width/2.0
        friendImage7.layer.masksToBounds = true
        friendImage7.layer.cornerRadius = friendImage1.frame.width/2.0
        
        profileImage = uploadProfileImage()
        
        showUserName()
        showFriendsNameandProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.backBarButtonItem?.tintColor = UIColor.white

        navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "#EB9D1E", Alpha:1.0)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "#000000", Alpha:1.0)
//        EB9D1E
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.shadowImage = nil
    }
    
    
    func showUserName() {
        guard let email = Auth.auth().currentUser?.email else { return }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
            switch result {
            case .success(let data):
                guard let userData = data as?[String: Any],
                let userName1 = userData["userName"] as? String else {
                    return
                    
                }
                self.userName.text = userName1
                self.userName.sizeToFit()
                self.userName1 = userName1
//                let name = UserDefaults.standard.set("\(userName1)", forKey: "name")
            
            case .failure(let error):
                print("Faild to read data with error \(error)")
            }
        })
        
    }
    
    func showFriendsNameandProfile() {
        GetFriendsList.shared.FetchFriends(
            friends: friends,
            friendName0: friendName0,
            friendImage0: friendImage0,
            friendName1: friendName1,
            friendImage1: friendImage1,
            friendName2: friendName2,
            friendImage2: friendImage2,
            friendName3: friendName3,
            friendImage3: friendImage3,
            friendName4: friendName4,
            friendImage4: friendImage4,
            friendName5: friendName5,
            friendImage5: friendImage5,
            friendName6: friendName6,
            friendImage6: friendImage6,
            friendName7: friendName7,
            friendImage7: friendImage7
        )

    }
    
    func uploadProfileImage() -> UIImageView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "image/" + filename
        
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case . success(let url):
                self?.downloadImage(imageView:(self?.profileImage)!, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
        
        return profileImage
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
                self.UserProfile = image
            }
            
        }).resume()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: false)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        searchFriends.resignFirstResponder()
        searchResultTable.isHidden = true
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchFriends.endEditing(true)
        guard let text = searchFriends.text, !text.replacingOccurrences(of:" ", with:"").isEmpty else {
            return
        }
        searchFriends.resignFirstResponder()
        results.removeAll()
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            filterUsers(with: query)
        }
        else {
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        let results: [[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updataUI()
    }
    
    func updataUI() {
        if results.isEmpty {
            searchFriends.text = "No results"
            searchResultTable.isHidden = true
        }
        else {
            searchResultTable.isHidden = false
            searchResultTable.reloadData()
        }
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchFriends.endEditing(true)
////        print(searchFriends.text!)
//        return true
//    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            textField.placeholder = ""
//            return false
//        }
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.placeholder = "+ Add friends"
//    }
 
    @IBAction func friendView0Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName0.text else { return }
        goToFriend(name: name, email: friends[0].email, userName: userName1)
    }
    
    @IBAction func friendView1Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName1.text else { return }
        goToFriend(name: name, email: friends[1].email, userName: userName1)
    }

    @IBAction func friendView2Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName2.text else { return }
        goToFriend(name: name, email: friends[2].email, userName: userName1)
    }

    @IBAction func friendView3Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName3.text else { return }
        goToFriend(name: name, email: friends[3].email, userName: userName1)
    }

    @IBAction func friendView4Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName4.text else { return }
        goToFriend(name: name, email: friends[4].email, userName: userName1)
    }

    @IBAction func friendView5Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName5.text else { return }
        goToFriend(name: name, email: friends[5].email, userName: userName1)
    }

    @IBAction func friendView6Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName6.text else { return }
        goToFriend(name: name, email: friends[6].email, userName: userName1)
    }

    @IBAction func friendView7Tapped(_ sender: UITapGestureRecognizer) {
        guard let name = friendName7.text else { return }
        goToFriend(name: name, email: friends[7].email, userName: userName1)
    }
    
    @IBAction func goToHistoryTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "goToHistory", sender: self)
    }
    
    func goToFriend(name: String, email: String, userName:String) {
//        guard let name = result ["name"], let email = result ["email"] else {
//            return
//        }
        
        self.otherUserName = name
        self.otherUserEmail = email
//        self.userName1 = userName
//        self.friendImage = image
        self.performSegue( withIdentifier: "goToFriend", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFriend" {
            let destinationVC = segue.destination as! FriendViewController
            destinationVC.otherUserEmail = self.otherUserEmail
            destinationVC.otherUserName = self.otherUserName
            destinationVC.userName1 = self.userName1
//            destinationVC.friendBackGroundImage.image = self.friendImage
        }
        if segue.identifier == "goToHistory" {
            let historyVC = segue.destination as! HistoryViewController
            historyVC.userName = self.userName1
            historyVC.userProfile = self.UserProfile
        }
    }
    

    
    func addFriends(result: [String: String]) {
        guard let name = result ["name"], let email = result ["email"] else {
            return
        }
        if let NameEmail = Auth.auth().currentUser?.email {
            db.collection("\(NameEmail) friendsList").addDocument(data: ["friendEmail":email,
                 "friendName": name,
                 "DateTime":Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCellHome", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        print("selected")
        
        completion?(targetUserData)
        searchResultTable.isHidden = true
        
        addFriends(result: targetUserData)
        
//        showFriendsNameandProfile()
        
//        goToFriend(result: targetUserData)
        
    }
}





//
//  GetFriendsList.swift
//  PEtest2
//
//  Created by Feng ping xiong on 8/3/21.
//

import Foundation
import Firebase


final class GetFriendsList {
    static let shared = GetFriendsList()
    
    let db = Firestore.firestore()
    
    class Friend {
        var email: String = ""
//        var image: UIImage? = nil
        
        init(email: String) {
            self.email = email
//            self.image = image
        }
    }
    
    public func FetchFriends(
        friends: [Friend],
        friendName0: UILabel!,
        friendImage0: UIImageView!,
        friendName1: UILabel!,
        friendImage1: UIImageView!,
        friendName2: UILabel!,
        friendImage2: UIImageView!,
        friendName3: UILabel!,
        friendImage3: UIImageView!,
        friendName4: UILabel!,
        friendImage4: UIImageView!,
        friendName5: UILabel!,
        friendImage5: UIImageView!,
        friendName6: UILabel!,
        friendImage6: UIImageView!,
        friendName7: UILabel!,
        friendImage7: UIImageView!
    ) {

        var name = ""
        if let NameEmail: String = Auth.auth().currentUser?.email{
            name = NameEmail + " friendsList"
        } else {
           name = ""
        }
        
        db.collection(name)
                .order(by:"DateTime")
            .addSnapshotListener{ [self] (querySnapshot,error) in
                if let e = error {
                    print("There was an issue retrieving data from firestore, \(e)")
                    return
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        var friendID = 0
                        for doc in snapshotDocuments {
                            let data = doc.data()
//                            let friendEmail: Optional<String> = data["friendEmail"] as? String
                            let friendEmail = data["friendEmail"] as? String
                            let firendName = data["friendName"] as? String
                            
                            var email: String = ""
                            if friendEmail != nil {
                                email = friendEmail!
                            }
                            
                            var name: String = ""
                            if firendName != nil {
                                name = firendName!
                            }
                            
                            if friendID == 0 {
                                friendName0.text = name
                                friends[0].email = email
                                friendName0.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage0)
                                
                            }

                            if friendID == 1 {
                                friendName1.text = name
                                friends[1].email = email
                                friendName1.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage1)
                            }
                            
                            if friendID == 2 {
                                friendName2.text = name
                                friends[2].email = email
                                friendName2.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage2)
                            }

                            if friendID == 3 {
                                friendName3.text = name
                                friends[3].email = email
                                friendName3.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage3)
                            }
                            
                            if friendID == 4 {
                                friendName4.text = name
                                friends[4].email = email
                                friendName4.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage4)
                            }

                            if friendID == 5 {
                                friendName5.text = name
                                friends[5].email = email
                                friendName5.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage5)
                            }
                            
                            if friendID == 6 {
                                friendName6.text = name
                                friends[6].email = email
                                friendName6.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage6)
                            }

                            if friendID == 7 {
                                friendName7.text = name
                                friends[7].email = email
                                friendName7.sizeToFit()
                                self.uploadFriendProfile(email: email, view: friendImage7)
                            }
                            

                            friendID = friendID + 1
                                
                        }
                        
                       
                    }
                        
                }
                    
            }
        }
    
    func uploadFriendProfile(email: String, view: UIImageView) {
        let path = "image/" + email + "_profile_picture.png"
            
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case . success(let url):
                self?.downloadImage(imageView:view, url: url)
            case .failure(let error):
                print("Failed to get download url: \(error)")
            }
        })
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

}



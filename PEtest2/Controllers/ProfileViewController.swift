//
//  ProfileViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/30/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var NameTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        NameTextField.delegate = self
        
        loadInformation()

        // Do any additional setup after loading the view.
    }
    

    
    func loadInformation() {
//        ProfileName.text = ""
        NameTextField.text = ""

        db.collection("userName")
            .order(by:"DateTime")
            .getDocuments {(querySnapshot, error) in
            if let e = error {
                    print("There was an issue retrieving data from firestore, \(e)")
                } else {
                     if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let dataName = data["name"] as? String
                            let userEmail = data["email"] as? String
                                
                            DispatchQueue.main.async {
                                if userEmail == Auth.auth().currentUser?.email {
//                                    self.ProfileName.text = dataName
                                    self.NameTextField.placeholder = dataName
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func NamePressed(_ sender: UIButton) {
        if let NameText = NameTextField.text, let NameEmail = Auth.auth().currentUser?.email {
            db.collection("userName").addDocument(data: ["name":NameText,"email":NameEmail,"DateTime":Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NameTextField.endEditing(true)
        return true
    }
    
    @IBAction func BackgroundTap(_ sender: UITapGestureRecognizer) {
        NameTextField.resignFirstResponder()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SignupViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/28/21.
//

import UIKit
import Firebase

class SignupViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var checkMarkButton: UIButton!
    
    @IBOutlet weak var successfullyNotification: UILabel!
    
    @IBOutlet weak var signUpLogo: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var registerNotification: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController.navigationBar.barTintColor = [Purple];
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width/2.0

        emailTextField.delegate = self
        passwordTextField.delegate = self
        accountNameTextField.delegate = self
        successfullyNotification.isHidden = true
        checkMarkButton.isHidden = true

    }
    
//    @IBAction func signupBack(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: nil)
//    }
    
//    @IBAction func backToLogin(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "BackToLogin", sender: self)
//    }
    
    @IBAction func signupGo(_ sender: UIButton) {
        guard let userName = accountNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text,!userName.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            registerNotification.text = "Please enter all information to sign up"
            return
        }
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
                
            }
            guard !exists else {
                strongSelf.registerNotification.text = "This email has been registered already"
                return
            }
            
        })
    
        
//        if let userName = accountNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
//            DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
//                guard let strongSelf = self else {
//                    return
//                }
//                guard !exists else {
//                    strongSelf.registerNotification.text = "This email has been registered already"
//                    return
//                }
//
//            })
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                let AppUserInfo = AppUser(name: userName,emailAddress: email)
                DatabaseManager.shared.insertUser(with: AppUserInfo, completion: {success in
                    if success {
                        guard let image = self.profileImage.image, let data = image.pngData() else {
                            return
                        }

                        let fileName = AppUserInfo.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            case .success(let downloadUrl):
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage manager erroe:\(error)")
                            }

                        })
                    }

                })

                
                self.signUpLogo.isHidden = true
                self.signUpButton.isHidden = true
                self.accountNameTextField.isHidden = true
                self.emailTextField.isHidden = true
                self.passwordTextField.isHidden = true
                self.profileImage.isHidden = true
//                self.checkMark.isHidden = false
                self.successfullyNotification.isHidden = false
                self.checkMarkButton.isHidden = false
            }

            }
        
    }

    @IBAction func checkMark(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func profileTapped(_ sender: UITapGestureRecognizer) {
        presentPhotoActionSheet()
    }
    
    @IBAction func signUpBackgroundTap(_ sender: UITapGestureRecognizer) {
        registerNotification.text = ""
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        accountNameTextField.resignFirstResponder()
    }

}
extension SignupViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self]_ in
            self?.presentCamera()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
        
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage]  as? UIImage else {
            return
        }
        self.profileImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


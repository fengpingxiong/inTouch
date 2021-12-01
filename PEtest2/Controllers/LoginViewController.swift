//
//  ViewController.swift
//  PEtest2
//
//  Created by Feng ping xiong on 6/28/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var ForgetPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
//        self.navigationController?.isNavigationBarHidden = true
//        title = "inTouch"
        navigationController?.navigationBar.tintColor = hexStringToUIColor(hex: "#000000", Alpha:1.0)
//        #EB9D1E
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.barTintColor = hexStringToUIColor(hex: "#CF56F2", Alpha:0.1)

        validateAuth()
    }
    
    func validateAuth() {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loginGoToHome", sender: self)
        }
    }

//    @IBAction func signupButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goToSignup", sender: self)
//    }
    
    @IBAction func loginGo(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else {
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    self?.performSegue(withIdentifier: "loginGoToHome", sender: self)
                }
        }
        }
        
    }
    
    @IBAction func bgTap(_ sender: UITapGestureRecognizer) {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(emailField.text!)
//        print(passwordField.text!)
//        return true
//    }

    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any? ) {
//        if sender.didentifier == "goToSignup" {
//    }
    
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


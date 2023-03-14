//
//  RegisterViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    let spinner = JGProgressHUD(style: .dark)
    var iAgree:Bool = false {
        didSet {
            // Change button to checked
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 1

        // Do any additional setup after loading the view.
    }
    
    func generateRandomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomString = String((0..<5).map{ _ in letters.randomElement()! })
        let randomNumber = Int.random(in: 0...9)
        return randomString + String(randomNumber)
    }
    
    
    private func fieldsValidationAndUserAuth(){
        var username = usernameField.text!
        var password = passwordField.text!
        var email = emailField.text!
        var repeatPassword = repeatPasswordField.text!
        let uniqeID = generateRandomString()
         
        if password != repeatPassword {
            password = ""
            passwordField.attributedPlaceholder = NSAttributedString(
                string: "password",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
            )
            repeatPassword = ""
            repeatPasswordField.attributedPlaceholder = NSAttributedString(
                string: "password doesn't match",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)]
            )
        }
        if email.isValidEmail() {
            print("valid")
        } else {
            email = ""
            emailField.attributedPlaceholder = NSAttributedString(
                string: "email not valid",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)]
            )
        }
        if password.isValidPassword() {
            print("valid")
        } else {
            password = ""
            passwordField.attributedPlaceholder = NSAttributedString(
                string: "password not valid",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)]
            )
        }
        
        if iAgree{
            errorLabel.alpha = 0
        } else {
            errorLabel.textColor = .red
            errorLabel.alpha = 1
            errorLabel.text = "read and accept terms of services"
        }
        
        
        if email.isValidEmail() && password.isValidPassword() && password == repeatPassword && iAgree {
            spinner.show(in: view)
            
            DatabaseManager.shared.emailExsistCheck(with: email) { exists in
                guard !exists else {
                    // email exsists so shows error
                    self.errorLabel.text = "user already exsists"
                    self.errorLabel.alpha = 1
                    return
                }
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self!.spinner.dismiss()
                    }
                    
                    guard let result = authResult, error == nil else {
                        self?.errorLabel.text = "error creating user"
                        return
                    }
                    let user = result.user
                    DatabaseManager.shared.insertUser(with: User(username: username, emailAdress: email,uniqeID: uniqeID, profilePictureURL: "")) { success in
                        if success {
                            return
                        }
                    }
                    
                    print("user created \(user)")
                    strongSelf.dismiss(animated: true)
                    
                }
            }
            
        }

    }
    
    @IBAction func iAgreeButton(_ sender: Any) {
        if self.iAgree{
            self.iAgree = false
        }else {
            self.iAgree = true
        }
    }
    @IBAction func registerButton(_ sender: Any) {
        fieldsValidationAndUserAuth()
    }
    @IBAction func logInButton(_ sender: UIButton) {
        switchScreen(storyboardName: "Main", viewControllerName: "ViewController")
    }
    
}

//
//  ViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func signIn(){
        var email = usernameField.text!
        var password = passwordField.text!
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,completion:{ [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authResult, error == nil else {
                print("failed to log in")
                return
            }
            let user = result.user
            
            //save email to userdefaults
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(user.uid, forKey: "userUid")
            
            print("user: \(user) logged succesfully")

            strongSelf.dismiss(animated: true)
        })
    }

    @IBAction func signInButton(_ sender: UIButton) {
        signIn()
    }
    @IBAction func goToRegister(_ sender: Any) {
        switchScreen(storyboardName: "Main", viewControllerName: "RegisterViewController")
    }
    
}


//
//  FeedViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit
import FirebaseAuth
import SideMenu

protocol FeedViewControllerDelegate:class {
    func myVCDidFinish(_ controller: FeedViewControllerDelegate, text: String)
}


class FeedViewController: UIViewController, UINavigationControllerDelegate {
    weak var delegate: FeedViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        validateAuth()
        getUser()
        print("current user:\(FirebaseAuth.Auth.auth().currentUser)")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), landscapeImagePhone: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(openMenu))
    }
    
    // delegate
    
    
    // end of delegate
    
    var userUniqueID = String()
    
    private func getUser(){
        let email = UserDefaults.standard.string(forKey: "email")
        let safeEmail = DatabaseManager.safeEmail(email: email!)
        DatabaseManager.shared.getUserData(with: safeEmail) { [weak self] result in
            switch result{
            case .success(let user):
                print(user)
                self?.userUniqueID = user.uniqeID
            case .failure(let error):
                print("error1\(error)")
            }
        }
    }
    
    @objc func openMenu(){
        let menuBefore = MenuViewController()
        let menu = SideMenuNavigationController(rootViewController:menuBefore)
        menu.leftSide = true
        menu.delegate = self
        present(menu, animated: true, completion: nil)
        
    }
    
    

    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    private func logOutAlert(){
        let alertController = UIAlertController(title: "Sign out?", message: "You can always access your content by logging back", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        logOutAlert()
    }
}



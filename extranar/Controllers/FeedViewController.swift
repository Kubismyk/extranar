//
//  FeedViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit
import FirebaseAuth
import SideMenu


class FeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var isInRoom:Bool = false
    
    var userDefaults = UserDefaults.standard
    
    var partnerName:String = "" {
        didSet {
            self.title = partnerName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        validateAuth()
        getUser()
        designNConstraints()
        
        
        self.title = "you don't have loved one yet"
        print("current user:\(String(describing: FirebaseAuth.Auth.auth().currentUser))")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), landscapeImagePhone: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(openMenu))
    }
    
    
    
    
    var userUniqueID = String() {
        didSet {
            userDefaults.setValue(userUniqueID, forKey: "uniqueID")
        }
    }
    
    func loadData(){
        DatabaseManager.shared.loadRoom(with: userUniqueID) { success, otherUserTag in
            if success{
                print("users partner id: \(otherUserTag!)")
                DatabaseManager.shared.searchUserWithID(with: otherUserTag ?? "not foud") { partnerName in
                    self.partnerName = partnerName ?? "nil"
                }
            } else {
                print("failed to find room")
            }
        }
    }
    
    private func getUser(){
        let email = UserDefaults.standard.string(forKey: "email")
        let safeEmail = DatabaseManager.safeEmail(email: email!)
        DatabaseManager.shared.getUserData(with: safeEmail) { [weak self] result in
            switch result{
            case .success(let user):
                print(user.uniqeID)
                self?.userUniqueID = user.uniqeID
            case .failure(let error):
                print("error1\(error)")
            }
        }
    }
    
    // if menu unqiue id is nil restart app
    @objc func openMenu(){
        let menuBefore = MenuViewController()
        let menu = SideMenuNavigationController(rootViewController:menuBefore)
        menu.leftSide = true
        print(userUniqueID)
        loadData()
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
    
    @objc func createRoomButtonClick(){
        let alertController = UIAlertController(title: "Enter text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter text here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let text = textField.text {
                print("Entered text: \(text)")
                DatabaseManager.shared.createRoom(with: self.userUniqueID, otherUserTag: text) { success in
                    if success {
                        print("room created succesfully")
                    }
                }
            }
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        }
    
    
    func designNConstraints(){
        let createRoom = UIButton(frame: CGRect(x: 20, y: 0, width: 70, height: 40))
        createRoom.setTitle("Button", for: .normal)
        createRoom.backgroundColor = .blue
        createRoom.layer.cornerRadius = 5
        createRoom.layer.masksToBounds = true
        createRoom.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        createRoom.setTitleColor(.white, for: .normal)
        createRoom.setTitleColor(.gray, for: .highlighted)
        createRoom.titleLabel?.adjustsFontSizeToFitWidth = true
        createRoom.titleLabel?.minimumScaleFactor = 0.5
        createRoom.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        createRoom.frame.origin.y = UIScreen.main.bounds.height - 30 - createRoom.frame.size.height

        view.addSubview(createRoom)
        
        createRoom.addTarget(self, action: #selector(createRoomButtonClick), for: .touchUpInside)
        
        
        let imageView = UIImageView(image: UIImage(named: "main-hearth"))
        imageView.contentMode = .center // set the content mode to center
        imageView.translatesAutoresizingMaskIntoConstraints = false // disable the default autoresizing mask

        // add the image view as a subview of your view
        view.addSubview(imageView)

        // add constraints to center the image view within your view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageView.image!.size.width),
            imageView.heightAnchor.constraint(equalToConstant: imageView.image!.size.height)
        ])
    }
    
}



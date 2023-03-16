//
//  MenuViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit

class MenuViewController: UIViewController {
    
    let uniqueId = UserDefaults.standard.string(forKey: "uniqueID")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "menu-color")
        design()
    }
    

    private func design(){
        let imageView = UIImageView(image: UIImage(named: "main-hearth"))
        imageView.contentMode = .center // set the content mode to center
        imageView.translatesAutoresizingMaskIntoConstraints = false // disable the default autoresizing mask
        imageView.alpha = 0.7
        // add the image view as a subview of your view
        view.addSubview(imageView)

        // add constraints to center the image view within your view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageView.image!.size.width),
            imageView.heightAnchor.constraint(equalToConstant: imageView.image!.size.height)
        ])
        
        // Create a UIView
        let myView = UIView()

        // Set background color
        myView.backgroundColor = UIColor.white

        // Add constraints to the view
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myView)
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        myView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        // Create a UILabel
        let myLabel = UILabel()

        // Set the text for the label
        myLabel.text = "#\(self.uniqueId ?? "restartapp")"
        myLabel.font = UIFont.boldSystemFont(ofSize: 25)
        myLabel.textAlignment = .center

        // Add constraints to the label
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        myView.addSubview(myLabel)
        myLabel.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 0).isActive = true
        myLabel.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: 0).isActive = true
        myLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 0).isActive = true
        myLabel.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: 0).isActive = true

    }

}

//
//  MenuViewController.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import UIKit

class MenuViewController: UIViewController,FeedViewControllerDelegate {
    func myVCDidFinish(_ controller: FeedViewControllerDelegate, text: String) {
        print("received data: \(text)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        design()
    }
    

    private func design(){
        // Create a UIView
        let myView = UIView()

        // Set background color
        myView.backgroundColor = UIColor.white

        // Add constraints to the view
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myView)
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        myView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        // Create a UILabel
        let myLabel = UILabel()

        // Set the text for the label
        myLabel.text = "Hello World!"
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

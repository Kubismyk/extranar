//
//  DatabaseManager.swift
//  extranar
//
//  Created by Levan Charuashvili on 14.03.23.
//

import Foundation
import FirebaseDatabase

struct User{
    let username:String
    let emailAdress:String
    var profilePictureURL:String
    
    var safeEmail:String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}



final class DatabaseManager{
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(email:String) -> String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    static func unSafeEmail(safeEmail:String) -> String {
        var modifiedEmail = safeEmail.replacingOccurrences(of: "-", with: ".", range: nil)
        if let range = modifiedEmail.range(of: ".", options: .literal) {
            modifiedEmail.replaceSubrange(range, with: "@")
        }
        return modifiedEmail
    }
}

extension DatabaseManager {
    public func emailExsistCheck(with email:String, completion: @escaping ((Bool) -> Void)){
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func insertUser(with user:User, completion: @escaping (Bool) -> Void){
        database.child(user.safeEmail).setValue([
            "username":user.username,
            "pfp":user.profilePictureURL
        ]) { error, _ in
            guard error == nil else {
                print("failed to write data")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [[String:String]] {
                    let newElement = [
                        "name":user.username,
                        "mail":user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                    }
                }else {
                    let newCollection: [[String:String]] = [
                        [
                            "name":user.username,
                            "mail":user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                    }
                }
            }
            completion(true)
        }
    }
}

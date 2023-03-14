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
    let uniqeID:String
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
            "pfp":user.profilePictureURL,
            "uniqeID":user.uniqeID
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
                        "mail":user.safeEmail,
                        "uniqeID":user.uniqeID
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
                            "mail":user.safeEmail,
                            "uniqeID":user.uniqeID
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
    
    func getUserData(with email:String,completion: @escaping(Result<User, Error>) -> Void){
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let uniqueID = data["uniqeID"] as? String,
                  let username = data["username"] as? String,
                  let pfp = data["pfp"] as? String
            else {
                print("Error fetching unique ID for email: \(email)")
                return
            }
            // Do something with the unique ID
            var userData = User(username: username, emailAdress: "", uniqeID: uniqueID, profilePictureURL: "")
            print("Unique ID for email \(email) is: \(uniqueID),username:\(username),pfp:\(pfp)")
            completion(.success(userData))
        }
    }
}

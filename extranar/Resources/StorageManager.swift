//
//  StorageManager.swift
//  extranar
//
//  Created by Levan Charuashvili on 17.03.23.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    
    static let shared = StorageManager()
    public let storage = Storage.storage().reference()
    
    public typealias uploadProfilePictureCompletion = (Result<String, Error>) -> Void
    
    public func sendPhoto(with data: Data, fileName:String , completion: @escaping uploadProfilePictureCompletion) {
        storage.child("images/\(fileName)").putData(data) { metadata, error in
            guard error == nil else {
                print("## error uploading image...")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("## error downloading url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url: \(urlString)")
                completion(.success(urlString))
            }
            
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func requestDownload(for path:String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                print("## error downloading url: \(error?.localizedDescription ?? "")")
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            print("download url: \(url.absoluteString)")
            completion(.success(url))
        })
    }
    
}

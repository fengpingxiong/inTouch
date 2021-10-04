//
//  StorageManager.swift
//  PEtest2
//
//  Created by Feng ping xiong on 7/16/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager ()
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(with data: Data, fileName: String,completion: @escaping (Result<String, Error>) -> Void) {
        storage.child("image/\(fileName)").putData(data, metadata: nil,completion:{ metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("image/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
            
        })
    }
}

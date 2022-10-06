//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by Grazi  Berti on 06/10/22.
//

import Foundation
import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let imageDate = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = STORAGE_PROFILE_IMAGES.child("img/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageDate, metadata: nil) { meta, error in
            storageRef.downloadURL { url, err in
                guard let profileURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { autoDataResul, error in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = autoDataResul?.user.uid else { return }
                    
                    let values = ["email": credentials.email,
                                  "username": credentials.username,
                                  "fullname": credentials.fullname,
                                  "profileURL": profileURL
                                ]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                        print("DEBUG: Sucessfuly update user information ...")
                    }
                }
            }
        }
    }
    
}

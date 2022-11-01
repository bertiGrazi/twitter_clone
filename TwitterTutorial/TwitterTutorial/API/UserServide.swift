//
//  UserServide.swift
//  TwitterTutorial
//
//  Created by Grazielli Berti on 01/11/22.
//

import Firebase
import Foundation

struct UserServide {
    static let shared = UserServide()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: Snapshot \(snapshot)")
        }
    }
}

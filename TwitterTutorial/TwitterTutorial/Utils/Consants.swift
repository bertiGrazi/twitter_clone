//
//  Consants.swift
//  TwitterTutorial
//
//  Created by Grazielli Berti on 30/09/22.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

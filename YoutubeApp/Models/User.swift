//
//  User.swift
//  LoginWithFirebaseApp
//
//  Created by user on 2020/03/11.
//  Copyright © 2020 user. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User {
    var id: String
    let name: String
    let createdAt: Timestamp
    let email: String
    let favoriteAnimal: String
    let profileImageUrl: String
    var videoIds: [String] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let dic = document.data()
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
        self.favoriteAnimal = dic["favoriteAnimal"] as! String
        self.profileImageUrl = dic["profileImageUrl"] as! String
        if let videoIds = dic["videoId"] as? [String] {
        self.videoIds = videoIds
        }
    }
}

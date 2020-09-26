//
//  User.swift
//  LoginWithFirebaseApp
//
//  Created by Uske on 2020/03/11.
//  Copyright © 2020 Uske. All rights reserved.
//

import Foundation
import Firebase

struct User {

    let name: String
    let createdAt: Timestamp
    let email: String
    let favoriteAnimal: String
    let profileImageUrl: String
    var videoIds: [String] = []
//    var isLiked: Bool = false
//    var likes: [String] = []
    
    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
        self.favoriteAnimal = dic["favoriteAnimal"] as! String
        self.profileImageUrl = dic["profileImageUrl"] as! String
        if let videoIds = dic["videoId"] as? [String] {
            self.videoIds = videoIds
        }

//        if let likes = dic["likes"] as? [String] {
//            self.likes = likes
//        }
//        if let videoId = Auth.auth().currentUser?.uid {
//            // likesの配列の中にvideoIdが含まれているかチェックすることで、自分がいいねを押しているかを判断
//            if self.likes.firstIndex(of: videoId) != nil {
//                // uidがあれば、いいねを押していると認識する。
//                self.isLiked = true
//            }
//        }
    }
}

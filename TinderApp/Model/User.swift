//
//  User.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 1.01.2024.
//

import UIKit

struct User{
    
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageURLs: [String]
    var profession: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String

    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? []
        self.profession = dictionary["profession"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 40
        self.bio = dictionary["bio"] as? String ?? ""

    }
}

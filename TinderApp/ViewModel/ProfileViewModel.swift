//
//  ProfileViewModel.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 5.01.2024.
//

import UIKit

struct ProfileViewModel{
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let profession: String
    let bio: String
        
    var imageURLs: [URL]{
        return user.imageURLs.map({URL(string: $0)!})
    }
    
    var imageCount: Int{
        return user.imageURLs.count
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        attributedText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        userDetailsAttributedString = attributedText
        
        profession = user.profession
        
        bio = user.bio
    }
}

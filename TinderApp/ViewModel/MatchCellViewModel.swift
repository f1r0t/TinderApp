//
//  MatchCellViewModel.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 9.01.2024.
//

import Foundation

struct MatchCellViewModel{
    
    let nameText: String
    var profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        self.nameText = match.name
        self.profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid
    }
}

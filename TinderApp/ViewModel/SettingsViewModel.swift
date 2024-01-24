//
//  SettingsViewModel.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 3.01.2024.
//

import UIKit

enum SettingsSection: Int, CaseIterable{
    case name
    case profession
    case age
    case bio
    case ageRange
    
    var description: String{
        switch self {
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingsViewModel{
    
    private let user: User
    let section: SettingsSection
    
    let placeholderText: String
    var value: String?
    
    var shouldHideInputField: Bool{
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool{
        return section != .ageRange
    }
    
    var minAgeSliderValue: Float{
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float{
        return Float(user.maxSeekingAge)

    }
    
    func minAgeLabetText(forValue value: Float)-> String{
        return "Min \(Int(value))"
    }
    
    func maxAgeLabetText(forValue value: Float)-> String{
        return "Max \(Int(value))"
    }
    
    init(user: User, section: SettingsSection){
        self.user = user
        self.section = section
        placeholderText = "Enter \(section.description.lowercased()).."
        
        switch section {
        case .name:
            value = user.name
        case .profession:
            value = user.profession
        case .age:
            value = String(user.age)
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
    
}

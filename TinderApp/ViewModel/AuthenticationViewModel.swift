//
//  AuthenticationViewModel.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 2.01.2024.
//

import Foundation

protocol AuthenticationViewModel{
    var formIsValid: Bool{get}
}
struct LoginViewModel: AuthenticationViewModel{
    var email: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false && password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModel{
    var email: String?
    var fullname: String?
    var password: String?
    
    var formIsValid: Bool{
        return email?.isEmpty == false && fullname?.isEmpty == false && password?.isEmpty == false
    }
}

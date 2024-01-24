//
//  UserService.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 2.01.2024.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService{
    
    static func logUserIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping (Error?)->Void){
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let uid = result?.user.uid else{return}
                
                let data = ["email": credentials.email,
                            "fullname": credentials.fullname,
                            "imageURLs": [imageUrl],
                            "uid": uid,
                            "age": 18] as [String: Any]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}

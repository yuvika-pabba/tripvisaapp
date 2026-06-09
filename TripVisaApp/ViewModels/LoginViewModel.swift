//
//  LoginViewModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI
import FirebaseAuth
import UIKit

class LoginViewModel: ObservableObject {
    
    func isValid(String username: String, String password: String, completion: @escaping (Bool,String?) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password){authResult , error
            in
            if let error = error{
                print("Login failed:", error.localizedDescription)
                completion(false,"Login Failed")
            }else{
                completion(true,"Login Sucess")
            }
        }
    }
    
    func register(String username: String, String password: String, completion: @escaping (Bool,String?) -> Void){
        Auth.auth().createUser(withEmail: username, password: password){ authResult, error in
            if let error = error{
                print("Login failed:", error.localizedDescription)
                completion(false,"Login Failed")
            }else{
                completion(true,"Login Sucess")
            }
        }
    }
    
    func getCurrentUser() -> String {
        let current = Auth.auth().currentUser
        if let current = current{
            return current.uid
        }
        return UUID().uuidString   
    }
    
    func logout(completion: @escaping (Bool) -> Void){
        let firebase = Auth.auth()
        do {
            try firebase.signOut()
            completion(true)
        }
        catch{
            print("Cant Signout")
            completion(false)
        }
    }
    
    func changePassword(password : String,completion: @escaping (Bool) -> Void){
        let firebase = Auth.auth()
        firebase.currentUser?.updatePassword(to: password) { error in
            if let error = error {
                print("Error changing password: \(error)")
                completion(false)
            } else {
                print("Password changed.")
                completion(true)
            }
        }
    }
    
}




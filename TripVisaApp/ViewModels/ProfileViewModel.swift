//
//  ProfileViewModel.swift
//  TripVisaApp
//
//  Created by Prince on 4/19/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var currentUser : UserModel = UserModel()
    let db = Firestore.firestore()
    //register
    init() {
        self.currentUser = UserModel()
    }
    //login
    init(UUID: String) async {
        self.currentUser = UserModel() // Temporary initialization
        let document = db.collection("users").document(UUID)
        do {
            let data = try await document.getDocument()
            if data.exists {
                data.data().map { snapshot in
                    let userData: [String:Any] = [
                        "name": snapshot["name"] ?? "",
                        "email": snapshot["email"] ?? "",
                        "preferences": snapshot["preferences"] ?? [],
                        "invitations": snapshot["invitations"] ?? []
                    ]
                    self.currentUser = UserModel(id: UUID, data: userData)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    func pushUser(){
        db.collection( "users" ).document( currentUser.id ).setData( currentUser.toDict() )
    }
    
    func getCurrentUser() async -> [String:Any] {
        let currentuserid = LoginViewModel().getCurrentUser()
        let docRef = db.collection("users").document(currentuserid)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists{
                let data = document.data()
                if var data = data{
                    data["result"] = true
                    return data
                }else{
                    return ["result": false]
                }
            }
        } catch {
            print("Network Error")
            return ["result" : false]
        }
        return ["result" : false]
    }
    
    
    
}

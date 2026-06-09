//
//  UserModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI

struct UserModel{
    let id : String
    let email : String
    let name : String
    let preferences : [String]
    var invitations : [String]
    
    init() {
        self.id = ""
        self.email = ""
        self.name = ""
        self.preferences = []
        self.invitations = []
    }
    
    init(id : String, data: [String : Any]){
        self.id = id
        self.email = data["email"] as! String
        self.name = data["name"] as! String
        self.preferences = data["preferences"] as! [String]
        self.invitations = data["invitations"] as! [String]
    }
    
    func toDict() -> [String: Any]{
        [
            "name" : name,
            "email" : email,
            "preferences": preferences,
            "invitations" : invitations
        ]
    }
}

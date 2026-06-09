//
//  PlaceModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//
import SwiftUI

struct PlaceModel{
    let id: UUID = UUID()
    var name: String
    var image: [String : [String]]
    var description: String
    var location : [String : String]
    var Rating: [RatingModel]
    var tag: [UUID]
    
    init(){
        self.name = "name"
        self.image = [:]
        self.description = "description"
        self.location = [:]
        self.Rating = []
        self.tag = []
    }
    
    init(name: String, image: [String : [String]], description: String, location: [String : String], Rating: [RatingModel], tag: [UUID]) {
        self.name = name
        self.image = image
        self.description = description
        self.location = location
        self.Rating = Rating
        self.tag = tag
    }
}

struct RatingModel{
    let id: UUID = UUID()
    let user_id: UUID
    let description: String
    let Image: [String]
}

struct Review: Identifiable {
    let id = UUID()
    let author: String
    let rating: Double
    let text: String
    let time: Date
}

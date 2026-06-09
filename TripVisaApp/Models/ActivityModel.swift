//
//  ActivityModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI

struct ActivityModel{
    let id : UUID = UUID()
    let to : UUID
    let from : UUID
    let money : Double
    let datetime : Date
    let type : String
}

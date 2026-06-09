//
//  PreferenceModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI

struct PreferenceModel{
    let id : UUID = UUID()
    let title : String
    let icon : String
    let places: [UUID]
}

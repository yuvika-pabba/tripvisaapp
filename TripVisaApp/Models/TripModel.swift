//
//  TripModel.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//
import SwiftUI

struct TripModel: Identifiable, Codable {
    var id: String?
    var name: String
    var dateFrom: Date
    var dateTo: Date
    var destination: String
    var invitees: [String]
}

//
//  TripVisaAppUI.swift
//  TripVisaApp
//
//  Created by Prince on 4/20/25.
//


import SwiftUI

struct TripVisaAppUI: View {
  @Binding var isLoggedIn: Bool

  var body: some View {
    TabView {
      DashboardView()
        .tabItem { Image(systemName: "house.fill"); Text("Home") }

      AddTripView()
        .tabItem { Image(systemName: "plus"); Text("Add Trip") }

      ProfilePageView(isLoggedIn: $isLoggedIn)
        .tabItem { Image(systemName: "person"); Text("Profile") }
    }
  }
}

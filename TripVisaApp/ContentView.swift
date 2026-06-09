//
//  ContentView.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @State var loggedIn = false
    var body : some View {
        if (!loggedIn) {
            LoginView(isLoggedIn: $loggedIn)
        }else{
            TripVisaAppUI(isLoggedIn: $loggedIn)
        }
        
    }
}

#Preview {
    ContentView()
}

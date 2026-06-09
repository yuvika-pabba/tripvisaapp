//
//  TripVisaAppApp.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    GMSPlacesClient.provideAPIKey("AIzaSyAPk-KanXSRqOwbFA_O_wXU9XKJ3jIVsvU")
    let _ = Firestore.firestore()
    return true
  }
}

@main
struct TripVisaAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var locMgr   = LocationManager()
     @StateObject private var tripVM   = TripViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locMgr)
                .environmentObject(tripVM)
        }
    }
}

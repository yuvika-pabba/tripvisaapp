//
//  LocationManagerModel.swift
//  TripVisaApp
//
//  Created by Prince on 4/20/25.
//

import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var location: CLLocationCoordinate2D?
  @Published var authorizationStatus: CLAuthorizationStatus

  private let manager = CLLocationManager()

  override init() {
    self.authorizationStatus = manager.authorizationStatus
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    // 1) Ask for “when in use” permission
    manager.requestWhenInUseAuthorization()
    // 2) Start updates (will only run if authorized)
    manager.startUpdatingLocation()
  }

  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    self.authorizationStatus = status
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      manager.startUpdatingLocation()
    } else {
      manager.stopUpdatingLocation()
    }
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let loc = locations.first?.coordinate else { return }
    self.location = loc
    // if you only need one update, you can stop here:
    manager.stopUpdatingLocation()
  }
}

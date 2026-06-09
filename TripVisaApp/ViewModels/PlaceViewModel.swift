//
//  PlaceViewModel.swift
//  TripVisaApp
//
//  Created by Prince on 4/17/25.
//

// API : AIzaSyAPk-KanXSRqOwbFA_O_wXU9XKJ3jIVsvU
import SwiftUI
import MapKit
import GooglePlaces

// MARK: - ViewModel for Place Details
final class PlaceViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var editorialSummary: String? = nil
    @Published var rating: Double = 0
    @Published var userRatingsTotal: Int = 0
    @Published var photo: UIImage? = nil
    @Published var coordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    @Published var reviews: [Review] = []

    private let placeID: String
    private let fields: [GMSPlaceField] = [
        .name,
        .formattedAddress,
        .coordinate,
        .rating,
        .userRatingsTotal,
        .photos,
        .rating,
        .editorialSummary
    ]

    init(placeID: String) {
        self.placeID = placeID
        fetchDetails()
    }

    private func fetchDetails() {
        let mask = fields.reduce(0) { $0 | $1.rawValue }
        let request = GMSPlaceField(rawValue: mask)
        GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID,
                                           placeFields: request,
                                           sessionToken: nil) { [weak self] place, error in
            guard let self = self, let place = place, error == nil else {
                print("Failed to fetch place details: \(error?.localizedDescription ?? "Unknown error")")
                self?.isLoading = false
                return
            }
            DispatchQueue.main.async {
                self.name = place.name ?? ""
                self.address = place.formattedAddress ?? ""
                self.editorialSummary = place.editorialSummary
                self.rating = Double(place.rating)
                self.userRatingsTotal = Int(place.userRatingsTotal)
                self.coordinate = place.coordinate
                self.loadPhoto(from: place)
                self.loadReviews(from: place)
            }
        }
    }

    private func loadPhoto(from place: GMSPlace) {
        guard let metadata = place.photos?.first else {
            DispatchQueue.main.async { self.isLoading = false }
            return
        }
        GMSPlacesClient.shared().loadPlacePhoto(metadata) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.photo = image
                self?.isLoading = false
            }
        }
    }

    private func loadReviews(from place: GMSPlace) {
        guard let gpReviews = place.reviews else { return }
        self.reviews = gpReviews.compactMap { r in
            let author = r.authorAttribution?.name
                let text = r.originalText
            return Review(author: author ?? "",
                          rating: Double(r.rating),
                          text: text ?? "",
                          time: r.publishDate ?? Date())
        }
    }
}

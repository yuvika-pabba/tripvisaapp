import Foundation
import CoreLocation
import Combine

private struct AutocompleteRequest: Codable {
  let input: String
  let locationBias: LocationBias?
  let includeQueryPredictions: Bool?
  let origin: LatLng?
  struct LocationBias: Codable {
    let circle: Circle?
    struct Circle: Codable {
      let center: LatLng
      let radius: Double
    }
  }
  struct LatLng: Codable { let latitude: Double; let longitude: Double }
}

private struct AutocompleteResponse: Codable {
  let suggestions: [RawSuggestion]
  struct RawSuggestion: Codable {
    let placePrediction: PlacePrediction?
    let queryPrediction: QueryPrediction?
    struct PlacePrediction: Codable {
      let placeId: String
      let structuredFormat: StructuredFormat
      let distanceMeters: Int?
      enum CodingKeys: String, CodingKey {
        case placeId, structuredFormat, distanceMeters
      }
    }
    struct QueryPrediction: Codable { let text: TextStruct }
    struct StructuredFormat: Codable {
      let mainText: TextStruct
      let secondaryText: TextStruct?
      enum CodingKeys: String, CodingKey {
        case mainText, secondaryText
      }
    }
    struct TextStruct: Codable { let text: String }
  }
}

class SuggestionViewModel: ObservableObject {
  @Published var suggestions: [SuggestionModel] = []
  private var cancellables = Set<AnyCancellable>()

  func fetchSuggestions(query: String,
                        location: CLLocationCoordinate2D?,
                        includeQueries: Bool = true) {
    guard !query.isEmpty else {
      self.suggestions = []
      return
    }

    let req = AutocompleteRequest(
      input: query,
      locationBias: location.map {
        .init(circle: .init(center: .init(latitude: $0.latitude,
                                           longitude: $0.longitude),
                             radius: 5000))
      },
      includeQueryPredictions: includeQueries,
      origin: location.map {
        .init(latitude: $0.latitude, longitude: $0.longitude)
      }
    )

    guard let url = URL(string: "https://places.googleapis.com/v1/places:autocomplete") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json",    forHTTPHeaderField: "Content-Type")
    request.addValue("AIzaSyBsnjpgMchjOqvuTidmpZR1-Pr_Sc-9jlU", forHTTPHeaderField: "X-Goog-Api-Key")
    request.httpBody = try? JSONEncoder().encode(req)

    URLSession.shared.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: AutocompleteResponse.self, decoder: JSONDecoder())
      .map { resp in
        resp.suggestions.compactMap { raw in
          if let p = raw.placePrediction {
            return SuggestionModel(
              id:            p.placeId,
              primaryText:   p.structuredFormat.mainText.text,
              secondaryText: p.structuredFormat.secondaryText?.text,
              distanceMeters:p.distanceMeters,
              type:          .place,
              coordinate:    nil
            )
          } else if let q = raw.queryPrediction {
            return SuggestionModel(
              id:            q.text.text,
              primaryText:   q.text.text,
              secondaryText: nil,
              distanceMeters:nil,
              type:          .query,
              coordinate:    nil
            )
          }
          return nil
        }
      }
      .replaceError(with: [])
      .receive(on: DispatchQueue.main)
      .assign(to: \.suggestions, on: self)
      .store(in: &cancellables)
  }
}

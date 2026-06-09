import Foundation
import CoreLocation

enum SuggestionType: Hashable {
    case place
    case query
}

struct SuggestionModel: Identifiable, Hashable {
    let id: String
    let primaryText: String
    let secondaryText: String?
    let distanceMeters: Int?
    let type: SuggestionType
    let coordinate: CLLocationCoordinate2D?

    // Only use `id` for hashing & equality:
    static func ==(a: SuggestionModel, b: SuggestionModel) -> Bool { a.id == b.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

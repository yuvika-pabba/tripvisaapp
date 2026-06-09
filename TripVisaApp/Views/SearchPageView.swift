import SwiftUI
import CoreLocation

// 1) A tiny row view so the compiler doesn’t time out
struct SuggestionRowView: View {
  let suggestion: SuggestionModel
  var body: some View {
    VStack(alignment: .leading) {
      Text(suggestion.primaryText).font(.headline)
      if suggestion.type == .place,
         let sec = suggestion.secondaryText {
        Text(sec).font(.subheadline).foregroundColor(.secondary)
      }
      if suggestion.type == .place,
         let dist = suggestion.distanceMeters {
        Text("\(dist) m away").font(.caption).foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}

struct SearchPageView: View {
  @StateObject private var suggestionVM = SuggestionViewModel()
  @State private var searchText: String = ""
  @EnvironmentObject private var locationManager: LocationManager

  var body: some View {
    NavigationStack {
      VStack {
        TextField("Search places…", text: $searchText)
          .padding(8)
          .background(Color(.secondarySystemBackground))
          .cornerRadius(8)
          .padding()
          .onChange(of: searchText) { newValue in
            suggestionVM.fetchSuggestions(
              query: newValue,
              location: locationManager.location
            )
          }

        List {
          ForEach(suggestionVM.suggestions, id: \.id) { suggestion in
            NavigationLink {
                PlaceDetailView(placeID: suggestion.id)
            }label:{
                SuggestionRowView(suggestion:suggestion)
            }
          }
        }
        .listStyle(PlainListStyle())
        .navigationDestination(for: SuggestionModel.self) { suggestion in
            PlaceDetailView(placeID: suggestion.id)
        }
      }
      .navigationTitle("Search")
    }
  }
}

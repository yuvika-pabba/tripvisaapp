
import SwiftUI

struct DashboardView: View {
    // Now picked up from the root environment:
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var tripVM:           TripViewModel

    @StateObject private var suggestionVM = SuggestionViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Notifications & Current Trip
                    HStack {
                        Image(systemName: "message.fill").foregroundColor(.blue)
                        Text("NOTIFICATION").font(.caption).foregroundColor(.gray)
                        Spacer()
                        Text("9m ago").font(.caption).foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)

                    // CURRENT TRIP
                    if let currentTrip = tripVM.trips.first {
                        NavigationLink(destination: TripDetailsView(trip: currentTrip)) {
                            HStack {
                                Text("View / Edit Current Trip")
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }

                    // Quick Suggestions
                    Text("Suggestions For You")
                        .font(.headline)
                        .padding(.horizontal)

                    SuggestionListView(suggestions: suggestionVM.suggestions)
                }
                .padding()
            }
            .background(Color(red: 0.95, green: 0.96, blue: 0.98))
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: NotificationsView()) {
//                        Image(systemName: "bell.fill")
//                            .foregroundColor(.blue)
//                    }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SearchPageView()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Dashboard")
            .onAppear {
              suggestionVM.fetchSuggestions(query: "", location: locationManager.location)
            }
        }
    }
}

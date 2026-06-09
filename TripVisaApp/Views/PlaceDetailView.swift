import SwiftUI
import MapKit
import GooglePlaces
import FirebaseFirestore

struct PlaceDetailView: View {
    @EnvironmentObject private var tripVM: TripViewModel
    @StateObject private var viewModel: PlaceViewModel
    @State private var region: MKCoordinateRegion
    @State private var showingOptions = false
    @State private var showingNewTrip = false
    @State var isLoggedin = true

    init(placeID: String) {
        _viewModel = StateObject(wrappedValue: PlaceViewModel(placeID: placeID))
        _region = State(initialValue: MKCoordinateRegion(
            center: .init(latitude: 0, longitude: 0),
            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Place Photo
                        if let uiImage = viewModel.photo {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                        }

                        // Name & Address
                        Text(viewModel.name)
                            .font(.title).bold()
                            .multilineTextAlignment(.center)
                        Text(viewModel.address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        // Description / Summary
                        if let desc = viewModel.editorialSummary {
                            Text(desc)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 4)
                        }

                        // Rating Summary
                        HStack(spacing: 4) {
                            Label(String(format: "%.1f", viewModel.rating),
                                  systemImage: "star.fill")
                            Text("(\(viewModel.userRatingsTotal) reviews)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // Reviews List
                        if !viewModel.reviews.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reviews").font(.headline)
                                ForEach(viewModel.reviews) { review in
                                    ReviewRow(review: review)
                                    Divider()
                                }
                            }
                            .padding(.top, 8)
                        }

                        // Interactive Map
                        Map(
                            coordinateRegion: $region,
                            annotationItems: [Annotation(coordinate: viewModel.coordinate)]
                        ) { annotation in
                            MapMarker(coordinate: annotation.coordinate, tint: .blue)
                        }
                        .frame(height: 250)
                        .cornerRadius(12)
                        .onAppear {
                            region.center = viewModel.coordinate
                        }

                        // Add to Trips button
                        Button {
                            showingOptions = true
                        } label: {
                            Label("Add to Trips", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
        // ── attach confirmationDialog & sheet here ──
        .confirmationDialog(
            "Add \(viewModel.name) to…",
            isPresented: $showingOptions,
            titleVisibility: .visible
        ) {
            if let current = tripVM.currentTrip, let tripId = current.id {
                Button("“\(current.name)”") {
                  Task {
                    // CORRECT:
                    await tripVM.addInvitations(
                      emails: current.invitees,
                      tripId: tripId
                    )
                    tripVM.addDestination(
                      to: current,
                      destination: viewModel.name,
                      invitees: current.invitees
                    )
                  }
                }
            }
            Button("New Trip") {
                showingNewTrip = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showingNewTrip) {
            AddTripView(initialDestination: viewModel.name)
                .environmentObject(tripVM)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReviewRow: View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.author)
                    .font(.subheadline).bold()
                Spacer()
                Label(String(format: "%.1f", review.rating),
                      systemImage: "star.fill")
                    .font(.caption)
            }
            Text(review.text).font(.body)
            Text(review.time, style: .date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

private struct Annotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

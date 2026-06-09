import SwiftUI
import FirebaseFirestore

// MARK: - Trip Model

// MARK: - Trip ViewModel
class TripViewModel: ObservableObject {
    @Published var trips: [TripModel] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    /// Currently active trip: one whose end date is in the future, or the most recent
    var currentTrip: TripModel? {
        trips.first(where: { $0.dateTo >= Date() }) ?? trips.first
    }

    init() {
        fetchTrips()
    }

    deinit {
        listener?.remove()
    }

    /// Listen for realtime updates to the 'trips' collection
    private func fetchTrips() {
        listener = db.collection("trips")
            .order(by: "dateFrom", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let docs = snapshot?.documents else {
                    print("Error fetching trips: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
                    self.trips = try docs.compactMap { try $0.data(as: TripModel.self) }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
    }

    /// Create a new trip document
    func addTrip(name: String,
                 from: Date,
                 to: Date,
                 destination: String = "",
                 invitees: [String] = []) {
        let newTrip = TripModel(id: nil,
                                name: name,
                                dateFrom: from,
                                dateTo: to,
                                destination: destination,
                                invitees: invitees)
        do {
            _ = try db.collection("trips").addDocument(from: newTrip)
        } catch {
            print("Error adding trip: \(error)")
        }
    }

    /// Update an existing trip with a destination and invitees
    func addDestination(to trip: TripModel,
                        destination: String,
                        invitees: [String]) {
        guard let id = trip.id else { return }
        db.collection("trips").document(id).updateData([
            "destination": destination,
            "invitees": invitees
        ])
    }
    // In TripViewModel.swift
    func addInvitations(emails: [String], tripId: String) async {
        for rawEmail in emails {
            let email = rawEmail
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            do {
                // 1) Find the matching user docs
                let snapshot = try await db.collection("users")
                    .whereField("email", isEqualTo: email)
                    .getDocuments()

                guard !snapshot.documents.isEmpty else {
                    print("⚠️ No user found for email “\(email)”")
                    continue
                }

                // 2) For each matching user, load their ProfileViewModel,
                //    mutate its invitations array, then pushUser() back to Firestore
                for doc in snapshot.documents {
                    let uid = doc.documentID
                    // async init will fetch their current data (including invitations)
                    let profileVM = await ProfileViewModel(UUID: uid)

                    // append the new trip ID
                    profileVM.currentUser.invitations.append(tripId)

                    // push the entire user object back to Firestore
                    profileVM.pushUser()

                    print("Invited user \(uid) to trip \(tripId)")
                }

            } catch {
                print(" Error fetching/inviting “\(email)”: \(error)")
            }
        }
    }

        
}


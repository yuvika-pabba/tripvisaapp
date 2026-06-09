import SwiftUI
import Foundation

struct TripDetailsView: View {
    @EnvironmentObject var tripVM: TripViewModel
    var trip: TripModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Title & Dates
                Text(trip.name)
                    .font(.largeTitle)
                    .bold()

                Text("\(trip.dateFrom, formatter: dateFormatter) to \(trip.dateTo, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Destination
                Section(header: Text("Destination").font(.headline)) {
                    Text(trip.destination)
                }

                // Invitees
                if !trip.invitees.isEmpty {
                    Section(header: Text("Invited Friends").font(.headline)) {
                        ForEach(trip.invitees, id: \.self) { email in
                            Text(email)
                                .font(.body)
                        }
                    }
                }

                // Itinerary (if present)
//                if let itinerary = trip., !itinerary.isEmpty {
//                    Section(header: Text("Itinerary").font(.headline)) {
//                        ForEach(itinerary.sorted(by: { $0.key < $1.key }), id: \.key) { (destID, date) in
//                            HStack {
//                                Text("Stop \(destID.uuidString.prefix(4)) at")
//                                Spacer()
//                                Text("\(date, formatter: dateFormatter)")
//                            }
//                        }
//                    }
//                }

                // Action Buttons
//                HStack {
//                    NavigationLink(destination: SplitExpensesView(trip: trip)) {
//                        Label("Split Expenses", systemImage: "dollarsign.circle")
//                    }
//                    Spacer()
//                    NavigationLink(destination: UpdateBalanceView(trip: trip)) {
//                        Label("Balance", systemImage: "chart.bar")
//                    }
//                }
//                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Trip Details")
    }
}

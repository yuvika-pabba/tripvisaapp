import SwiftUI

struct AddTripView: View {
    @EnvironmentObject private var tripVM: TripViewModel
    @Environment(\.presentationMode) private var presentationMode

    // If coming from PlaceDetailView, this will be pre‑filled
    let initialDestination: String?

    @State private var name: String = ""
    @State private var destination: String
    @State private var fromDate: Date = Date()
    @State private var toDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State private var invitees: [String] = [""]

    init(initialDestination: String? = nil) {
        self.initialDestination = initialDestination
        _destination = State(initialValue: initialDestination ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Trip Details")) {
                    TextField("Trip Name", text: $name)
                    DatePicker("From", selection: $fromDate, displayedComponents: .date)
                    DatePicker("To", selection: $toDate, displayedComponents: .date)
                }

                Section(header: Text("Destination")) {
                    TextField("Destination", text: $destination)
                        // lock it if it was pre‑filled
                        .disabled(initialDestination != nil)
                    if initialDestination == nil {
                        // you could navigationLink to SearchPageView here
                        NavigationLink("Pick on Map…", destination: SearchPageView())
                    }
                }

                Section(header: Text("Invite Friends")) {
                    ForEach(invitees.indices, id: \.self) { idx in
                        HStack {
                            TextField("Email", text: $invitees[idx])
                                .keyboardType(.emailAddress)
                            if invitees.count > 1 {
                                Button {
                                    invitees.remove(at: idx)
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    Button {
                        invitees.append("")
                    } label: {
                        Label("Add Invitee", systemImage: "plus.circle.fill")
                    }
                }

                Button("Save Trip") {
                    tripVM.addTrip(
                        name: name,
                        from: fromDate,
                        to: toDate,
                        destination: destination,
                        invitees: invitees.filter { !$0.isEmpty }
                    )
                    
                    
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || destination.isEmpty)
            }
            .navigationTitle("New Trip")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

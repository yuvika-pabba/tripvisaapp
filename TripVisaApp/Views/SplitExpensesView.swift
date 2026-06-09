

import SwiftUI

struct SplitExpensesView: View {
    @EnvironmentObject var tripVM: TripViewModel
    var trip: TripModel

    @State private var amount: String = ""
    @State private var desc: String = ""
    @State private var date: Date = Date()

    var body: some View {
        Form {
            Section(header: Text("New Expense")) {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $desc)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Button("Add Expense") {
//                    addExpense()
                }
                .disabled(amount.isEmpty || desc.isEmpty)
            }
            Section(header: Text("Expenses")) {
//                ForEach(trip.Acitivities,id:\.id) { activity in
//                    HStack {
//                        Text(activity.type)
//                        Spacer()
//                        Text("$\(activity.money, specifier: "%.2f")")
//                    }
                //}
            }
        }
        .navigationTitle("Split Expenses")
    }

//    func addExpense() {
//        guard let amt = Double(amount) else { return }
//        let activity = ActivityModel(to: trip.members.first ?? UUID(), from: UUID(), money: amt, datetime: date, type: desc)
//        if let idx = tripVM.trips.firstIndex(where: { $0.id == trip.id }) {
////            tripVM.trips[idx].Acitivities.append(activity)
//        }
//        amount = ""
//        desc = ""
//    }
}

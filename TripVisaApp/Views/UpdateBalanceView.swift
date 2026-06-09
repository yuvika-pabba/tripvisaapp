

import SwiftUI

struct UpdateBalanceView: View {
    var trip: TripModel

    struct Balance: Identifiable {
        let id = UUID()
        let memberName: String
        let amount: Double
    }

    var body: some View {
        List(calculateBalances()) { bal in
            HStack {
                Text(bal.memberName)
                Spacer()
                Text("$\(bal.amount, specifier: "%.2f")")
            }
        }
        .navigationTitle("Balances")
    }

    func calculateBalances() -> [Balance] {
        var balances: [UUID: Double] = [:]
//        for member in trip.invitees {
//            balances[member] = 0
//        }
//        for activity in trip.Acitivities {
//            balances[activity.from, default: 0] -= activity.money
//            balances[activity.to, default: 0] += activity.money
//        }
        return balances.map { Balance(memberName: String($0.key.uuidString.prefix(4)), amount: $0.value) }
    }
}

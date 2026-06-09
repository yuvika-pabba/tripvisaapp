//
//  NotificationView.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//
import SwiftUI

struct NotificationsView: View {
    let notifications = [
        "Sanjana has invited you to Barcelona Trip",
        "Dev has invited you to London Trip",
        "Samskruthi has invited you to Paris Trip",
        "Mayank has invited you to Mumbai Trip"
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Notifications")
                .font(.title)
                .bold()
                .padding()

            ForEach(notifications, id: \.self) { note in
                HStack(alignment: .top) {
                    VStack(spacing: 5) {
                        Image(systemName: "checkmark.circle")
                        Image(systemName: "xmark.circle")
                    }
                    Text(note)
                        .font(.body)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
            }
            Spacer()
        }
        .padding()
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
    }
}

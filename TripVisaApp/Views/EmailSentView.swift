//
//  EmailSentView.swift
//  TripVisaApp
//
//  Created by Prince on 3/30/25.
//

import SwiftUI
struct EmailSentView: View {
    @State private var code = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()

            Text("Please check your email\nfor a code to create or sign in to your account")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("Enter code here", text: $code)
                .padding()
                .background(Color.white)
                .cornerRadius(10)

            Button("Enter") {
                // Verify code logic
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.43, green: 0.48, blue: 0.60))
            .foregroundColor(.white)
            .cornerRadius(25)
            Spacer()
        }
        .padding()
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .navigationTitle("Email Sent")
        .navigationBarTitleDisplayMode(.inline)
    }
}


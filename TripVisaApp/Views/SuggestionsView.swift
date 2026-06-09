//
//  SuggestionsView.swift
//  TripVisaApp
//
//  Created by Prince on 4/20/25.
//

import SwiftUI

/// A reusable suggestions list/carousel.
/// - `places`: your array of Place (or PlaceModel) objects.
/// - `orientation`: `.horizontal` for a carousel, `.vertical` for a scrolling list.
struct SuggestionsView<Place: Identifiable>: View {
    enum Orientation { case horizontal, vertical }
    
    let places: [Place]
    let orientation: Orientation
    
    /// Extract a name & subtitle via keypaths so this stays generic:
    let titleKeyPath: KeyPath<Place, String>
    let subtitleKeyPath: KeyPath<Place, String?>
    
    var body: some View {
        ScrollView(
            orientation == .horizontal ? .horizontal : .vertical,
            showsIndicators: false
        ) {
            if orientation == .horizontal {
                HStack(spacing: 15) {
                    ForEach(places) { p in
                        card(for: p)
                    }
                }
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(places) { p in
                        card(for: p)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private func card(for p: Place) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(p[keyPath: titleKeyPath])
                .font(.headline)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            if let sub = p[keyPath: subtitleKeyPath] {
                Text(sub)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .frame(
            width: orientation == .horizontal ? 150 : nil,
            alignment: .leading
        )
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

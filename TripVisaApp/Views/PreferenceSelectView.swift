import SwiftUI

/// A view that lets the user select their preferred types of destinations after registration, displayed as icon-decorated cards with Back and Next buttons matching the app's theme.
struct PreferenceView: View {
    /// The available destination categories with corresponding SF Symbol icons
    private let categoryIcons: [String: String] = [
        "Beach": "sun.max.fill",
        "Mountain": "mountain.2.fill",
        "City": "building.2.fill",
        "Historical": "book.closed.fill",
        "Adventure": "map.fill",
        "Nature": "leaf.fill",
        "Cultural": "theatermasks.fill",
        "Relaxation": "bed.double.fill"
    ]
    private var categories: [String] { Array(categoryIcons.keys) }

    /// The set of selected categories
    @State private var selectedCategories: Set<String> = []

    /// Callback when user taps Back
    var onBack: (() -> Void)?
    /// Callback when user taps Next
    var onNext: ((Set<String>) -> Void)?

    var body: some View {
        VStack {
            Text("Select Your Preferences")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 20
                ) {
                    ForEach(categories, id: \.self) { category in
                        let isSelected = selectedCategories.contains(category)
                        VStack(spacing: 12) {
                            Image(systemName: categoryIcons[category] ?? "star.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.top, 10)
                                .foregroundColor(isSelected ? Color.accentColor : Color.gray)
                            Text(category)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 10)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(isSelected ? Color.accentColor.opacity(0.2) : Color(UIColor.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            if isSelected {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }

            HStack(spacing: 16) {
                Button(action: { onBack?() }) {
                    Text("Back")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: { onNext?(selectedCategories) }) {
                    Text("Next")
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(selectedCategories.isEmpty ? Color(UIColor.secondarySystemBackground) : Color.accentColor)
                .disabled(selectedCategories.isEmpty)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#if DEBUG
struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(
            onBack: { print("Back tapped") },
            onNext: { prefs in print("Preferences: \(prefs)") }
        )
    }
}
#endif

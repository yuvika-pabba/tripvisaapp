import SwiftUI

struct SuggestionListView: View {
  let suggestions: [SuggestionModel]
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 15) {
        ForEach(suggestions, id: \.id) { suggestion in
          VStack(alignment: .leading) {
            Text(suggestion.primaryText).bold().font(.subheadline)
            if let sub = suggestion.secondaryText {
              Text(sub).font(.caption).foregroundColor(.secondary)
            }
          }
          .padding()
          .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 2))
        }
      }
      .padding(.horizontal)
    }
  }
}

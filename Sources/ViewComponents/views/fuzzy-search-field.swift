import SwiftUI
import plate
import Structures

public struct FuzzySearchField: View {
    @Binding public var searchQuery: String
    @Binding public var searchStrictness: SearchStrictness
    public let title: String
    public var hideStrictness: Bool

    public init(
        title: String? = nil,
        searchQuery: Binding<String>,
        searchStrictness: Binding<SearchStrictness>,
        hideStrictness: Bool = false
    ) {
        self._searchQuery = searchQuery
        self._searchStrictness = searchStrictness
        self.title = title ?? "Search"
        self.hideStrictness = hideStrictness
    }

    public var body: some View {
        HStack(spacing: 8) {
            TextField(title, text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !hideStrictness {
                HStack(spacing: 4) {
                    ForEach(SearchStrictness.allCases) { level in
                        Text(level.title)
                        .font(.caption2)
                        .padding(.vertical, 4)
                        // .padding(.horizontal, 6)
                        .padding(.horizontal, 6)
                        .background(
                            searchStrictness == level
                                ? Color.accentColor.opacity(0.2)
                                : Color.secondary.opacity(0.1)
                        )
                        .cornerRadius(4)
                        .onTapGesture {
                            searchStrictness = level
                        }
                        .frame(minWidth: 50)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

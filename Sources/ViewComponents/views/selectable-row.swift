import Foundation
import SwiftUI
import plate

public struct SelectableRow: View {
    public let title: String
    public let subtitle: String?
    public let isSelected: Bool
    public let isDisabled: Bool
    public let action: () -> Void
    public let animationDuration: TimeInterval

    public init(
        title: String,
        subtitle: String? = nil,
        isSelected: Bool,
        isDisabled: Bool = false,
        animationDuration: Double = 0.2,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.animationDuration = animationDuration
        self.action = action
    }

    public var body: some View {
        HStack {
            if isSelected {
                Text(title)
                // .font(.headline)
                // .foregroundColor(Color("NearBlack"))
                .foregroundColor(Color.primary)
                // .bold()
                .strikethrough(isDisabled, color: .gray)

                if let sub = subtitle {
                    Text(sub)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(Color.secondary)
                }
            } else {
                Text(title)
                // .font(.headline)
                // .foregroundColor(Color("NearBlack"))
                // .foregroundColor(isSelected ? Color.black : Color.secondary)
                .foregroundColor(Color.secondary)
                .strikethrough(isDisabled, color: .gray)

                if let sub = subtitle {
                    Text(sub)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundColor(Color.secondary)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(
            isSelected
                ? Color.blue.opacity(0.3)
                : Color.clear
        )
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        // .shadow(
        //     color: isSelected ? Color.blue.opacity(0.1) : Color.white,
        //     radius: 2
        // )
        .contentShape(RoundedRectangle(
            cornerRadius: 5
        ))
        .onTapGesture {
            if !isDisabled {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    action()
                }
            // action()
            }
        }
    }
}

import Foundation
import SwiftUI
import plate

public struct ColorStyleConfiguration: Sendable {
    public let color: Color?
    public let foregroundColor: Color?
    
    public init(
        color: Color? = nil,
        foregroundColor: Color? = nil
    ) {
        self.color = color
        self.foregroundColor = foregroundColor
    }
}

public struct ButtonAppearanceConfiguration: Sendable {
    public let image: String?
    public let color: ColorStyleConfiguration?
    public let escapeColor: ColorStyleConfiguration?
    
    public init(
        image: String? = nil,
        color: ColorStyleConfiguration? = nil,
        escapeColor: ColorStyleConfiguration? = nil
    ) {
        self.image = image
        self.color = color
        self.escapeColor = escapeColor
    }
}

public struct StandardButton: View {
    public let type: StandardButtonType
    public let title: String
    public let subtitle: String
    public let action: () -> Void
    public let animationDuration: TimeInterval
    // public let image: String?
    public let appearance: ButtonAppearanceConfiguration?

    @State private var isPressed: Bool = false
    @Environment(\.isEnabled) private var isEnabled: Bool

    public init(
        type: StandardButtonType,
        title: String,
        subtitle: String = "",
        animationDuration: Double = 0.2,
        action: @escaping () -> Void,
        // image: String? = nil
        appearance: ButtonAppearanceConfiguration? = nil
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.animationDuration = animationDuration
        self.action = action
        // self.image = image
        self.appearance = appearance
    }

    private var buttonColor: Color {
        if let color = self.appearance?.color?.color {
            return color
        } else {
            switch type {
            case .clear:
                return Color.gray.opacity(0.2)
            case .load, .copy:
                return Color.gray
            case .submit:
                return Color.blue
            case .execute:
                return Color.orange
            case .delete:
                return Color.red
            }
        }
    }

    private var foregroundColor: Color {
        if let foreground = self.appearance?.color?.foregroundColor {
            return foreground
        } else {
            switch type {
            case .clear, .load, .copy:
                return Color.primary
            case .execute:
                return Color.black
            case .submit, .delete:
                return Color.white
            }
        }
    }

    private var imageSystemName: String {
        if let image = self.appearance?.image {
            return image
        } else {
            switch type {
            case .copy:
                return "document.on.document"
            case .clear:
                return "xmark.circle"
            case .load:
                return "square.and.arrow.down.on.square"
            case .submit:
                return "paperplane.fill"
            case .execute:
                return "apple.terminal"
            case .delete:
                return "trash.fill"
            }
        }
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: imageSystemName)
                    .font(.headline)
                    .accessibilityHidden(true)

                Text(title)
                    .font(.subheadline)
                    .bold()
            }
            .foregroundColor(foregroundColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(buttonColor)
            .cornerRadius(8)
            .scaleEffect(isPressed ? 0.90 : 1.0)
            .opacity(isEnabled ? 1 : 0.4)
            .animation(.easeInOut(duration: animationDuration), value: isPressed)

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .allowsHitTesting(isEnabled)
        .gesture(
            DragGesture(minimumDistance: 0)
            .onChanged { _ in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    isPressed = true
                }
            }
            .onEnded { _ in
                withAnimation(.easeInOut(duration: animationDuration)) {
                    isPressed = false
                }
                action()
            }
        )
    }
}

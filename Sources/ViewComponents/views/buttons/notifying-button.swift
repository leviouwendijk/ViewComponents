import Foundation
import SwiftUI
import plate

public enum NotificationBannerPosition {
    case above
    case under
    case left
    case right
}

public struct StandardNotifyingButton: View {
    public let type: StandardButtonType
    public let title: String
    public let subtitle: String
    public let action: () -> Void
    public let animationDuration: TimeInterval
    @ObservedObject public var notifier: NotificationBannerController
    public let notifierPosition: NotificationBannerPosition

    @State private var isPressed: Bool = false
    @Environment(\.isEnabled) private var isEnabled: Bool

    public init(
        type: StandardButtonType,
        title: String,
        subtitle: String = "",
        animationDuration: Double = 0.2,
        action: @escaping () -> Void,
        notifier: NotificationBannerController,
        notifierPosition: NotificationBannerPosition = .under
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.animationDuration = animationDuration
        self.action = action
        self._notifier = ObservedObject(wrappedValue: notifier)
        self.notifierPosition = notifierPosition
    }

    private var buttonColor: Color {
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

    private var foregroundColor: Color {
        switch type {
        case .clear, .load, .copy:
            return Color.primary
        case .execute:
            return Color.black
        case .submit, .delete:
            return Color.white
        }
    }

    private var imageSystemName: String {
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

    public func isNotPosition(_ position: NotificationBannerPosition) -> Bool {
        return !(self.notifierPosition == position)
    }

    public var body: some View {
        // HStack {
        //     NotificationBanner(
        //         type: notifier.style,
        //         message: notifier.message
        //     )
        //     .hide(when: notifier.hide)
        //     .hide(when: isNotPosition(.left))

            VStack {
                // NotificationBanner(
                //     type: notifier.style,
                //     message: notifier.message
                // )
                // .hide(when: notifier.hide)
                // .hide(when: isNotPosition(.above))


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

                NotificationBanner(
                    type: notifier.style,
                    message: notifier.message
                )
                .hide(when: notifier.hide)
                .hide(when: isNotPosition(.under))
            }

            // NotificationBanner(
            //     type: notifier.style,
            //     message: notifier.message
            // )
            // .hide(when: notifier.hide)
            // .hide(when: isNotPosition(.right))
        // }
    }
}

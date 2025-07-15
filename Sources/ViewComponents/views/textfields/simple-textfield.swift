import Foundation
import SwiftUI
import plate

public struct SimpleTextField: View {
    public let label: String?
    public let placeholder: String?
    public let helperText: String?
    public let icon: String?
    public let maxWidth: CGFloat?
    public let validation: ValidationType?
    public let hideLabel: Bool
    public let placeholderLabelSuffix: Bool

    @Binding public var text: String
    @FocusState private var isFocused: Bool
    @State private var validationMessage: String?

    public var placeholderFormatted: String? {
        if let placeholder {
            let base = "\"" + placeholder + "\""
            let suffixed = base + " (" + (label ?? "") + ")"
            return placeholderLabelSuffix ? suffixed : base 
        }
        else {
            return nil
        }
    }

    public init(
        _ label: String? = nil,
        text: Binding<String>,
        placeholder: String? = nil,
        helperText: String? = nil,
        icon: String? = nil,
        maxWidth: CGFloat? = nil,
        validation: ValidationType? = nil,
        hideLabel: Bool = false,
        placeholderLabelSuffix: Bool = false
    ) {
        self.label               = label
        self._text               = text
        self.placeholder         = placeholder
        self.helperText          = helperText
        self.icon                = icon
        self.maxWidth            = maxWidth
        self.validation = validation
        self.hideLabel = hideLabel
        self.placeholderLabelSuffix = placeholderLabelSuffix
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !hideLabel {
            Text(label ?? "")
                .font(.subheadline)
                .bold()
                .opacity(0.8)
            }

            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                }

                ZStack(alignment: .leading) {
                    if text.isEmpty, let placeholder {
                        Text(placeholderFormatted ?? placeholder)
                            .foregroundColor(.secondary)
                            .padding(.leading, 1)
                    }
                    TextField("", text: $text)
                        .font(.body)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($isFocused)
                        // .onChange(of: text) { newValue in
                        //     validate(newValue)
                        // }
                        .onSubmit {
                            validate(text)
                        }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            )

            if let msg = validationMessage {
                Text(msg)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: maxWidth)
        // .animation(.easeInOut, value: validationMessage)
        .onAppear { validate(text) }
    }

    private var borderColor: Color {
        if isFocused { return .accentColor }
        if let _ = validation, let msg = validationMessage, !msg.isEmpty {
            return .red
        }
        return .gray
    }

    private func validate(_ input: String) {
        guard let validation = validation, !input.isEmpty else {
            validationMessage = nil
            return
        }
        let result = validation.validate(input)
        validationMessage = result.message
    }
}

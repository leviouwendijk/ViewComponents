import SwiftUI

public struct EnumDropdown<Option>: View
where
    Option: CaseIterable & Hashable & RawRepresentable,
    Option.RawValue == String
{
    @Binding public var selected: Option
    @State private var isExpanded: Bool = false

    public let labelWidth: CGFloat
    public let maxListHeight: CGFloat

    public init(
        selected: Binding<Option>,
        labelWidth: CGFloat = 100,
        maxListHeight: CGFloat = 200
    ) {
        self._selected = selected
        self.labelWidth = labelWidth
        self.maxListHeight = maxListHeight
    }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text(selected.rawValue.capitalized)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)          // same as WA
                .padding(.horizontal, 8)        // fill out the tap area
                .frame(minWidth: labelWidth, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.windowBackgroundColor)) // fill BG
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.secondary.opacity(0.6), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .contentShape(Rectangle())         // entire frame is tappable

            // MARK: List
            if isExpanded {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(Option.allCases), id: \.self) { option in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selected = option
                                        isExpanded = false
                                    }
                                }) {
                                    Text(option.rawValue.capitalized)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 8)
                                }
                                .disabled(option == selected)
                            }
                        }
                    }
                    .frame(maxHeight: maxListHeight)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.windowBackgroundColor))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                }
                .offset(y: 44)
                .zIndex(1)
            }
        }
    }
}

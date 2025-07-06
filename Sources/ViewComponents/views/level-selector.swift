import SwiftUI

public struct LevelSelector: View {
    @Binding public var level: Int
    public let maxLevel: Int
    public let activeColor: Color
    public let inactiveColor: Color
    public let tileSize: CGSize
    public let spacing: CGFloat

    public init(
        level: Binding<Int>,
        maxLevel: Int = 5,
        activeColor: Color = .accentColor,
        inactiveColor: Color = .gray.opacity(0.3),
        tileSize: CGSize = CGSize(width: 32, height: 32),
        spacing: CGFloat = 8
    ) {
        self._level = level
        self.maxLevel = maxLevel
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.tileSize = tileSize
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxLevel, id: \.self) { idx in
                Rectangle()
                    .fill(idx <= level ? activeColor : inactiveColor)
                    .frame(width: tileSize.width, height: tileSize.height)
                    .cornerRadius(4)
                    .onTapGesture {
                        if idx == level {
                            level = max(0, level - 1)
                        } else {
                            level = idx
                        }
                    }
            }
        }
    }
}

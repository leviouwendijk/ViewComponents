import SwiftUI
import AppKit

enum CodeEditorMode {
    case normal
    case insert
    case visual
}

public struct VimCodeEditor: NSViewRepresentable {
    @Binding public var text: String
    public var font: NSFont
    public var textColor: NSColor
    public var backgroundColor: NSColor

    public init(
        text: Binding<String>,
        font: NSFont = .monospacedSystemFont(ofSize: 14, weight: .regular),
        textColor: NSColor = .labelColor,
        backgroundColor: NSColor = .windowBackgroundColor
    ) {
        self._text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }

    public func makeNSView(context: Context) -> NSScrollView {
        let tv = CustomTextView()
        tv.delegate = context.coordinator
        tv.isRichText = false
        tv.font = font
        tv.textColor = textColor
        tv.backgroundColor = backgroundColor
        tv.isHorizontallyResizable = true
        tv.isVerticallyResizable = true
        tv.textContainer?.widthTracksTextView = false
        tv.textContainer?.heightTracksTextView = false
        tv.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        tv.minSize = NSSize(width: 0, height: 0)
        tv.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        tv.autoresizingMask = []
        let scroll = NSScrollView(frame: .zero)
        scroll.documentView = tv
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.horizontalScrollElasticity = .allowed
        scroll.verticalScrollElasticity = .allowed
        scroll.autohidesScrollers = false
        scroll.drawsBackground = false
        scroll.wantsLayer = true
        scroll.layer?.cornerRadius = 8
        scroll.layer?.masksToBounds = true

        return scroll
    }

    public func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let tv = nsView.documentView as? NSTextView, tv.string != text {
            tv.string = text
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, NSTextViewDelegate {
        var parent: VimCodeEditor

        init(_ parent: VimCodeEditor) {
            self.parent = parent
        }

        public func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            parent.text = tv.string
        }
    }
}

class CustomTextView: NSTextView {
    var currentMode: CodeEditorMode = .normal

    override func keyDown(with event: NSEvent) {
        if currentMode == .normal {
            handleNormalModeKeyEvent(event)
        } else if currentMode == .insert {
            super.keyDown(with: event) // Default behavior for insert mode
        } else if currentMode == .visual {
            handleVisualModeKeyEvent(event)
        }
    }

    private func handleNormalModeKeyEvent(_ event: NSEvent) {
        guard let characters = event.characters else { return }

        switch characters {
        case "h":
            moveLeft(self)
        case "j":
            moveDown(self)
        case "k":
            moveUp(self)
        case "l":
            moveRight(self)
        case "i":
            currentMode = .insert
        case "v":
            currentMode = .visual
        case String(Character(UnicodeScalar(27)!)): // Esc key
            currentMode = .normal
        default:
            super.keyDown(with: event)
        }
    }

    private func handleVisualModeKeyEvent(_ event: NSEvent) {
        // Implement visual mode key handling
    }
}

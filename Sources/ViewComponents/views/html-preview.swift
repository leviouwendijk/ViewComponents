import Foundation
import SwiftUI
import AppKit
import WebKit

public struct HTMLPreview: NSViewRepresentable {
    @Binding public var html: String

    public init(html: Binding<String>) {
        self._html = html
    }

    public func makeNSView(context: Context) -> HTMLPreviewView {
        HTMLPreviewView()
    }

    public func updateNSView(_ nsView: HTMLPreviewView, context: Context) {
        nsView.updateHTML(html)
    }
}

public class HTMLPreviewView: NSView {
    private let webView = WKWebView()

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupWebView()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWebView()
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    public func updateHTML(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}

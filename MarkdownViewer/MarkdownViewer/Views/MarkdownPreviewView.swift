//
//  MarkdownPreviewView.swift
//  MarkdownViewer
//
//  Created on 2025-11-14.
//

import SwiftUI
import WebKit

struct MarkdownPreviewView: View {
    let markdown: String

    var body: some View {
        WebView(htmlContent: MarkdownParser.generateHTML(from: markdown))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WebView: NSViewRepresentable {
    let htmlContent: String

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// Alternative: Native SwiftUI Text rendering (simpler but less feature-rich)
struct MarkdownPreviewViewNative: View {
    let markdown: String

    var body: some View {
        ScrollView {
            Text(MarkdownParser.parseWithFullSyntax(markdown))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MarkdownPreviewView(markdown: """
    # Hello World

    This is a **markdown** preview with *italic* text.

    ## Features

    - Lists
    - Code blocks
    - Links

    ```swift
    let message = "Hello, World!"
    print(message)
    ```

    [Visit Apple](https://apple.com)
    """)
}

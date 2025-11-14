//
//  MarkdownParser.swift
//  MarkdownViewer
//
//  Created on 2025-11-14.
//

import Foundation
import SwiftUI

struct MarkdownParser {

    /// Parse markdown text and return AttributedString
    static func parse(_ markdown: String) -> AttributedString {
        // Use built-in AttributedString markdown parsing (available in macOS 12+)
        do {
            var attributedString = try AttributedString(markdown: markdown, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))

            // Apply custom styling
            attributedString.font = .system(size: 14)

            return attributedString
        } catch {
            // Fallback to plain text if parsing fails
            return AttributedString(markdown)
        }
    }

    /// Parse markdown with full block-level syntax support
    static func parseWithFullSyntax(_ markdown: String) -> AttributedString {
        do {
            var options = AttributedString.MarkdownParsingOptions()
            options.interpretedSyntax = .full

            var attributedString = try AttributedString(markdown: markdown, options: options)

            // Apply base font
            attributedString.font = .system(size: 14)

            return attributedString
        } catch {
            // Fallback to plain text if parsing fails
            return AttributedString(markdown)
        }
    }

    /// Generate HTML from markdown for WebView rendering using marked.js
    static func generateHTML(from markdown: String) -> String {
        // Escape the markdown content for safe embedding in JavaScript
        let escapedMarkdown = markdown
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "$", with: "\\$")

        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                :root {
                    color-scheme: light dark;
                }
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
                    font-size: 14px;
                    line-height: 1.6;
                    padding: 20px;
                    max-width: 900px;
                    margin: 0 auto;
                    background-color: #ffffff;
                    color: #000000;
                }
                @media (prefers-color-scheme: dark) {
                    body {
                        background-color: #1e1e1e;
                        color: #d4d4d4;
                    }
                    h2, h1 {
                        border-bottom-color: #444 !important;
                    }
                    h6 {
                        color: #8b949e !important;
                    }
                    blockquote {
                        color: #8b949e !important;
                        border-left-color: #444 !important;
                    }
                    hr {
                        background-color: #444 !important;
                    }
                }
                h1, h2, h3, h4, h5, h6 {
                    margin-top: 24px;
                    margin-bottom: 16px;
                    font-weight: 600;
                    line-height: 1.25;
                }
                h1 { font-size: 2em; border-bottom: 1px solid #e1e4e8; padding-bottom: 0.3em; }
                h2 { font-size: 1.5em; border-bottom: 1px solid #e1e4e8; padding-bottom: 0.3em; }
                h3 { font-size: 1.25em; }
                h4 { font-size: 1em; }
                h5 { font-size: 0.875em; }
                h6 { font-size: 0.85em; color: #6a737d; }

                code {
                    background-color: rgba(27, 31, 35, 0.05);
                    padding: 0.2em 0.4em;
                    margin: 0;
                    font-size: 85%;
                    border-radius: 3px;
                    font-family: 'SF Mono', Monaco, Menlo, Consolas, monospace;
                }
                @media (prefers-color-scheme: dark) {
                    code {
                        background-color: rgba(110, 118, 129, 0.4);
                    }
                }

                pre {
                    background-color: #f6f8fa;
                    padding: 16px;
                    overflow: auto;
                    font-size: 85%;
                    line-height: 1.45;
                    border-radius: 6px;
                }
                @media (prefers-color-scheme: dark) {
                    pre {
                        background-color: #2d2d2d;
                    }
                }

                pre code {
                    background-color: transparent;
                    padding: 0;
                    margin: 0;
                    font-size: 100%;
                    border-radius: 0;
                }

                blockquote {
                    margin: 0;
                    padding: 0 1em;
                    color: #6a737d;
                    border-left: 0.25em solid #dfe2e5;
                }

                a {
                    color: #0366d6;
                    text-decoration: none;
                }
                a:hover {
                    text-decoration: underline;
                }
                @media (prefers-color-scheme: dark) {
                    a {
                        color: #58a6ff;
                    }
                }

                ul, ol {
                    padding-left: 2em;
                    margin-top: 0;
                    margin-bottom: 16px;
                }

                li + li {
                    margin-top: 0.25em;
                }

                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin-top: 0;
                    margin-bottom: 16px;
                }

                table th, table td {
                    padding: 6px 13px;
                    border: 1px solid #dfe2e5;
                }

                table tr {
                    background-color: #fff;
                    border-top: 1px solid #c6cbd1;
                }

                table tr:nth-child(2n) {
                    background-color: #f6f8fa;
                }

                @media (prefers-color-scheme: dark) {
                    table th, table td {
                        border: 1px solid #444;
                    }
                    table tr {
                        background-color: #1e1e1e;
                        border-top: 1px solid #444;
                    }
                    table tr:nth-child(2n) {
                        background-color: #2d2d2d;
                    }
                }

                img {
                    max-width: 100%;
                    box-sizing: content-box;
                }

                hr {
                    height: 0.25em;
                    padding: 0;
                    margin: 24px 0;
                    background-color: #e1e4e8;
                    border: 0;
                }

                p {
                    margin-top: 0;
                    margin-bottom: 16px;
                }
            </style>
        </head>
        <body>
            <div id="content"></div>
            <script src="https://cdn.jsdelivr.net/npm/marked@11.1.1/marked.min.js"></script>
            <script>
                // Configure marked options
                marked.setOptions({
                    breaks: true,
                    gfm: true
                });

                // Parse and render markdown
                const markdownText = `\(escapedMarkdown)`;
                document.getElementById('content').innerHTML = marked.parse(markdownText);
            </script>
        </body>
        </html>
        """
        return html
    }
}

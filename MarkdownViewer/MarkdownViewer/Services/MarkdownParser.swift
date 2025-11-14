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

    /// Generate HTML from markdown for WebView rendering with embedded parser
    static func generateHTML(from markdown: String) -> String {
        // Escape the markdown content for safe embedding in JavaScript
        let escapedMarkdown = markdown
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "`", with: "\\`")
            .replacingOccurrences(of: "$", with: "\\$")
            .replacingOccurrences(of: "</", with: "<\\/") // Prevent closing script tags

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
            <script>
                // Embedded lightweight markdown parser
                function parseMarkdown(md) {
                    // Escape HTML in content first
                    function escapeHtml(text) {
                        const map = {
                            '&': '&amp;',
                            '<': '&lt;',
                            '>': '&gt;',
                            '"': '&quot;',
                            "'": '&#039;'
                        };
                        return text.replace(/[&<>"']/g, m => map[m]);
                    }

                    // Process code blocks first to protect them
                    const codeBlocks = [];
                    md = md.replace(/```([\\s\\S]*?)```/g, (match, code) => {
                        const placeholder = `___CODE_BLOCK_${codeBlocks.length}___`;
                        codeBlocks.push(code.trim());
                        return placeholder;
                    });

                    // Process inline code
                    const inlineCodes = [];
                    md = md.replace(/`([^`]+)`/g, (match, code) => {
                        const placeholder = `___INLINE_CODE_${inlineCodes.length}___`;
                        inlineCodes.push(code);
                        return placeholder;
                    });

                    // Now escape HTML
                    md = escapeHtml(md);

                    // Headers (must be at start of line)
                    md = md.replace(/^######\\s+(.*)$/gm, '<h6>$1</h6>');
                    md = md.replace(/^#####\\s+(.*)$/gm, '<h5>$1</h5>');
                    md = md.replace(/^####\\s+(.*)$/gm, '<h4>$1</h4>');
                    md = md.replace(/^###\\s+(.*)$/gm, '<h3>$1</h3>');
                    md = md.replace(/^##\\s+(.*)$/gm, '<h2>$1</h2>');
                    md = md.replace(/^#\\s+(.*)$/gm, '<h1>$1</h1>');

                    // Horizontal rules
                    md = md.replace(/^---$/gm, '<hr>');
                    md = md.replace(/^\\*\\*\\*$/gm, '<hr>');

                    // Bold and italic
                    md = md.replace(/\\*\\*\\*([^*]+)\\*\\*\\*/g, '<strong><em>$1</em></strong>');
                    md = md.replace(/___([^_]+)___/g, '<strong><em>$1</em></strong>');
                    md = md.replace(/\\*\\*([^*]+)\\*\\*/g, '<strong>$1</strong>');
                    md = md.replace(/__([^_]+)__/g, '<strong>$1</strong>');
                    md = md.replace(/\\*([^*]+)\\*/g, '<em>$1</em>');
                    md = md.replace(/_([^_]+)_/g, '<em>$1</em>');

                    // Strikethrough
                    md = md.replace(/~~([^~]+)~~/g, '<del>$1</del>');

                    // Links
                    md = md.replace(/\\[([^\\]]+)\\]\\(([^)]+)\\)/g, '<a href="$2">$1</a>');

                    // Images
                    md = md.replace(/!\\[([^\\]]*)\\]\\(([^)]+)\\)/g, '<img src="$2" alt="$1">');

                    // Lists - unordered
                    md = md.replace(/^\\s*[*+-]\\s+(.*)$/gm, '<li>$1</li>');

                    // Lists - ordered
                    md = md.replace(/^\\s*\\d+\\.\\s+(.*)$/gm, '<li>$1</li>');

                    // Wrap consecutive <li> in <ul>
                    md = md.replace(/(<li>.*<\\/li>\\n?)+/g, match => {
                        return '<ul>' + match + '</ul>';
                    });

                    // Blockquotes
                    md = md.replace(/^>\\s+(.*)$/gm, '<blockquote>$1</blockquote>');

                    // Wrap consecutive blockquotes
                    md = md.replace(/(<blockquote>.*<\\/blockquote>\\n?)+/g, match => {
                        const content = match.replace(/<\\/?blockquote>/g, '');
                        return '<blockquote>' + content + '</blockquote>';
                    });

                    // Tables
                    const lines = md.split('\\n');
                    let inTable = false;
                    let tableHtml = '';
                    let result = [];

                    for (let i = 0; i < lines.length; i++) {
                        const line = lines[i].trim();

                        if (line.includes('|')) {
                            if (!inTable) {
                                inTable = true;
                                tableHtml = '<table>';
                            }

                            // Check if it's a separator line
                            if (/^\\|?\\s*[-:]+\\s*\\|/.test(line)) {
                                continue; // Skip separator lines
                            }

                            const cells = line.split('|').map(c => c.trim()).filter(c => c);
                            const tag = (result.length === 0 || !inTable) ? 'th' : 'td';

                            tableHtml += '<tr>';
                            cells.forEach(cell => {
                                tableHtml += `<${tag}>${cell}</${tag}>`;
                            });
                            tableHtml += '</tr>';
                        } else {
                            if (inTable) {
                                tableHtml += '</table>';
                                result.push(tableHtml);
                                inTable = false;
                                tableHtml = '';
                            }
                            result.push(line);
                        }
                    }

                    if (inTable) {
                        tableHtml += '</table>';
                        result.push(tableHtml);
                    }

                    md = result.join('\\n');

                    // Restore code blocks
                    codeBlocks.forEach((code, i) => {
                        md = md.replace(
                            `___CODE_BLOCK_${i}___`,
                            `<pre><code>${escapeHtml(code)}</code></pre>`
                        );
                    });

                    // Restore inline code
                    inlineCodes.forEach((code, i) => {
                        md = md.replace(
                            `___INLINE_CODE_${i}___`,
                            `<code>${escapeHtml(code)}</code>`
                        );
                    });

                    // Paragraphs - wrap non-tag lines
                    md = md.split('\\n').map(line => {
                        line = line.trim();
                        if (!line) return '';
                        if (line.startsWith('<h') || line.startsWith('<ul') ||
                            line.startsWith('<ol') || line.startsWith('<li') ||
                            line.startsWith('<pre') || line.startsWith('<blockquote') ||
                            line.startsWith('<hr') || line.startsWith('<table')) {
                            return line;
                        }
                        return `<p>${line}</p>`;
                    }).join('\\n');

                    return md;
                }

                // Parse and render markdown
                const markdownText = `\(escapedMarkdown)`;
                document.getElementById('content').innerHTML = parseMarkdown(markdownText);
            </script>
        </body>
        </html>
        """
        return html
    }
}

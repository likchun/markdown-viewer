//
//  DocumentModel.swift
//  MarkdownViewer
//
//  Created on 2025-11-14.
//

import Foundation
import SwiftUI

@MainActor
class DocumentModel: ObservableObject {
    @Published var content: String = ""
    @Published var fileName: String = "No file selected"
    @Published var fileURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadFile(from url: URL) {
        isLoading = true
        errorMessage = nil

        // Try to access the file as a security-scoped resource
        // For file picker URLs, this is required. For drag-and-drop URLs,
        // the system automatically grants access, so this may return false
        let isSecurityScoped = url.startAccessingSecurityScopedResource()

        defer {
            if isSecurityScoped {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            self.content = fileContent
            self.fileName = url.lastPathComponent
            self.fileURL = url
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Failed to load file: \(error.localizedDescription)"
            self.content = ""
            self.fileName = "Error loading file"
        }

        isLoading = false
    }

    func clearDocument() {
        content = ""
        fileName = "No file selected"
        fileURL = nil
        errorMessage = nil
    }
}

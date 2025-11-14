//
//  ContentView.swift
//  MarkdownViewer
//
//  Created on 2025-11-14.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var document = DocumentModel()
    @State private var isFilePickerPresented = false
    @State private var isHoveringDrop = false

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text(document.fileName)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button(action: openFile) {
                    Label("Open File", systemImage: "doc.text")
                }
                .buttonStyle(.bordered)
                .help("Open a markdown file")
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            // Main content area
            ZStack {
                if document.content.isEmpty && document.errorMessage == nil {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)

                        VStack(spacing: 8) {
                            Text("No File Selected")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("Open a markdown file to preview")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Button(action: openFile) {
                            Label("Open Markdown File", systemImage: "doc.badge.plus")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)

                        Text("or drag and drop a file here")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(isHoveringDrop ? Color.accentColor.opacity(0.1) : Color.clear)
                } else if let errorMessage = document.errorMessage {
                    // Error state
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.red)

                        Text("Error")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(errorMessage)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Try Again") {
                            openFile()
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Preview content
                    MarkdownPreviewView(markdown: document.content)
                }
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [.plainText, .text, UTType(filenameExtension: "md")!, UTType(filenameExtension: "markdown")!],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result)
        }
        .onDrop(of: [.fileURL], isTargeted: $isHoveringDrop) { providers in
            handleDrop(providers: providers)
        }
        .onReceive(NotificationCenter.default.publisher(for: .openFile)) { _ in
            openFile()
        }
    }

    private func openFile() {
        isFilePickerPresented = true
    }

    private func handleFileSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            document.loadFile(from: url)
        case .failure(let error):
            document.errorMessage = "Failed to open file: \(error.localizedDescription)"
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        // Check if provider has a file URL
        if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                if let error = error {
                    DispatchQueue.main.async {
                        document.errorMessage = "Failed to load dropped file: \(error.localizedDescription)"
                    }
                    return
                }

                guard let url = url else {
                    DispatchQueue.main.async {
                        document.errorMessage = "Invalid file URL"
                    }
                    return
                }

                DispatchQueue.main.async {
                    document.loadFile(from: url)
                }
            }
            return true
        }

        return false
    }
}

#Preview {
    ContentView()
}

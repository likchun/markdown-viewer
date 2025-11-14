//
//  MarkdownViewerApp.swift
//  MarkdownViewer
//
//  Created on 2025-11-14.
//

import SwiftUI

@main
struct MarkdownViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("Open...") {
                    NotificationCenter.default.post(name: .openFile, object: nil)
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let openFile = Notification.Name("openFile")
}

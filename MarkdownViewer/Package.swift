// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MarkdownViewer",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "MarkdownViewer",
            targets: ["MarkdownViewer"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main")
    ],
    targets: [
        .target(
            name: "MarkdownViewer",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown")
            ]
        )
    ]
)

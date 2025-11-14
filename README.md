# Markdown Viewer

A native macOS application for viewing Markdown files with a clean, modern interface.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- **Native macOS App**: Built with SwiftUI for a smooth, native experience
- **Rich Markdown Rendering**: Supports headings, lists, links, images, code blocks, tables, and more
- **Dark Mode Support**: Automatically adapts to system appearance
- **Drag & Drop**: Simply drag markdown files into the app window
- **File Picker**: Browse and open markdown files with Cmd+O
- **Clean Interface**: Minimal, distraction-free design focused on content
- **Secure**: Sandboxed app with proper file access permissions

## Screenshots

The app features:
- A clean toolbar showing the current file name
- Full markdown preview with syntax highlighting
- Empty state with helpful instructions
- Error handling for invalid files

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later (for building from source)

## Installation

### Building from Source

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/markdown-viewer.git
   cd markdown-viewer
   ```

2. **Open in Xcode**:
   ```bash
   open MarkdownViewer/MarkdownViewer.xcodeproj
   ```

3. **Build and Run**:
   - Select the "MarkdownViewer" scheme
   - Press `Cmd+R` to build and run
   - Or use Product > Run from the menu

### Building from Command Line

```bash
cd MarkdownViewer
xcodebuild -project MarkdownViewer.xcodeproj -scheme MarkdownViewer -configuration Release build
```

The built app will be located in the build directory.

## Usage

### Opening Files

There are multiple ways to open a markdown file:

1. **File Picker**: Click the "Open File" button in the toolbar or press `Cmd+O`
2. **Drag & Drop**: Drag a `.md` or `.markdown` file into the app window
3. **Menu**: Use File > Open from the menu bar

### Supported File Types

- `.md` files
- `.markdown` files
- Plain text files (`.txt`)

### Keyboard Shortcuts

- `Cmd+O` - Open file
- `Cmd+Q` - Quit application

## Project Structure

```
MarkdownViewer/
├── MarkdownViewer.xcodeproj/     # Xcode project file
├── MarkdownViewer/
│   ├── App/
│   │   ├── MarkdownViewerApp.swift     # App entry point
│   │   └── ContentView.swift           # Main UI view
│   ├── Views/
│   │   └── MarkdownPreviewView.swift   # Markdown rendering view
│   ├── Models/
│   │   └── DocumentModel.swift         # Document state management
│   ├── Services/
│   │   └── MarkdownParser.swift        # Markdown parsing logic
│   └── Resources/
│       └── Assets.xcassets              # App icons and assets
└── Package.swift                        # Swift Package dependencies
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Models**: `DocumentModel` manages file loading and content state
- **Views**: SwiftUI views for UI presentation
- **Services**: `MarkdownParser` handles markdown to HTML conversion

### Key Technologies

- **SwiftUI**: For the native macOS interface
- **WebKit**: For rendering HTML-formatted markdown with full styling support
- **Combine**: For reactive state management
- **Foundation**: For file I/O operations

## Markdown Support

The app supports the following Markdown syntax:

- **Headings**: `# H1` through `###### H6`
- **Emphasis**: `*italic*` and `**bold**`
- **Lists**: Ordered and unordered lists
- **Links**: `[text](url)`
- **Images**: `![alt](url)`
- **Code**: Inline `` `code` `` and code blocks with ` ``` `
- **Tables**: GitHub-flavored markdown tables
- **Blockquotes**: `> quote`
- **Horizontal Rules**: `---`

## Development

### Adding New Features

1. Create a new branch for your feature
2. Make your changes in the appropriate files
3. Test thoroughly on macOS 13.0+
4. Submit a pull request

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Add comments for complex logic
- Keep files organized by feature

## Known Limitations

- Images from remote URLs may not load due to security restrictions
- Code syntax highlighting is limited to basic styling
- No live preview mode (manual file reload required)

## Future Enhancements

Potential features for future versions:

- [ ] Export to PDF
- [ ] Print support
- [ ] Recent files menu
- [ ] Customizable themes
- [ ] Font size adjustment
- [ ] Split view for multiple files
- [ ] Live preview mode with file watching
- [ ] Enhanced code syntax highlighting

## Troubleshooting

### File Won't Open
- Ensure the file has `.md` or `.markdown` extension
- Check that you have read permissions for the file
- Try opening the file with the file picker instead of drag & drop

### Rendering Issues
- Some complex markdown syntax may not render perfectly
- Ensure your markdown follows standard syntax conventions
- Check the console for any error messages

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Acknowledgments

- Built with [Swift](https://swift.org/)
- Uses WebKit for rendering
- Inspired by various markdown preview tools

## Contact

For questions or feedback, please open an issue on GitHub.

---

**Happy Markdown Viewing!** 📝

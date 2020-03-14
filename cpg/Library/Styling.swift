import Cocoa

struct Styling {
    private init() {}

    static var defaultEditorFont: NSFont {
        NSFont(name: "SF Mono", size: 12) ?? NSFont.systemFont(ofSize: 12)
    }
}

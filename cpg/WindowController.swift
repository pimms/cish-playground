import Cocoa

class WindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        window?.center()
        window?.title = "Cish Playgrounds"
    }

    @IBAction private func runButtonTapped(_ sender: NSToolbarItem) {
        DebugToast.display("Run button tapped", type: .debug)
    }
}

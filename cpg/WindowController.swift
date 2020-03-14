import Cocoa

class WindowController: NSWindowController {
    @IBAction private func runButtonTapped(_ sender: NSToolbarItem) {
        DebugToast.display("Run button tapped", type: .debug)
    }
}

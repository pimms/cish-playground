import Cocoa

class SplitViewController: NSSplitViewController {
    var textEditorViewController: TextEditorViewController!
    var consoleViewController: ConsoleViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        textEditorViewController = splitViewItems[0].viewController as? TextEditorViewController
        consoleViewController = splitViewItems[1].viewController as? ConsoleViewController
    }
}

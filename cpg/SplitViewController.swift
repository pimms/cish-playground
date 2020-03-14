import Cocoa

class SplitViewController: NSSplitViewController {
    var textEditorViewController: TextEditorViewController {
        return splitViewItems[0].viewController as! TextEditorViewController
    }

    var consoleViewController: ConsoleViewController {
        return splitViewItems[1].viewController as! ConsoleViewController
    }
}

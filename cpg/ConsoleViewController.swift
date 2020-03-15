import Cocoa

class ConsoleViewController: NSViewController {
    @IBOutlet private var scrollView: NSScrollView!
    @IBOutlet private var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.font = Styling.defaultEditorFont
    }

    func clearConsole() {
        textView.string = ""
    }

    func appendConsole(with string: String) {
        textView.string += string
        // TODO: Automatically scroll to the bottom
    }
}

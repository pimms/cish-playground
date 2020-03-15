import Cocoa

class ConsoleViewController: NSViewController {
    @IBOutlet private var scrollView: NSScrollView!
    @IBOutlet private var textView: NSTextView!

    private let consoleBuffer = ConsoleBuffer()

    override func viewDidLoad() {
        super.viewDidLoad()

        consoleBuffer.delegate = self
        textView.font = Styling.defaultEditorFont
    }

    func clearConsole() {
        textView.string = ""
    }

    func appendConsole(with string: String) {
        consoleBuffer.append(string)
    }
}

extension ConsoleViewController: ConsoleBufferDelegate {
    func consoleBuffer(_ buffer: ConsoleBuffer, flushOutput output: String) {
        DispatchQueue.main.async {
            self.textView.string += output
            self.scrollView.verticalScroller?.floatValue = 1
            // TODO: automatically scroll to the bottom
        }
    }
}

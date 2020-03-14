import Cocoa

class ConsoleViewController: NSViewController {
    @IBOutlet private var textView: NSTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.font = Styling.defaultEditorFont
    }
}

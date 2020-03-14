import Cocoa

class ViewController: NSViewController {

    @IBOutlet private var textView: NSTextView!

    private let textEditingDelegate = TextEditingDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        DebugToast.setupContainerView(in: view)

        textView.delegate = textEditingDelegate
        textView.font = NSFont(name: "SF Mono", size: 12)
    }

    override var representedObject: Any? {
        didSet {

        }
    }
}

class TextEditingDelegate: NSObject, NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        DebugToast.display("textDidChange", type: .textView)
    }

    func textDidEndEditing(_ notification: Notification) {
        DebugToast.display("textDidEndEditing", type: .textView)
    }
}

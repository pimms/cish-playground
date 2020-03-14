import Cocoa

class TextEditorViewController: NSViewController {

    @IBOutlet private var textView: NSTextView!

    private let textEditingDelegate = TextEditingDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        DebugToast.setupContainerView(in: view)

        textView.delegate = textEditingDelegate
        textView.font = Styling.defaultEditorFont
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

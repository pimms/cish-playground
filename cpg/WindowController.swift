import Cocoa

class WindowController: NSWindowController {

    // MARK: - Private properties

    @IBOutlet private var runButton: NSToolbarItem!

    private var splitViewController: SplitViewController {
        return contentViewController as! SplitViewController
    }

    private var isRunning: Bool = false {
        didSet {
            runButton.isEnabled = !isRunning
        }
    }

    // MARK: - Lifecycle

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.center()
        window?.title = "Cish Playgrounds"
    }

    // MARK: - IBActions

    @IBAction private func runButtonTapped(_ sender: NSToolbarItem) {
        DebugToast.display("Run button tapped", type: .debug)
        let source = splitViewController.textEditorViewController.programSource

        isRunning = true

        let context = ExecutionContext()
        context.delegate = self
        context.executeProgram(source: source)
    }
}

extension WindowController: ExecutionContextDelegate {
    func executionContext(_ context: ExecutionContext, failedWithError error: Error) {
        DebugToast.display("Execution context failed with error", type: .debug)
        isRunning = false
    }

    func executionContext(_ context: ExecutionContext, completedWithExitCode exitCode: Int) {
        DebugToast.display("Program finished with code: \(exitCode)", type: .debug)
        isRunning = false
    }
}

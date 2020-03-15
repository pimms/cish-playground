import Cocoa

class WindowController: NSWindowController {

    // MARK: - Private properties

    @IBOutlet private var runButton: NSToolbarItem!
    private var splitViewController: SplitViewController!

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

        splitViewController = contentViewController as? SplitViewController
    }

    // MARK: - IBActions

    @IBAction private func runButtonTapped(_ sender: NSToolbarItem) {
        DebugToast.display("Run button tapped", type: .debug)
        let source = splitViewController.textEditorViewController.programSource

        isRunning = true

        splitViewController.consoleViewController.clearConsole()

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
        isRunning = false

        DispatchQueue.main.async {
            let message = "\nProgram terminated with code \(exitCode)"
            self.splitViewController.consoleViewController.appendConsole(with: message)
        }
    }

    func executionContext(_ context: ExecutionContext, appendedStdoutWith string: String) {
        self.splitViewController.consoleViewController.appendConsole(with: string)
    }
}

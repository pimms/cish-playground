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

    @IBAction private func docButtonTapped(_ sender: NSToolbarItem) {
        DebugToast.display("Doc-button tapped", type: .debug)

        let newWindow = NSWindow(contentRect: .init(origin: .zero,
                                                    size: .init(width: NSScreen.main!.frame.midX,
                                                                height: NSScreen.main!.frame.midY)),
                                 styleMask: [.closable],
                                 backing: .buffered,
                                 defer: false)
        newWindow.title = "Documentation"
        newWindow.isOpaque = true
        newWindow.center()
        newWindow.isMovableByWindowBackground = true

        let windowController = NSWindowController(window: newWindow)
        windowController.contentViewController = DocumentationViewController()

        newWindow.windowController = windowController
        newWindow.makeKeyAndOrderFront(nil)
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

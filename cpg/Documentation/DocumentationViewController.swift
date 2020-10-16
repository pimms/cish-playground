import Cocoa
import cishbridge

class DocumentationViewController: NSViewController {
    @IBOutlet private var browser: NSBrowser!

    private lazy var modules: [CishModule] = {
        return CishExecutor().modules
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        browser.delegate = self
    }
}

extension DocumentationViewController: NSBrowserDelegate {
    func browser(_ sender: NSBrowser, numberOfRowsInColumn column: Int) -> Int {
        return modules.count
    }

    func browser(_ sender: NSBrowser, isColumnValid column: Int) -> Bool {
        return column == 0
    }

    func browser(_ sender: NSBrowser, titleOfColumn column: Int) -> String? {
        return "Modules"
    }

    func rootItem(for browser: NSBrowser) -> Any? {
        return modules
    }

    func browser(_ browser: NSBrowser, child index: Int, ofItem item: Any?) -> Any {
        return modules[index]
    }

    func browser(_ browser: NSBrowser, objectValueForItem item: Any?) -> Any? {
        guard let module = item as? CishModule else { return nil }
        return module.name
    }

    func browser(_ browser: NSBrowser, isLeafItem item: Any?) -> Bool {
        return false
    }

    func browser(_ sender: NSBrowser, willDisplayCell cell: Any, atRow row: Int, column: Int) {

    }
}

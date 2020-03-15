import Foundation
import cishbridge

protocol ExecutionContextDelegate: AnyObject {
    func executionContext(_ context: ExecutionContext, failedWithError error: Error)
    func executionContext(_ context: ExecutionContext, completedWithExitCode exitCode: Int)
    func executionContext(_ context: ExecutionContext, appendedStdoutWith string: String)
}

class ExecutionContext {
    weak var delegate: ExecutionContextDelegate?

    func executeProgram(source: String) {
        let cish = CishExecutor()
        cish.delegate = self

        DispatchQueue.global(qos: .userInteractive).async {
            let start = Date().timeIntervalSince1970
            let exitCode = cish.executeProgram(source: source, withArguments: [])
            let end = Date().timeIntervalSince1970
            print("-- Execution completed in \(end-start) seconds --")

            DispatchQueue.main.async {
                self.delegate?.executionContext(self, completedWithExitCode: exitCode)
            }
        }
    }
}

extension ExecutionContext: CishExecutorDelegate {
    func cishExecutor(_ executor: CishExecutor, appendedStdoutWith string: String) {
        delegate?.executionContext(self, appendedStdoutWith: string)
    }

    func cishExecutor(_ executor: CishExecutor, failedWithError error: Error) {
        delegate?.executionContext(self, failedWithError: error)
    }
}

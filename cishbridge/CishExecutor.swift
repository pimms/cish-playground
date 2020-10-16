import Foundation

public protocol CishExecutorDelegate: AnyObject {
    func cishExecutor(_ executor: CishExecutor, appendedStdoutWith string: String)
    func cishExecutor(_ executor: CishExecutor, failedWithError error: Error)
}

public class CishExecutor {
    public var heapSize: UInt32 = 1024 * 1024
    public weak var delegate: CishExecutorDelegate?

    public var modules: [CishModule] {
        let bridge = Bridge(heapSize: 1024, arguments: [])
        return bridge.cishModules()
    }

    public init() {}

    public func executeProgram(source: String, withArguments args: [String]) -> Int {
        let bridge = Bridge(heapSize: heapSize, arguments: args)
        bridge.delegate = self

        let exitCode = bridge.executeProgram(source)
        return Int(exitCode)
    }
}

extension CishExecutor: BridgeDelegate {
    public func bridge(_ bridge: Bridge, stdoutWasAppended string: String) {
        delegate?.cishExecutor(self, appendedStdoutWith: string)
    }
}

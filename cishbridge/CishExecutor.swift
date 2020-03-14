import Foundation

public class CishExecutor {
    public var heapSize: UInt32 = 1024 * 1024

    public init() {}

    public func executeProgram(source: String, withArguments args: [String]) {
        let bridge = Bridge(heapSize: heapSize, arguments: args)
        bridge.executeProgram(source)
    }
}

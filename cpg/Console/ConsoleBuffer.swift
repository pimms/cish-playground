import Foundation

protocol ConsoleBufferDelegate: AnyObject {
    func consoleBuffer(_ buffer: ConsoleBuffer, flushOutput output: String)
}

class ConsoleBuffer {
    weak var delegate: ConsoleBufferDelegate?

    private var lastFlushTime: TimeInterval = 0
    private var flushInterval: TimeInterval = 0.1
    private var buffer: String = ""

    private let bufferQueue = DispatchQueue(label: "ConsoleBufferDispatchQueue")

    func append(_ content: String) {
        bufferQueue.async {
            self.appendAndDispatch(content)
        }
    }

    private func appendAndDispatch(_ content: String) {
        buffer += content

        let now = Date().timeIntervalSince1970
        let timeSinceLastFlush = now - lastFlushTime

        if timeSinceLastFlush > flushInterval {
            dispatchBuffer()
        } else {
            let delay = flushInterval - timeSinceLastFlush
            bufferQueue.asyncAfter(deadline: .now() + delay, execute: {
                self.dispatchBuffer()
            })
        }
    }

    private func dispatchBuffer() {
        lastFlushTime = Date().timeIntervalSince1970
        delegate?.consoleBuffer(self, flushOutput: buffer)
        buffer = ""
    }
}

import CocoaLumberjack
import os

@available(iOS 10.0, *)
open class OSLogger: DDAbstractLogger {
    @objc public static let shared = OSLogger()

    open override var loggerName: String {
        return "com.ainopara.osLogger"
    }

    private(set) var logs: [String: OSLog] = [:]

    open override func log(message logMessage: DDLogMessage) {
        let message: String?
        if let formatter = self.value(forKey: "_logFormatter") as? DDLogFormatter {
            message = formatter.format(message: logMessage)
        } else {
            message = logMessage.message
        }

        guard let finalMessage = message else {
            // Log Formatter decided to drop this message.
            return
        }

        let type = self.logLevel(of: logMessage.flag)
        let log = self.logTarget(of: logMessage.tag)

        os_log("%{public}@", log: log, type: type, finalMessage)
    }

    open func logLevel(of flag: DDLogFlag) -> OSLogType {
        switch flag {
        case .verbose: return .debug
        case .debug:   return .default
        case .info:    return .info
        case .warning: return .error
        case .error:   return .fault
        default:       return .default
        }
    }

    open func logTarget(of rawTag: Any?) -> OSLog {
        guard let loggerTag = rawTag as? OSLoggerTag else {
            return OSLog.default
        }

        guard let target = logs[loggerTag.index] else {
            return OSLog.default
        }

        return target
    }

    open func register(tags: [OSLoggerTag]) {
        for tag in tags {
            logs[tag.index] = tag.log
        }
    }
}

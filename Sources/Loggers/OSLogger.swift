import CocoaLumberjack
import os

@available(iOS 10.0, *)
public class OSLogger: DDAbstractLogger {
    @objc public static let shared = OSLogger()

    public override var loggerName: String {
        return "com.ainopara.osLogger"
    }

    public var logs: [String: OSLog] = [:]

    public override func log(message logMessage: DDLogMessage) {
        let message: String?
        if let formatter = value(forKey: "_logFormatter") as? DDLogFormatter {
            message = formatter.format(message: logMessage)
        } else {
            message = logMessage.message
        }

        guard let finalMessage = message else {
            // Log Formatter decided to drop this message.
            return
        }

        let type: OSLogType
        switch logMessage.flag {
        case .verbose:
            type = .debug
        case .debug:
            type = .default
        case .info:
            type = .info
        case .warning:
            type = .error
        case .error:
            type = .fault
        default:
            type = .default
        }

        let log: OSLog
        if let tag = logMessage.tag as? String, let target = logs[tag] {
            log = target
        } else {
            log = OSLog.default
        }

        os_log("%{public}@", log: log, type: type, finalMessage)
    }
}

import os

public protocol OSLoggerIndexable: CustomStringConvertible {
    var loggerIndex: String { get }
}

public protocol OSLoggerTag {
    var rawCategory: OSLoggerIndexable { get }
    var rawSubsystem: OSLoggerIndexable { get }
}

extension OSLoggerTag {
    var index: String {
        return rawSubsystem.loggerIndex + "-" + rawCategory.loggerIndex
    }

    @available(iOS 10.0, *)
    var log: OSLog {
        return OSLog(subsystem: rawSubsystem.description, category: rawCategory.description)
    }
}

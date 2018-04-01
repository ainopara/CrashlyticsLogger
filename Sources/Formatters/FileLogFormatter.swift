//
//  FileLogFormatter.swift
//  CrashlyticsLogger
//
//  Created by Zheng Li on 2018/4/1.
//

import CocoaLumberjack

public class FileLogFormatter: NSObject, DDLogFormatter {
    public func format(message logMessage: DDLogMessage) -> String? {
        return "[\(logMessage.fileName)] \(logMessage.message)"
    }
}

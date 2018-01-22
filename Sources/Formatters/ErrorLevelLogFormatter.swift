//
//  ErrorLevelLogFormatter.swift
//  Bangumi
//
//  Created by Zheng Li on 27/11/2017.
//  Copyright © 2017 Bangumi NG. All rights reserved.
//

import CocoaLumberjack

public class ErrorLevelLogFormatter: NSObject, DDLogFormatter {

    public func format(message logMessage: DDLogMessage) -> String? {
        let errorLevel: String

        switch logMessage.flag {
        case .error:   errorLevel = "Error  "
        case .warning: errorLevel = "Warning"
        case .info:    errorLevel = "Info   "
        case .debug:   errorLevel = "Debug  "
        case .verbose: errorLevel = "Verbose"
        default:       errorLevel = "Unknown"
        }

        return "|\(errorLevel)| \(logMessage.message)"
    }
}

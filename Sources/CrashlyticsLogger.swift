//
//  CrashlyticsLogger.swift
//  Bangumi
//
//  Created by Zheng Li on 27/11/2017.
//  Copyright © 2017 Bangumi NG. All rights reserved.
//

import Crashlytics
import CocoaLumberjack

extension DDLoggerName {
    static let crashlytics = DDLoggerName("com.ainopara.crashlyticsLogger")
}

public class CrashlyticsLogger: DDAbstractLogger {

    @objc public static let shared = CrashlyticsLogger()

    public override var loggerName: DDLoggerName {
        return .crashlytics
    }

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

        CLSLogv("%@", getVaList([finalMessage]))
    }
}

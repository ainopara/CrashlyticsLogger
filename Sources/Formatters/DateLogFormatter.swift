//
//  DateLogFormatter.swift
//  Bangumi
//
//  Created by Zheng Li on 27/11/2017.
//  Copyright © 2017 Bangumi NG. All rights reserved.
//

import CocoaLumberjack

public class DateLogFormatter: DDDispatchQueueLogFormatter {

    public override func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = self.string(from: logMessage.timestamp) ?? "UnknownTimestamp"
        return "\(timestamp) \(logMessage.message)"
    }
}

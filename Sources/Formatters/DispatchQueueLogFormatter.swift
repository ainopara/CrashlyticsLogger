//
//  DispatchQueueFormatter.swift
//  Bangumi
//
//  Created by Zheng Li on 27/11/2017.
//  Copyright © 2017 Bangumi NG. All rights reserved.
//

import CocoaLumberjack

public class DispatchQueueLogFormatter: DDDispatchQueueLogFormatter {

    public override func format(message logMessage: DDLogMessage) -> String? {
        let queueLabel = queueThreadLabel(for: logMessage) ?? "unknown-queue"
        return "@\(queueLabel) \(logMessage.message)"
    }
}

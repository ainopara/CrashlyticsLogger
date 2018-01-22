//
//  InMemoryLogger.swift
//  Stage1st
//
//  Created by Zheng Li on 1/25/17.
//  Copyright © 2017 Renaissance. All rights reserved.
//

import CocoaLumberjack

public struct MessageBundle {
    let rawMessage: DDLogMessage
    let formattedMessage: String
}

public class InMemoryLogger: DDAbstractLogger {

    @objc public static let shared = InMemoryLogger()

    public override var loggerName: String {
        return "com.ainopara.inMemoryLogger"
    }

    public var maxMessageEntity = 1000
    public private(set) var messageQueue: [MessageBundle] = []

    public override func log(message logMessage: DDLogMessage) {
        if let logFormatter = value(forKey: "_logFormatter") as? DDLogFormatter,
           let formattedMessage = logFormatter.format(message: logMessage) {
            messageQueue.append(MessageBundle(rawMessage: logMessage, formattedMessage: formattedMessage))
        } else {
            messageQueue.append(MessageBundle(rawMessage: logMessage, formattedMessage: logMessage.message))
        }

        while messageQueue.count > maxMessageEntity {
            messageQueue.removeFirst()
        }
    }
}

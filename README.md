# CrashlyticsLogger

This is an extension for `CocoaLumberjack` to forward logs to `Crashltyics`.

## Installation

### CocoaPods
Thanks to CocoaPods 1.4.0 add support to `static_framework`, This library can be imported from CocoaPods.

```ruby
pod 'CrashlyticsLogger', '~> 0.3.1'
```

### Manual
Add this repo as git submodule. Then manually add sources to your project.

Note that `CrashlyticsLogger` require `Crashlytics` and `CocoaLumberjack` as dependency.

## Usage

### Setup Loggers

```swift
let formatter = DDMultiFormatter()
formatter.add(DispatchQueueLogFormatter())
formatter.add(ErrorLevelLogFormatter())
formatter.add(DateLogFormatter())

let crashlyticsLogger = CrashlyticsLogger.shared
crashlyticsLogger.logFormatter = formatter
DDLog.add(crashlyticsLogger)

let inMemoryLogger = InMemoryLogger.shared
inMemoryLogger.logFormatter = formatter
DDLog.add(inMemoryLogger)
```

## License
MIT

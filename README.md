# CrashlyticsLogger

This is an extension for `CocoaLumberjack`. It has several components which can be imported separately.

## Components

### Loggers

`CrashlyticsLogger`: Send logs to crashlytics if crash or non-fatal event occured.

`InMemoryLogger`: Save logs in memory and can be accessed inside application.

### Formatters

`DateLogFormatter`: Insert timestamp at the beginning of every log message.

`DispatchQueueLogFormatter`: Insert dispatch queue at the beginning of every log message.

`ErrorLevelLogFormatter`: Insert error level of the message at the beginning of every log message.

### LogViewers

`InMemoryLogViewController`: Used to inspect logs inside application. It is specially useful when your application encouter a bug that hard to reproduce while debugger is not attaching to the process.

## Installation

### CocoaPods
Thanks to CocoaPods 1.4.0 add support to `static_framework`, This library can be imported from CocoaPods.

```ruby
pod 'CrashlyticsLogger', :git => 'https://github.com/ainopara/CrashlyticsLogger.git', :tag => '0.2.0'
```
You can also import subspecs you needed separately.

```ruby
pod 'CrashlyticsLogger/Formatters', :git => 'https://github.com/ainopara/CrashlyticsLogger.git', :tag => '0.2.0'
```

### Manual
Add this repo as git submodule. Then manually add sources to your project.

Note that `CrashlyticsLogger` require `Crashlytics` and `InMemoryLogViewController` require `SnapKit`. And all the loggers and formatters require `CocoaLumberjack`.

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

### Show Log Viewers

`InMemoryLogViewController` is expected to be embedded in a `UINavigationController`.

```swift
let debugTab = UINavigationController(rootViewController:
    InMemoryLogViewController()
)

let tabBarController = UITabBarController(nibName: nil, bundle: nil)
tabBarController.viewControllers = [
    debugTab
]
```

```swift
self.navigationController?.pushViewController(InMemoryLogViewController(), animated: true)
```

## License
BSD

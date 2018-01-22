Pod::Spec.new do |s|

  s.name         = "CrashlyticsLogger"
  s.version      = "0.1.0"
  s.summary      = "A logger to fill logs to Crashlytics. Based on CocoaLumberjack."

  s.description  = <<-DESC
                   A logger to fill logs to Crashlytics. Based on CocoaLumberjack.
                   And another logger to keep logs in memory and a view controller to inspect them in place.
                   Altogether with some useful log formatter.
                   DESC

  s.homepage     = "https://github.com/ainopara/CrashlyticsLogger"
  s.license      = "BSD"
  s.author       = { "ainopara" => "ainopara@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/ainopara/CrashlyticsLogger.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/Loggers/*.{swift}"
  s.static_framework = true

  s.subspec 'Loggers' do |ss|
    ss.source_files = "Sources/Loggers/*.{swift}"
    ss.dependency 'Crashlytics'
    ss.dependency "CocoaLumberjack"
  end

  s.subspec 'LogViewers' do |ss|
    ss.source_files = "Sources/LogViewers/*.{swift}"
    ss.dependency 'CrashlyticsLogger/Loggers'
    ss.dependency 'SnapKit'
  end

  s.subspec 'Formatters' do |ss|
    ss.source_files = "Sources/Formatters/*.{swift}"
    ss.dependency "CocoaLumberjack"
  end
end

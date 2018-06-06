Pod::Spec.new do |s|

  s.name         = "CrashlyticsLogger"
  s.version      = "0.3.0"
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

  s.source_files = "Sources/*.{swift}"

  s.static_framework = true
  s.swift_version = "4.0"
  s.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-F ${PODS_ROOT}/Crashlytics/iOS' }

  s.dependency "Crashlytics"
  s.dependency "CocoaLumberjack"
  s.dependency "CocoaLumberjack/Swift"
end

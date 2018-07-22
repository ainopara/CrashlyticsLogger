Pod::Spec.new do |s|

  s.name         = "CrashlyticsLogger"
  s.version      = "0.3.1"
  s.summary      = "A custom CocoaLumberjack logger to forward logs to Crashlytics."

  s.description  = <<-DESC
                   A custom CocoaLumberjack logger to forward logs to Crashlytics.
                   This is a swift repo and has dependency of static lib in Crashlytics SDK.
                   DESC

  s.homepage     = "https://github.com/ainopara/CrashlyticsLogger"
  s.license      = { :type => "MIT", :file => "LICENSE" }
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

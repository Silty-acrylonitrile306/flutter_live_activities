#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_live_activities.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_live_activities'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for iOS Live Activities and Dynamic Island.'
  s.description      = <<-DESC
Start, update, and end iOS Live Activities and Dynamic Island from Flutter using ActivityKit.
                       DESC
  s.homepage         = 'https://github.com/priyanshu7791/flutter_live_activities'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Priyanshu Singh' => 'priyanshu7791@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.1'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_live_activities_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end

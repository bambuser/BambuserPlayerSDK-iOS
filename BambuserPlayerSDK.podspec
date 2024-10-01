Pod::Spec.new do |s|
  s.name             = 'BambuserPlayerSDK'
  s.version          = '2.0.0'
  s.summary          = 'Bambuser Player SDK for iOS'
  s.homepage         = 'https://github.com/bambuser/BambuserPlayerSDK-iOS/'
  s.license          = { :type => "Commercial", :text => "Copyright 2024 Bambuser AB" }
  s.author           = { 'Bambuser' => 'support@bambuser.com' }
  s.source           = { :git => "https://github.com/bambuser/BambuserPlayerSDK-iOS.git", :tag => s.version }
  s.vendored_frameworks  = "Sources/BambuserPlayerSDK.xcframework"
  s.platform         = :ios, '14.0'
  s.swift_version    = '5.9'

  # Dependencies for Firebase modules
  s.dependency 'Firebase/Firestore', '~> 11.0'
  s.dependency 'Firebase/Auth', '~> 11.0'

  # Resource bundle for BambuserPlayerBundle
  s.resource_bundles = {
    'BambuserPlayerSDK_BambuserPlayerBundle' => [
      'Sources/BambuserPlayerBundle/Resources/**/*'
    ]
  }
end

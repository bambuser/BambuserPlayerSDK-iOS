Pod::Spec.new do |s|
  s.name                 = "BambuserPlayerSDK"
  s.version              = "1.0.0"
  s.author               = { "Bambuser AB" => "support@bambuser.com" }
  s.homepage             = "https://github.com/bambuser/BambuserPlayerSDK-iOS"
  s.summary              = "Bambuser Player SDK for iOS"
  s.license              = { :type => "Commercial", :text => "Copyright 2023 Bambuser AB" }
  s.platform             = :ios, "14.0"
  s.source               = { :git => "https://github.com/bambuser/BambuserPlayerSDK-iOS", :tag => s.version }
  s.vendored_frameworks  = "Sources/BambuserPlayerSDK.xcframework"

  s.dependency 'Firebase', '10.7.0'
  s.dependency 'FirebaseFirestoreSwift', '10.7.0'

  s.resource_bundles = { 
    "BambuserPlayerSDK_BambuserPlayerBundle" => [
      "Sources/BambuserPlayerBundle/Resources/**/*"
    ]
  }

end

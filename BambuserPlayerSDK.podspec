Pod::Spec.new do |s|
  s.name             = 'BambuserPlayerSDK'
  s.version          = '1.5.0'
  s.summary          = 'BambuserPlayerSDK provides a player for live streaming content.'
  s.description      = <<-DESC
                        BambuserPlayerSDK allows you to integrate a player for live streaming content into your iOS application.
                        DESC
  s.homepage         = 'https://www.bambuser.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bambuser' => 'support@bambuser.com' }
  s.source           = { :http => 'https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.5.0-release.xcframework.zip' }
  s.vendored_frameworks = "BambuserPlayerSDK.xcframework"
  s.platform         = :ios, '14.0'

  s.dependency 'Firebase/Auth'
  s.dependency 'Firebase/Firestore'
end

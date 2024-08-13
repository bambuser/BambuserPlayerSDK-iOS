Pod::Spec.new do |s|
  s.name             = 'BambuserPlayerSDK'
  s.version          = '1.5.2'
  s.summary          = 'Bambuser Player SDK for iOS'
  s.homepage         = 'https://github.com/bambuser/BambuserPlayerSDK-iOS/'
  s.license          = { :type => "Commercial", :text => "Copyright 2024 Bambuser AB" }
  s.author           = { 'Bambuser' => 'support@bambuser.com' }
  s.source           = { :http => 'https://cdn.liveshopping.bambuser.com/public/download/BambuserPlayerSDK-1.5.1-release.xcframework.zip' }
  s.vendored_frameworks = 'BambuserPlayerSDK.xcframework'
  s.platform         = :ios, '14.0'
  s.swift_version    = '5.9'

  s.dependency 'Firebase/Firestore', '10.18.0'
  s.dependency 'Firebase/Auth', '10.18.0'

  s.prepare_command = <<-CMD
  git clone https://github.com/bambuser/BambuserPlayerSDK-iOS ResourcesRepo
  mkdir -p Resources
  cp -r ResourcesRepo/Sources/BambuserPlayerBundle/Resources/* Resources/
  rm -rf ResourcesRepo
CMD

  s.resource_bundles = {
    'BambuserPlayerSDK_BambuserPlayerBundle' => [
      'Resources/**/*'
    ]
  }
end

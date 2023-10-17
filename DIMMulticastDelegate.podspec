#
# Be sure to run `pod lib lint DIMMulticastDelegate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DIMMulticastDelegate'
  s.version          = '0.1.0'
  s.summary          = 'A ready to use multicast delegate for UIKit.'
  s.homepage         = 'https://github.com/DimensionSrl/DIMMulticastDelegate'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matteo Matassoni' => '4108197+matax87@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/DimensionSrl/DIMMulticastDelegate.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files  = "Source/**/*.{h,m}"
end

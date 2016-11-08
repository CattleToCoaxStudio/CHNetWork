#
# Be sure to run `pod lib lint CHNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHNetWork'
  s.version          = '0.0.1'
  s.summary          = 'CHNetWork is a Networking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/CattleToCoaxStudio/CHNetWork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chengyou.yang' => '864390553@qq.com' }
  s.source           = { :git => 'https://github.com/CattleToCoaxStudio/CHNetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CHNetWork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CHNetWork' => ['CHNetWork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'AFNetworking'
  s.dependency 'FMDB'
  s.dependency 'MJExtension'
end

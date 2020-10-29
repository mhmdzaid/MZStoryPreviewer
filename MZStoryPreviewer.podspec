#
# Be sure to run `pod lib lint MZStoryPreviewer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MZStoryPreviewer'
  s.version          = '0.1.0'
  s.summary          = 'MZStoryPreviewer is a simple reusable component for previewing users stories in an elegant way.'
  s.swift_versions = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'MZStoryPreviewer is a UI component for previewing users stories in an elegant way like instagram feature previewing users with gradient Border colors.'

  s.homepage         = 'https://github.com/mozead1996/MZStoryPreviewer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mozead1996' => 'mohamedzead2021@gmail.com' }
  s.source           = { :git => 'https://github.com/mozead1996/MZStoryPreviewer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mo__zead'

  s.ios.deployment_target = '12.4'

  s.source_files = 'MZStoryPreviewer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MZStoryPreviewer' => ['MZStoryPreviewer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SDWebImage', '~> 5.0'
end

#
# Be sure to run `pod lib lint Adaptor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Adaptor'
  s.version          = '0.1.4'
  s.summary          = 'An adaptor of UITableView and UICollectionView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
     This is an adaptor pattern designed for table view and collection view. The adaptor will take part of the data source and delegate function away
     from view controller to make view controller less tedious. The cell holders and section holders will handle the cell and section event, acting like a controller of cell and section.
                       DESC

  s.homepage         = 'https://github.com/MemoryReload/Adaptor'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MemoryReload' => 'heping_tsdwx@163.com' }
  s.source           = { :git => 'https://github.com/MemoryReload/Adaptor.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_versions = '4.0'

  s.source_files = 'Adaptor/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Adaptor' => ['Adaptor/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

Pod::Spec.new do |s|
  s.name         = "Canvas"
  s.version      = "0.0.1"
  s.summary      = "A short description of Canvas."
  s.description  = <<-DESC
                   A longer description of Canvas in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.homepage     = "http://EXAMPLE/Canvas"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  # s.author       = { "shadownessguy@gmail.com" => "shadownessguy@gmail.com" }
  # s.authors      = { "shadownessguy@gmail.com" => "shadownessguy@gmail.com", "other author" => "email@address.com" }
  # s.author       = 'shadownessguy@gmail.com', 'other author'
  s.platform     = :ios, '7.0'
  #  When using multiple platforms
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.source       = { :git => "git@github.com:MengTo/Canvas.git", :tag => "0.0.1" }
  s.source_files  = '*.{h,m}'
  s.exclude_files = 'Classes/Exclude'

  # s.public_header_files = 'Classes/**/*.h'


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'
  s.requires_arc = true
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'

end

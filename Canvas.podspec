Pod::Spec.new do |s|
  s.name         = "Canvas"
  s.version      = "0.2-beta"
  s.summary      = "Animate in Xcode without code"
  s.homepage     = "http://canvaspod.io"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Meng To" => "shadownessguy@gmail.com", "Jamz Tang" => "jamz@jamztang.com" }
  s.platform     = :ios, '7.0'
  # s.source       = { :git => "https://github.com/CanvasPod/Canvas.git", :tag => s.version.to_s }
  # s.source_files  = 'CanvasLibrary/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true

  s.subspec 'Animation' do |sp|
    sp.source_files = 'CanvasLibrary/Animation/*'
  end

  s.subspec 'TCCustomFont' do |sp|
    sp.source_files = 'CanvasLibrary/TCCustomFont/*'
  end

  s.subspec 'CSBlurView' do |sp|
    sp.source_files = 'CanvasLibrary/CSBlurView/*'
  end

  s.subspec 'CSNavigationController' do |sp|
    sp.source_files = 'CanvasLibrary/CSNavigationController/*'
  end

  s.subspec 'CSStickyHeaderFlowLayout' do |sp|
    sp.source_files = 'CanvasLibrary/CSStickyHeaderFlowLayout/*'
  end

  s.subspec 'CSDynamics' do |sp|
    sp.source_files = 'CanvasLibrary/CSDynamics/*'
  end

end

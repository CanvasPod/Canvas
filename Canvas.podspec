Pod::Spec.new do |s|
  s.name         = "Canvas"
  s.version      = "1.0"
  s.summary      = "Animate in Xcode without code"
  s.homepage     = "http://canvas.mengto.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Meng To" => "shadownessguy@gmail.com", "Jamz Tang" => "jamz@jamztang.com" }
  s.platform     = :ios, '7.0'
  # s.source       = { :git => "git@github.com:MengTo/Canvas.git", :tag => "0.0.1" }
  s.source_files  = 'CanvasLibrary/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true
end

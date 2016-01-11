Pod::Spec.new do |s|
  s.name             = "MarkdownTextView"
  s.version          = "1.0.0"
  s.summary          = "Rich Markdown editing control for iOS"
  s.homepage         = "https://github.com/indragiek/MarkdownTextView"
  s.screenshots      = "https://github.com/indragiek/MarkdownTextView/blob/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "indragiek" => "i@indragie.com"}
  s.source           = { :git => "https://github.com/indragiek/MarkdownTextView.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'MarkdownTextView/**/*'
end

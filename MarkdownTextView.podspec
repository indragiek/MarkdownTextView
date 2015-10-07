Pod::Spec.new do |s|
  s.name             = "MarkdownTextView"
  s.version          = "0.1.0"
  s.summary          = "Rich Markdown editing control for iOS"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/indragiek/MarkdownTextView"
  s.screenshots      = "https://github.com/indragiek/MarkdownTextView/blob/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "indragiek" => "i@indragie.com"}
  s.source           = { :git => "https://github.com/indragiek/MarkdownTextView.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'MarkdownTextView/**/*'
end

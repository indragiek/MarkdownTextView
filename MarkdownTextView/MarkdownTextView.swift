//
//  MarkdownTextView.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 * Text view with support for highlighting Markdown syntax.
 *
 * MarkdownTextView become delegate of self default, if your defined new delegate, must implements:
 *
 *  - textView:shouldChangeTextInRange:replacementText:
 *  - textViewDidChange:
 *
 * method, call super() implements at first.
 *
 */
open class MarkdownTextView: UITextView, UITextViewDelegate {
  /**
   Default markdown text view init method. Style for this project.
   Using modified markdown attributes file.
   */
  public class func defaultMarkdownTextView() -> MarkdownTextView {
    let attributes = MarkdownAttributes()
    let textStorage = MarkdownTextStorage(attributes: attributes)
    do {
      textStorage.addHighlighter(try LinkHighlighter())
    } catch let error {
      fatalError("Error initializing LinkHighlighter: \(error)")
    }
    textStorage.addHighlighter(MarkdownStrikethroughHighlighter())
    textStorage.addHighlighter(MarkdownSuperscriptHighlighter())
    if let codeBlockAttributes = attributes.codeBlockAttributes {
      textStorage.addHighlighter(MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
    }
    
    let textView = MarkdownTextView(frame: CGRect.zero, textStorage: textStorage)
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    return textView
  }
  
  /**
   Creates a new instance of the receiver.
   
   :param: frame       The view frame.
   :param: textStorage The text storage. This can be customized by the
   caller to customize text attributes and add additional highlighters
   if the defaults are not suitable.
   
   :returns: An initialized instance of the receiver.
   */
  public init(frame: CGRect, textStorage: MarkdownTextStorage = MarkdownTextStorage()) {
    let textContainer = NSTextContainer()
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    super.init(frame: frame, textContainer: textContainer)
    
    // Impl delegate to respond enter operate.
    self.delegate = self
  }
  
  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UITextViewDelegate
  
  let markdownListRegularExpression = try! NSRegularExpression(pattern: "^[-*] ", options: .caseInsensitive)
  let markdownNumberListRegularExpression = try! NSRegularExpression(pattern: "^\\d*\\. ", options: .caseInsensitive)
  
  open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if isReturn(text) {
      var objectLine = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: range.location))
      
      let textSplits = objectLine.components(separatedBy: "\n")
      if textSplits.count > 0 {
        objectLine = textSplits[textSplits.count - 1]
      }
      
      let objectLineRange = NSRange(location: 0, length: objectLine.characters.count)
      
      // Check matches.
      let listMatches = markdownListRegularExpression.matches(in: objectLine, options: [], range: objectLineRange)
      let numberListMatches = markdownNumberListRegularExpression.matches(in: objectLine, options: [], range: objectLineRange)
      
      if listMatches.count > 0 || numberListMatches.count > 0 {
        if numberListMatches.count > 0 {
          if let match = numberListMatches.first, match.range.length == NSString(string: objectLine).length {
            let deleteRange = NSRange(location: range.location - match.range.length, length: match.range.length)
            self.textStorage.deleteCharacters(in: deleteRange)
            self.selectedRange = NSRange(location: deleteRange.location, length: 0)
            
            return false
          }
          
          var number = Int(objectLine.components(separatedBy: ".")[0])
          number! += 1
          
          let insertText = "\n\(number!). "
          
          self.textStorage.insert(NSAttributedString(string: insertText), at: range.location)
          self.selectedRange = NSRange(location: range.location + NSString(string: insertText).length, length: 0)
          
          return false
          
        } else {
          if let match = listMatches.first, match.range.length == NSString(string: objectLine).length {
            let deleteRange = NSRange(location: range.location - match.range.length, length: match.range.length)
            self.textStorage.deleteCharacters(in: deleteRange)
            self.selectedRange = NSRange(location: deleteRange.location, length: 0)
            
            return false
          }
          
          let listPrefix = objectLine.components(separatedBy: " ").first!
          let insertText = "\n\(listPrefix) "
          
          self.textStorage.insert(NSAttributedString(string: insertText), at: range.location)
          self.selectedRange = NSRange(location: range.location + NSString(string: insertText).length, length: 0)
          
          return false
        }
      }
    }
    
    return true
  }
  
  open func textViewDidChange(_ textView: UITextView) {
    
  }
  
  // MARK: - Override
  
  override open func caretRect(for position: UITextPosition) -> CGRect {
    var originalRect = super.caretRect(for: position)
    originalRect.size.height = (font == nil ? 16 : font!.lineHeight) + 3
    return originalRect;
  }
  
  // MARK: - Tool
  
  func isReturn(_ text: String) -> Bool {
    if text == "\n" {
      return true
    } else {
      return false
    }
  }
}

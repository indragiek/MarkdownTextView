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
public class MarkdownTextView: UITextView, UITextViewDelegate {
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
    
    // Line header, contain space char.
    var markdownListItemMatch: String?
    var enterCompleteAtIndex: Int?

    let markdownListRegularExpression = try! NSRegularExpression(pattern: "^[-*] .", options: .CaseInsensitive)
    let markdownNumberListRegularExpression = try! NSRegularExpression(pattern: "^\\d*\\. .", options: .CaseInsensitive)
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        markdownListItemMatch = nil
        enterCompleteAtIndex = nil
        
        if isReturn(text) {
            var objectLine = textView.text.substringToIndex(textView.text.startIndex.advancedBy(range.location))
            
            let textSplits = objectLine.componentsSeparatedByString("\n")
            if textSplits.count > 0 {
                objectLine = textSplits[textSplits.count - 1]
            }
            
            let objectLineRange = NSRange(location: 0, length: objectLine.characters.count)
            
            // Check matches.
            let listMatches = markdownListRegularExpression.matchesInString(objectLine, options: [], range: objectLineRange)
            let numberListMatches = markdownNumberListRegularExpression.matchesInString(objectLine, options: [], range: objectLineRange)
            
            print("objectLine: \(objectLine)")
            print("listMatches: \(listMatches), numberListMatches: \(numberListMatches)")
            
            if listMatches.count > 0 || numberListMatches.count > 0 {
                enterCompleteAtIndex = range.location + 1
                
                if numberListMatches.count > 0 {
                    var number = Int(objectLine.componentsSeparatedByString(".")[0])
                    number! += 1
                    markdownListItemMatch = "\(number!)."
                } else {
                    markdownListItemMatch = objectLine.componentsSeparatedByString(" ")[0]
                }
                
                markdownListItemMatch!.appendContentsOf(" ")
            }
        }

        return true
    }
    
    public func textViewDidChange(textView: UITextView) {
        if markdownListItemMatch != nil {
            self.text.insertContentsOf(markdownListItemMatch!.characters, at: self.text.startIndex.advancedBy(enterCompleteAtIndex!))
            self.selectedRange = NSRange(location: enterCompleteAtIndex! + markdownListItemMatch!.characters.count, length: 0)
        }
    }

    // MARK: - Tool
    
    func isReturn(text: String) -> Bool {
        if text == "\n" {
            return true
        } else {
            return false
        }
    }
    
}

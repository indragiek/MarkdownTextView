//
//  MarkdownStrikethroughHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights ~~strikethrough~~ in Markdown text (unofficial extension)
*/
public final class MarkdownStrikethroughHighlighter: HighlighterType {
    fileprivate static let StrikethroughRegex = regexFromPattern("(~~)(?=\\S)(.+?)(?<=\\S)\\1")
    fileprivate let attributes: TextAttributes?
    
    /**
    Creates a new instance of the receiver.
    
    :param: attributes Optional additional attributes to apply
    to strikethrough text.
    
    :returns: An initialized instance of the receiver.
    */
    public init(attributes: TextAttributes? = nil) {
        self.attributes = attributes
    }
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(_ attributedString: NSMutableAttributedString) {
        enumerateMatches(type(of: self).StrikethroughRegex, string: attributedString.string) {
            var strikethroughAttributes: TextAttributes = [
                NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue as AnyObject
            ]
            if let attributes = self.attributes {
                for (key, value) in attributes {
                    strikethroughAttributes[key] = value
                }
            }
            attributedString.addAttributes(strikethroughAttributes, range: $0.rangeAt(2))
        }
    }
}

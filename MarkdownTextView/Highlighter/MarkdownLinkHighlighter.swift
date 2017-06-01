//
//  MarkdownLinkHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights Markdown links (not including link references)
*/
public final class MarkdownLinkHighlighter: HighlighterType {
    // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
    fileprivate static let LinkRegex = regexFromPattern("\\[([^\\[]+)\\]\\([ \t]*<?(.*?)>?[ \t]*((['\"])(.*?)\\4)?\\)")
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(_ attributedString: NSMutableAttributedString) {
        let string = attributedString.string
        enumerateMatches(type(of: self).LinkRegex, string: string) {
            let URLString = (string as NSString).substring(with: $0.rangeAt(2))
            let linkAttributes = [
                NSLinkAttributeName: URLString
            ]
            attributedString.addAttributes(linkAttributes, range: $0.range)
        }
    }
}

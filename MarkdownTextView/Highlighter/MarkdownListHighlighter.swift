//
//  MarkdownListHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights Markdown lists using specifiable marker patterns.
*/
public final class MarkdownListHighlighter: HighlighterType {
    fileprivate let regularExpression: NSRegularExpression
    fileprivate let attributes: TextAttributes?
    fileprivate let itemAttributes: TextAttributes?
    
    /**
    Creates a new instance of the receiver.
    
    :param: markerPattern  Regular expression pattern to use for matching
    list markers.
    :param: attributes     Attributes to apply to the entire list.
    :param: itemAttributes Attributes to apply to list items (excluding
    list markers)
    
    :returns: An initialized instance of the receiver.
    */
    public init(markerPattern: String, attributes: TextAttributes?, itemAttributes: TextAttributes?) {
        self.regularExpression = listItemRegexWithMarkerPattern(markerPattern)
        self.attributes = attributes
        self.itemAttributes = itemAttributes
    }
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(_ attributedString: NSMutableAttributedString) {
        if (attributes == nil && itemAttributes == nil) { return }
        
        enumerateMatches(regularExpression, string: attributedString.string) {
            if let attributes = self.attributes {
                attributedString.addAttributes(attributes, range: $0.range)
            }
            if let itemAttributes = self.itemAttributes {
                attributedString.addAttributes(itemAttributes, range: $0.rangeAt(1))
            }
        }
    }
}

private func listItemRegexWithMarkerPattern(_ pattern: String) -> NSRegularExpression {
    // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
    return regexFromPattern("^(?:[ ]{0,3}(?:\(pattern))[ \t]+)(.+)\n")
}

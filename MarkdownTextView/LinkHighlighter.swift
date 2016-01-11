//
//  LinkHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights URLs.
*/
public final class LinkHighlighter: HighlighterType {
    private var detector: NSDataDetector!
    
    public init() throws {
        detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
    }
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(attributedString: NSMutableAttributedString) {
        enumerateMatches(detector, string: attributedString.string) {
            if let URL = $0.URL {
                let linkAttributes = [
                    NSLinkAttributeName: URL
                ]
                attributedString.addAttributes(linkAttributes, range: $0.range)
            }
        }
    }
}

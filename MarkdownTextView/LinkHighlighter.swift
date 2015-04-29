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
    
    public init?(errorPtr: NSErrorPointer) {
        var error: NSError?
        if let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: &error) {
            self.detector = detector
        } else {
            if (errorPtr != nil) {
                errorPtr.memory = error
            }
            return nil
        }
    }
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(attributedString: NSMutableAttributedString) {
        enumerateMatches(detector, attributedString.string) {
            if let URL = $0.URL {
                let linkAttributes = [
                    NSLinkAttributeName: URL
                ]
                attributedString.addAttributes(linkAttributes, range: $0.range)
            }
        }
    }
}

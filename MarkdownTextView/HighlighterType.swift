//
//  MarkdownExtensionType.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Used with `HighlighterTextStorage` to add support for highlighting
*  text inside the text storage when the text changes.
*/
public protocol HighlighterType {
    /**
    *  Highlights the text in `attributedString`
    */
    func highlightAttributedString(_ attributedString: NSMutableAttributedString)
}

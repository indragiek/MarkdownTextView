//
//  MarkdownFencedCodeHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights 
*  ```
*  fenced code
*  ``` 
*  blocks in Markdown text.
*/
public final class MarkdownFencedCodeHighlighter: RegularExpressionHighlighter {
    fileprivate static let FencedCodeRegex = regexFromPattern("^(`{3})(?:.*)?$\n[\\s\\S]*\n\\1$")
    
    /**
    Creates a new instance of the receiver.
    
    :param: attributes Attributes to apply to fenced code blocks.
    
    :returns: A new instance of the receiver.
    */
    public init(attributes: TextAttributes) {
        super.init(regularExpression: type(of: self).FencedCodeRegex, attributes: attributes)
    }
}

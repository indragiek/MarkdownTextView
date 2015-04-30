//
//  MarkdownTextView.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Text view with support for highlighting Markdown syntax.
*/
public class MarkdownTextView: UITextView {
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
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

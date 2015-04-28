//
//  RegularExpressionTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

public class RegularExpressionTextStorage: NSTextStorage {
    private let backingStore: NSMutableAttributedString
    
    // MARK: Initialization
    
    public override init() {
        backingStore = NSMutableAttributedString()
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        backingStore = NSMutableAttributedString()
        super.init(coder: aDecoder)
    }
    
    // MARK: NSTextStorage
    
    public override var string: String {
        return backingStore.string
    }
    
    public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [NSObject : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    public override func replaceCharactersInRange(range: NSRange, withAttributedString attrString: NSAttributedString) {
        backingStore.replaceCharactersInRange(range, withAttributedString: attrString)
        edited(.EditedCharacters, range: range, changeInLength: attrString.length - range.length)
    }
    
    public override func setAttributes(attrs: [NSObject : AnyObject]?, range: NSRange) {
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
    }
}

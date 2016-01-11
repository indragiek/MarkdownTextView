//
//  RegularExpressionTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Text storage with support for automatically highlighting text
*  as it changes.
*/
public class HighlighterTextStorage: NSTextStorage {
    private let backingStore: NSMutableAttributedString
    private var highlighters = [HighlighterType]()
    
    /// Default attributes to use for styling text.
    public var defaultAttributes: [String: AnyObject] = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    ] {
        didSet { editedAll(.EditedAttributes) }
    }
    
    // MARK: API
    
    /**
    Adds a highlighter to use for highlighting text.
    
    Highlighters are invoked in the order in which they are added.
    
    :param: highlighter The highlighter to add.
    */
    public func addHighlighter(highlighter: HighlighterType) {
        highlighters.append(highlighter)
        editedAll(.EditedAttributes)
    }
    
    // MARK: Initialization
    
    public override init() {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        super.init(coder: aDecoder)
    }
    
    // MARK: NSTextStorage
    
    public override var string: String {
        return backingStore.string
    }
    
    public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    public override func replaceCharactersInRange(range: NSRange, withAttributedString attrString: NSAttributedString) {
        backingStore.replaceCharactersInRange(range, withAttributedString: attrString)
        edited(.EditedCharacters, range: range, changeInLength: attrString.length - range.length)
    }
    
    public override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
    }
    
    public override func processEditing() {
        // This is inefficient but necessary because certain
        // edits can cause formatting changes that span beyond
        // line or paragraph boundaries. This should be alright
        // for small amounts of text (which is the use case that
        // this was designed for), but would need to be optimized
        // for any kind of heavy editing.
        highlightRange(NSRange(location: 0, length: (string as NSString).length))
        super.processEditing()
    }
    
    private func editedAll(actions: NSTextStorageEditActions) {
        edited(actions, range: NSRange(location: 0, length: backingStore.length), changeInLength: 0)
    }
    
    private func highlightRange(range: NSRange) {
        backingStore.beginEditing()
        setAttributes(defaultAttributes, range: range)
        let attrString = backingStore.attributedSubstringFromRange(range).mutableCopy() as! NSMutableAttributedString
        for highlighter in highlighters {
            highlighter.highlightAttributedString(attrString)
        }
        replaceCharactersInRange(range, withAttributedString: attrString)
        backingStore.endEditing()
    }
}

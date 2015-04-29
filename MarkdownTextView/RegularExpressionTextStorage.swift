//
//  RegularExpressionTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

public class RegularExpressionTextStorage: NSTextStorage {
    private struct Expression {
        let regex: NSRegularExpression
        let attributes: [String: AnyObject]
    }
    
    private let backingStore: NSMutableAttributedString
    private var expressions = [Expression]()
    public var defaultAttributes: [String: AnyObject] = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    ] {
        didSet { editedAll(.EditedAttributes) }
    }
    
    // MARK: API
    
    public func addRegularExpression(expression: NSRegularExpression, withAttributes attributes: [String: AnyObject]) {
        expressions.append(Expression(regex: expression, attributes: attributes))
        editedAll(.EditedAttributes)
    }
    
    // MARK: Initialization
    
    public override init() {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
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
    
    public override func processEditing() {
        // This is inefficient but necessary because certain
        // edits can cause formatting changes that span beyond
        // line or paragraph boundaries. This should be alright
        // for small amounts of text (which is the use case that
        // this was designed for), but would need to be optimized
        // for any kind of heavy editing.
        _highlightRange(NSRange(location: 0, length: (string as NSString).length))
        super.processEditing()
    }
    
    private func editedAll(actions: NSTextStorageEditActions) {
        edited(actions, range: NSRange(location: 0, length: backingStore.length), changeInLength: 0)
    }
    
    private func _highlightRange(range: NSRange) {
        backingStore.beginEditing()
        setAttributes(defaultAttributes, range: range)
        highlightRange(range)
        backingStore.endEditing()
    }
    
    func highlightRange(range: NSRange) {
        for expression in expressions {
            expression.regex.enumerateMatchesInString(string, options: nil, range: range) { (result, _, _) in
                self.addAttributes(expression.attributes, range: result.range)
            }
        }
    }
}

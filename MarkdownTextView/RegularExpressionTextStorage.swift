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
        didSet { editedAll() }
    }
    
    // MARK: API
    
    public func addRegularExpression(expression: NSRegularExpression, withAttributes attributes: [String: AnyObject]) {
        expressions.append(Expression(regex: expression, attributes: attributes))
        editedAll()
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
        highlightRange(NSRange(location: 0, length: (backingStore.string as NSString).length))
        super.processEditing()
    }
    
    private func editedAll() {
        edited(.EditedAttributes, range: NSRange(location: 0, length: backingStore.length), changeInLength: 0)
    }
    
    private func highlightRange(range: NSRange) {
        backingStore.beginEditing()
        setAttributes(defaultAttributes, range: range)
        for expression in expressions {
            expression.regex.enumerateMatchesInString(backingStore.string, options: nil, range: range) { (result, _, _) in
                self.addAttributes(expression.attributes, range: result.range)
            }
        }
        backingStore.endEditing()
    }
}

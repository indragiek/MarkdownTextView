//
//  MarkdownTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

private func fontWithTraits(traits: UIFontDescriptorSymbolicTraits, font: UIFont) -> UIFont {
    let combinedTraits = UIFontDescriptorSymbolicTraits(font.fontDescriptor().symbolicTraits.rawValue | (traits.rawValue & 0xFFFF))
    if let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(combinedTraits) {
        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
    return font
}

private func regexFromPattern(pattern: String) -> NSRegularExpression {
    var error: NSError?
    if let regex = NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines, error: &error) {
        return regex
    } else {
        fatalError("Failed to initialize regular expression with pattern \(pattern): \(error)")
    }
}

public class MarkdownTextStorage: RegularExpressionTextStorage {
    // Regular expressions are from John Gruber's original Markdown.pl
    // implementation (v1.0.1): http://daringfireball.net/projects/markdown/
    private static let HeaderRegex = regexFromPattern("^(\\#{1,6})[ \t]*(.+?)[ \t]*\\#*\n+")
    private static let LinkRegex = regexFromPattern("\\[([^\\[]+)\\]\\([ \t]*<?(.*?)>?[ \t]*((['\"])(.*?)\\4)?\\)")
    
    private let attributes: MarkdownAttributes
    
    // MARK: Initialization
    
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        self.attributes = attributes
        super.init()
        defaultAttributes = attributes.defaultAttributes
        
        // Emphasis
        addPattern("(\\*|_)(?=\\S)(.+?)(?<=\\S)\\1", attributesForTraits(.TraitItalic, attributes.emphasisAttributes))
        
        // Strong
        addPattern("(\\*\\*|__)(?=\\S)(.+?[*_]*)(?<=\\S)\\1", attributesForTraits(.TraitBold, attributes.strongAttributes))
        
        // Se-text style headers
        // H1
        addPattern("^(.+)[ \t]*\n=+[ \t]*\n+", attributes.h1Attributes)
        
        // H2
        addPattern("^(.+)[ \t]*\n-+[ \t]*\n+", attributes.h2Attributes)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: RegularExpressionTextStorage
    
    override func highlightRange(range: NSRange) {
        highlightHeadersInRange(range)
        highlightLinksInRange(range)
        super.highlightRange(range)
    }
    
    private func highlightHeadersInRange(range: NSRange) {
        self.dynamicType.HeaderRegex.enumerateMatchesInString(string, options: nil, range: range) { (result, _, _) in
            let level = result.rangeAtIndex(1).length
            if let attributes = self.attributes.attributesForHeaderLevel(level) {
                self.addAttributes(attributes, range: result.range)
            }
        }
    }
    
    private func highlightLinksInRange(range: NSRange) {
        self.dynamicType.LinkRegex.enumerateMatchesInString(string, options: nil, range: range) { (result, _, _) in
            let URLString = (self.string as NSString).substringWithRange(result.rangeAtIndex(2))
            let linkAttributes = [
                NSLinkAttributeName: URLString
            ]
            self.addAttributes(linkAttributes, range: result.rangeAtIndex(0))
        }
    }
    
    // MARK: Helpers
    
    private func addPattern(pattern: String, _ attributes: MarkdownAttributes.TextAttributes?) {
        if let attributes = attributes {
            self.addRegularExpression(regexFromPattern(pattern), withAttributes: attributes)
        }
    }
    
    private func attributesForTraits(traits: UIFontDescriptorSymbolicTraits, var _ attributes: MarkdownAttributes.TextAttributes?) -> MarkdownAttributes.TextAttributes? {
        if let defaultFont = defaultAttributes[NSFontAttributeName] as? UIFont where attributes == nil {
            attributes = [
                NSFontAttributeName: fontWithTraits(traits, defaultFont)
            ]
        }
        return attributes
    }
}

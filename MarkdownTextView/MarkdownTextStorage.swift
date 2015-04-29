//
//  MarkdownTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

private func regexFromPattern(pattern: String) -> NSRegularExpression {
    var error: NSError?
    if let regex = NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines, error: &error) {
        return regex
    } else {
        fatalError("Failed to initialize regular expression with pattern \(pattern): \(error)")
    }
}

private func listItemRegexWithMarkerPattern(pattern: String) -> NSRegularExpression {
    return regexFromPattern("(?:[ ]{0,3}(?:\(pattern))[ \t]+)(.+)")
}

public class MarkdownTextStorage: RegularExpressionTextStorage {
    // Regular expressions are from John Gruber's original Markdown.pl
    // implementation (v1.0.1): http://daringfireball.net/projects/markdown/
    //
    // See the original source for documentation on these
    // expressions.
    private static let HeaderRegex = regexFromPattern("^(\\#{1,6})[ \t]*(.+?)[ \t]*\\#*\n+")
    private static let LinkRegex = regexFromPattern("\\[([^\\[]+)\\]\\([ \t]*<?(.*?)>?[ \t]*((['\"])(.*?)\\4)?\\)")
    private static let UnorderedListRegex = listItemRegexWithMarkerPattern("[*+-]")
    private static let OrderedListRegex = listItemRegexWithMarkerPattern("\\d+[.]")
    
    private let attributes: MarkdownAttributes
    
    // MARK: Initialization
    
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        self.attributes = attributes
        super.init()
        defaultAttributes = attributes.defaultAttributes
        
        // Code blocks
        addPattern("(?:\n\n|\\A)((?:(?:[ ]{4}|\t).*\n+)+)((?=^[ ]{0,4}\\S)|\\Z)", attributes.codeBlockAttributes)
        
        // Se-text style headers
        // H1
        addPattern("^(.+)[ \t]*\n=+[ \t]*\n+", attributes.h1Attributes)
        
        // H2
        addPattern("^(.+)[ \t]*\n-+[ \t]*\n+", attributes.h2Attributes)
        
        // Emphasis
        addPattern("(\\*|_)(?=\\S)(.+?)(?<=\\S)\\1", attributesForTraits(.TraitItalic, attributes.emphasisAttributes))
        
        // Strong
        addPattern("(\\*\\*|__)(?=\\S)(.+?[*_]*)(?<=\\S)\\1", attributesForTraits(.TraitBold, attributes.strongAttributes))
        
        // Inline code
        addPattern("(`+)(.+?)(?<!`)\\1(?!`)", attributes.inlineCodeAttributes)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: RegularExpressionTextStorage
    
    override func highlightRange(range: NSRange) {
        highlightHeadersInRange(range)
        highlightLinksInRange(range)
        highlightListsInRange(range,
            regex: self.dynamicType.UnorderedListRegex,
            attributes: attributes.unorderedListAttributes,
            itemAttributes: attributes.unorderedListItemAttributes
        )
        highlightListsInRange(range,
            regex: self.dynamicType.OrderedListRegex,
            attributes: attributes.orderedListAttributes,
            itemAttributes: attributes.orderedListItemAttributes
        )
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
    
    private func highlightListsInRange(range: NSRange, regex: NSRegularExpression, attributes: MarkdownAttributes.TextAttributes?, itemAttributes: MarkdownAttributes.TextAttributes?) {
        if (attributes == nil && itemAttributes == nil) { return }
        
        regex.enumerateMatchesInString(string, options: nil, range: range) { (result, _, _) in
            if let attributes = attributes {
                self.addAttributes(attributes, range: result.range)
            }
            if let itemAttributes = itemAttributes {
                self.addAttributes(itemAttributes, range: result.rangeAtIndex(1))
            }
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

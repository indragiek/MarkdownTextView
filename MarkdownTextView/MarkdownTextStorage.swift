//
//  MarkdownTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Text storage with support for highlighting Markdown.
*/
public class MarkdownTextStorage: HighlighterTextStorage {
    private let attributes: MarkdownAttributes
    
    // MARK: Initialization
    
    /**
    Creates a new instance of the receiver.
    
    :param: attributes Attributes used to style the text.
    
    :returns: An initialized instance of `MarkdownTextStorage`
    */
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        self.attributes = attributes
        super.init()
        commonInit()
        
        if let headerAttributes = attributes.headerAttributes {
            addHighlighter(MarkdownHeaderHighlighter(attributes: headerAttributes))
        }
        addHighlighter(MarkdownLinkHighlighter())
        addHighlighter(MarkdownListHighlighter(markerPattern: "[*+-]", attributes: attributes.unorderedListAttributes, itemAttributes: attributes.unorderedListItemAttributes))
        addHighlighter(MarkdownListHighlighter(markerPattern: "\\d+[.]", attributes: attributes.orderedListAttributes, itemAttributes: attributes.orderedListItemAttributes))
        
        // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
        
        // Code blocks
        addPattern("(?:\n\n|\\A)((?:(?:[ ]{4}|\t).*\n+)+)((?=^[ ]{0,4}\\S)|\\Z)", attributes.codeBlockAttributes)
        
        // Block quotes
        addPattern("(?:^[ \t]*>[ \t]?.+\n(.+\n)*\n*)+", attributes.blockQuoteAttributes)
        
        // Se-text style headers
        // H1
        addPattern("^(?:.+)[ \t]*\n=+[ \t]*\n+", attributes.headerAttributes?.h1Attributes)
        
        // H2
        addPattern("^(?:.+)[ \t]*\n-+[ \t]*\n+", attributes.headerAttributes?.h2Attributes)
        
        // Emphasis
        addPattern("(\\*|_)(?=\\S)(.+?)(?<=\\S)\\1", attributesForTraits(.TraitItalic, attributes.emphasisAttributes))
        
        // Strong
        addPattern("(\\*\\*|__)(?=\\S)(?:.+?[*_]*)(?<=\\S)\\1", attributesForTraits(.TraitBold, attributes.strongAttributes))
        
        // Inline code
        addPattern("(`+)(?:.+?)(?<!`)\\1(?!`)", attributes.inlineCodeAttributes)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        attributes = MarkdownAttributes()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        defaultAttributes = attributes.defaultAttributes
    }
    
    // MARK: Helpers
    
    private func addPattern(pattern: String, _ attributes: TextAttributes?) {
        if let attributes = attributes {
            let highlighter = RegularExpressionHighlighter(regularExpression: regexFromPattern(pattern), attributes: attributes)
            addHighlighter(highlighter)
        }
    }
    
    private func attributesForTraits(traits: UIFontDescriptorSymbolicTraits, var _ attributes: TextAttributes?) -> TextAttributes? {
        if let defaultFont = defaultAttributes[NSFontAttributeName] as? UIFont where attributes == nil {
            attributes = [
                NSFontAttributeName: fontWithTraits(traits, font: defaultFont)
            ]
        }
        return attributes
    }
}

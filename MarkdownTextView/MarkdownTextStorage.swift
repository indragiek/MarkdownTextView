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

public class MarkdownTextStorage: RegularExpressionTextStorage {
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        super.init()
        defaultAttributes = attributes.defaultAttributes
        
        // Regular expressions are from John Gruber's original Markdown.pl
        // implementation (v1.0.1): http://daringfireball.net/projects/markdown/
        
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
    
    private func addPattern(pattern: String, _ attributes: MarkdownAttributes.TextAttributes?) {
        if let attributes = attributes {
            var error: NSError?
            if let regex = NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines, error: &error) {
                self.addRegularExpression(regex, withAttributes: attributes)
            } else {
                fatalError("Failed to initialize regular expression with pattern \(pattern): \(error)")
            }
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

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

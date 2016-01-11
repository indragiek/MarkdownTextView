//
//  MarkdownAttributes.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Encapsulates the attributes to use for styling various types
*  of Markdown elements.
*/
public struct MarkdownAttributes {
    public var defaultAttributes: TextAttributes = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    ]
    
    public var strongAttributes: TextAttributes?
    public var emphasisAttributes: TextAttributes?
    
    public struct HeaderAttributes {
        public var h1Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        ]
        
        public var h2Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        ]
        
        public var h3Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        ]
        
        public var h4Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        ]
        
        public var h5Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        ]
        
        public var h6Attributes: TextAttributes? = [
            NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        ]
        
        func attributesForHeaderLevel(level: Int) -> TextAttributes? {
            switch level {
            case 1: return h1Attributes
            case 2: return h2Attributes
            case 3: return h3Attributes
            case 4: return h4Attributes
            case 5: return h5Attributes
            case 6: return h6Attributes
            default: return nil
            }
        }
        
        public init() {}
    }
    
    public var headerAttributes: HeaderAttributes? = HeaderAttributes()
    
    private static let MonospaceFont: UIFont = {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let size = bodyFont.pointSize
        return UIFont(name: "Menlo", size: size) ?? UIFont(name: "Courier", size: size) ?? bodyFont
    }()
    
    public var codeBlockAttributes: TextAttributes? = [
        NSFontAttributeName: MarkdownAttributes.MonospaceFont
    ]
    
    public var inlineCodeAttributes: TextAttributes? = [
        NSFontAttributeName: MarkdownAttributes.MonospaceFont
    ]
    
    public var blockQuoteAttributes: TextAttributes? = [
        NSForegroundColorAttributeName: UIColor.darkGrayColor()
    ]
    
    public var orderedListAttributes: TextAttributes? = [
        NSFontAttributeName: fontWithTraits(.TraitBold, font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
    ]
    
    public var orderedListItemAttributes: TextAttributes? = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
        NSForegroundColorAttributeName: UIColor.darkGrayColor()
    ]
    
    public var unorderedListAttributes: TextAttributes? = [
        NSFontAttributeName: fontWithTraits(.TraitBold, font: UIFont.preferredFontForTextStyle(UIFontTextStyleBody))
    ]
    
    public var unorderedListItemAttributes: TextAttributes? = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody),
        NSForegroundColorAttributeName: UIColor.darkGrayColor()
    ]
    
    public init() {}
}

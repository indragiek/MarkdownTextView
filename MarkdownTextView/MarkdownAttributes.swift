//
//  MarkdownAttributes.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

public struct MarkdownAttributes {
    public typealias TextAttributes = [String: AnyObject]
    
    public var defaultAttributes: TextAttributes = [
        NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    ]
    
    public var strongAttributes: TextAttributes?
    public var emphasisAttributes: TextAttributes?
    
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
    
    private static let MonospaceFont: UIFont = {
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        let size = bodyFont.pointSize
        return UIFont(name: "Menlo", size: size) ?? UIFont(name: "Courier", size: size) ?? bodyFont
    }()
    
    private static let IndentedParagraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 30
        style.headIndent = 30
        return style
    }()
    
    public var codeBlockAttributes: TextAttributes? = [
        NSFontAttributeName: MarkdownAttributes.MonospaceFont,
        NSParagraphStyleAttributeName: MarkdownAttributes.IndentedParagraphStyle
    ]
    
    public var inlineCodeAttributes: TextAttributes? = [
        NSFontAttributeName: MarkdownAttributes.MonospaceFont
    ]
    
    public var blockQuoteAttributes: TextAttributes? = [
        NSParagraphStyleAttributeName: MarkdownAttributes.IndentedParagraphStyle
    ]
    
    public var orderedListItemAttributes: TextAttributes? = [
        NSParagraphStyleAttributeName: MarkdownAttributes.IndentedParagraphStyle
    ]
    
    public var unorderedListItemAttributes: TextAttributes? = [
        NSParagraphStyleAttributeName: MarkdownAttributes.IndentedParagraphStyle
    ]
    
    public func attributesForHeaderLevel(level: Int) -> TextAttributes? {
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
}

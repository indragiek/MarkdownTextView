//
//  TextUtilities.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

public typealias TextAttributes = [String: AnyObject]

internal func fontWithTraits(traits: UIFontDescriptorSymbolicTraits, font: UIFont) -> UIFont {
    let combinedTraits = UIFontDescriptorSymbolicTraits(rawValue: font.fontDescriptor().symbolicTraits.rawValue | (traits.rawValue & 0xFFFF))
    let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(combinedTraits)
    return UIFont(descriptor: descriptor, size: font.pointSize)
}

internal func regexFromPattern(pattern: String) -> NSRegularExpression {
    do {
        return try NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines)
    } catch let error {
        fatalError("Error constructing regular expression: \(error)")
    }
}

internal func enumerateMatches(regex: NSRegularExpression, string: String, block: NSTextCheckingResult -> Void) {
    let range = NSRange(location: 0, length: (string as NSString).length)
    regex.enumerateMatchesInString(string, options: NSMatchingOptions(rawValue: 0), range: range) { (result, _, _) in
        if let result = result {
            block(result)
        }
    }
}

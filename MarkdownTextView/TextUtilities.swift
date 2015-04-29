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
    let combinedTraits = UIFontDescriptorSymbolicTraits(font.fontDescriptor().symbolicTraits.rawValue | (traits.rawValue & 0xFFFF))
    if let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(combinedTraits) {
        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
    return font
}

internal func regexFromPattern(pattern: String) -> NSRegularExpression {
    var error: NSError?
    if let regex = NSRegularExpression(pattern: pattern, options: .AnchorsMatchLines, error: &error) {
        return regex
    } else {
        fatalError("Failed to initialize regular expression with pattern \(pattern): \(error)")
    }
}

internal func enumerateMatches(regex: NSRegularExpression, string: String, block: NSTextCheckingResult -> Void) {
    let range = NSRange(location: 0, length: (string as NSString).length)
    regex.enumerateMatchesInString(string, options: nil, range: range) { (result, _, _) in
        block(result)
    }
}

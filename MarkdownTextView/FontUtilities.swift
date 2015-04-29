//
//  FontUtilities.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

internal func fontWithTraits(traits: UIFontDescriptorSymbolicTraits, font: UIFont) -> UIFont {
    let combinedTraits = UIFontDescriptorSymbolicTraits(font.fontDescriptor().symbolicTraits.rawValue | (traits.rawValue & 0xFFFF))
    if let descriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(combinedTraits) {
        return UIFont(descriptor: descriptor, size: font.pointSize)
    }
    return font
}

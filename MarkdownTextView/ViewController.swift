//
//  ViewController.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textContainer = NSTextContainer()
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage = MarkdownTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        let textView = UITextView(frame: CGRectZero, textContainer: textContainer)
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(textView)
        
        let views = ["textView": textView]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[textView]-20-|", options: nil, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textView]-20-|", options: nil, metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }
}

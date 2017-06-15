//
//  ViewController.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit
import MarkdownTextView

class ViewController: UIViewController {
    var textView: MarkdownTextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "print", style: .plain, target: self, action: #selector(self.printAction))
		
        let attributes = MarkdownAttributes()
        let textStorage = MarkdownTextStorage(attributes: attributes)
        do {
            textStorage.addHighlighter(try LinkHighlighter())
        } catch let error {
            fatalError("Error initializing LinkHighlighter: \(error)")
        }
        textStorage.addHighlighter(MarkdownStrikethroughHighlighter())
        textStorage.addHighlighter(MarkdownSuperscriptHighlighter())
        if let codeBlockAttributes = attributes.codeBlockAttributes {
            textStorage.addHighlighter(MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
        }
        
        textView = MarkdownTextView(frame: CGRect.zero, textStorage: textStorage)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
		
		let views: [String : Any] = ["textView": textView]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    func printAction() {
        let text = textView.text ?? ""
        print("text: \n\(text)")
        
        let attrText = textView.attributedText ?? NSAttributedString()
        print("attr text: \n\(attrText)")
    }
}

//
//  UITextView+Utils.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

extension UITextView {
    
    func resolveHashTags(){
        let nsText: NSString = self.text! as NSString
        let words:[NSString] = nsText.components(separatedBy: " ") as [NSString]
    
        let attrs = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0)
        ]
        
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
    
        for word in words {
            if word.hasPrefix("#") {
                let matchRange:NSRange = nsText.range(of: word as String)
                var stringifiedWord:String = word as String
                stringifiedWord = String(stringifiedWord.dropFirst())
                attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
            }
        }
        self.attributedText = attrString
    }
    
    func addUnderlineLayer(height: CGFloat) {
        let border = UIView()
        border.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        border.frame = CGRect(x: self.frame.origin.x,
                              y: self.frame.origin.y + self.frame.height - height,
                              width: self.frame.width,
                              height: height)
        border.backgroundColor = UIColor.darkGray
        self.superview!.insertSubview(border, aboveSubview: self)
    }
    
}


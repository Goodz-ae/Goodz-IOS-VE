//
//  UITextView+Extension.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

extension UITextView {

    func font(font: FontName, size: FontSize) {
            
        self.font = UIFont(name: font.rawValue, size: FUNCTION().getFontSize(size: size.rawValue))
        }
    
    func color(color: UIColor) {
        self.textColor = color
    }

    func setPlaceholder(text: String, color: UIColor, x: CGFloat = 2) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = UIFont(name: FontName.regular.rawValue, size: FontSize.size14.rawValue)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: x, y: (self.font?.pointSize)! / 2)
//        placeholderLabel.frame.origin = CGPoint(x: 0, y: 0)
        placeholderLabel.textColor = color
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

/*
 // usage
 
 override func viewDidLoad() {
     textView.delegate = self
     textView.setPlaceholder()
 }

 func textViewDidChange(_ textView: UITextView) {
     textView.checkPlaceholder()
 }
 
 */

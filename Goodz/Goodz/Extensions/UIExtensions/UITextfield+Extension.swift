//
//  UITextfield+Extension.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import Foundation
import UIKit
extension UITextField {
    func setLeftImage(icon: UIImage) {
        self.leftViewMode = UITextField.ViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 24, height: 24))
        let image = icon
        imageView.image = image
        view.addSubview(imageView)
        self.leftView = view
    }
    
    func setRightImage(icon: UIImage) {
        self.rightViewMode = UITextField.ViewMode.always
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = icon
        imageView.image = image
        view.addSubview(imageView)
        self.rightView = view
    }
    
    func font(font: FontName, size: FontSize) {
        self.font = UIFont(name: font.rawValue, size: FUNCTION().getFontSize(size: size.rawValue))
    }
    
    func color(color: UIColor) {
        self.textColor = color
    }
    
    func roundBorderWithColor(borderWidth: CGFloat, borderColor: UIColor, cornerRadius: CGFloat, clipsToBounds: Bool = true) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clipsToBounds
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}

// MARK: - UITextField Styling Extensions
/// These extensions cover various styling properties for UITextField:
///
/// - `maxLength`: The maximum length of character.
/// - `placeHolderColor`: The placeHolder Color of the textfield.
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    // The method is used to cancel the check when use Chinese Pinyin input method.
    // Becuase the alphabet also appears in the textfield when inputting, we should cancel the check.
    func isInputMethod() -> Bool {
        if let positionRange = self.markedTextRange {
            if let _ = self.position(from: positionRange.start, offset: 0) {
                return true
            }
        }
        return false
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        
        guard !self.isInputMethod(), let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!: "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

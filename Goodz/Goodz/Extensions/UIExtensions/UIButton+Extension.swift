//
//  Button+Extension.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import Foundation
import UIKit

extension UIButton {
    func font(font: FontName, size: FontSize) {
        self.titleLabel?.font = UIFont(name: font.rawValue, size: FUNCTION().getFontSize(size: size.rawValue))
    }
    
    func color(color: UIColor) {
        //self.titleLabel?.textColor = color
        self.setTitleColor(color, for: .normal)
    }
    
    func setAttributeText(str1: String, str2: String) {
        let title = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let part1 = NSAttributedString(string: str1,
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.themeGray,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .light),
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let part2 = NSAttributedString(string: str2,
                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.themeBlack,
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle])
        title.append(part1)
        title.append(part2)
        self.setAttributedTitle(title, for: .normal)
        
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    
    
    func title(title: String) {
        
        setTitle(title, for: UIControl.State.normal)
        setTitle(title, for: UIControl.State.selected)
    }
}
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

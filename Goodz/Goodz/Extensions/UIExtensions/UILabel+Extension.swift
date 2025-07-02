//
//  Label+Extension.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import Foundation
import UIKit

extension UILabel {
    func font(font: FontName, size: FontSize) {
            
            self.font = UIFont(name: font.rawValue, size: FUNCTION().getFontSize(size: size.rawValue))
        }
    
    func color(color: UIColor) {
        self.textColor = color
    }
}

// MARK: - UILabel Styling Extensions
/// These extensions provide styling options for UILabels:
///
/// - `lineHeight`: Adjusts the line height for paragraph text.
extension UILabel {
    
    @IBInspectable var lineHeight: CGFloat {
        get {
            guard let paragraphStyle = attributedText?.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else {
                return 0
            }
            return paragraphStyle.lineSpacing + font.lineHeight
        }
        set {
            
            let attributedString = NSMutableAttributedString(string: text ?? "")
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = self.textAlignment
            
            var space = newValue
            
            if let LSpace = newValue as? CGFloat {
                
                space = LSpace - self.font.pointSize - (self.font.lineHeight - self.font.pointSize)
                
                paragraphStyle.lineSpacing = space
                
                attributedString.addAttribute(
                    NSAttributedString.Key.paragraphStyle,
                    value: paragraphStyle,
                    range: NSRange(location: 0, length: attributedString.length))
                
                attributedText = attributedString
            }
        }
    }
}
extension UILabel {
    
    func setAttributeText(fulltext: String, range1 : String, range2 : String, range3: String) {
        let ran1 = (fulltext as NSString).range(of: range1)
        let ran2 = (fulltext as NSString).range(of: range2)
        let ran3 = (fulltext as NSString).range(of: range3)
        let underlineAttriStringS = NSMutableAttributedString(string: fulltext)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Poppins-Medium", size: 14)!, range: ran2)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.themeBlack, range: ran2)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Poppins-Regular", size: 14)!, range: ran1)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.themeGray, range: ran1)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Poppins-Regular", size: 14)!, range: ran3)
        underlineAttriStringS.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.themeGray, range: ran3)
        self.attributedText = underlineAttriStringS
    }
    
    func setConvertDateString(_ inputDateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = dateFormatter.date(from: inputDateString) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.text = dateFormatter.string(from: date)
        } else {
            print("Failed to convert date string.")
            self.text = ""
        }
    }
    
    func removeLastCommaFromAddress() {
        if text?.last == "," {
            text = "\(text?.dropLast() ?? "")"
        }
    }
    
    func setAttributeString(_ normalText: String, _ otherText: String) {
        let strFirst: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeBlack, .font: UIFont(name: FontName.medium.rawValue, size: FUNCTION().getFontSize(size: FontSize.size14.rawValue))!]
        let strSecond: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.themeGray, .font: UIFont(name: FontName.medium.rawValue, size: FUNCTION().getFontSize(size: FontSize.size14.rawValue))!]
        let txtFirstString = NSMutableAttributedString(string: normalText + " ", attributes: strFirst)
        let txtSecondString = NSAttributedString(string: otherText, attributes: strSecond)
        txtFirstString.append(txtSecondString)
        attributedText = txtFirstString
    }
}

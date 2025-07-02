//
//  ValidationExtension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import Foundation
import UIKit

extension UITextField {
    func validatePassword() -> Bool {
        guard let text = self.text else {
            return false
        }
        
        let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#^!%*?&])[A-Za-z\d@$#!%*?&]{8,}$"#
        do {
            let regex = try NSRegularExpression(pattern: passwordRegex)
            let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return !matches.isEmpty
        } catch {
            return false
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

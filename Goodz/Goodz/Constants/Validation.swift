//
//  Validation.swift
//  Goodz
//
//  Created by Akruti on 30/11/23.
//

import Foundation
import UIKit

class Validation {
    
    static let shared = Validation()
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password : String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^\\da-zA-Z]).{8,}$"
        let passwordPred =  NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: password)
    }
    
    func isValidPhone(phoneNumber : String) -> Bool {
        let phoneNumberRegex = "^[0-9]{8,15}$"
        let phoneNumberPred =  NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
        return phoneNumberPred.evaluate(with: phoneNumber)
    }
    
    func isValidateUsername(username: String) -> Bool {
        let usernameRegex = "^[0-9a-zA-Z\\_]{1,32}$"
        let usernamePred =  NSPredicate(format:"SELF MATCHES %@", usernameRegex)
        return usernamePred.evaluate(with: username)
    }
    
    func isValidateName(name: String) -> Bool {
        let fullnameRegex = "(?<! )[-a-zA-Z']{2,32}"
        let fullnamePred =  NSPredicate(format:"SELF MATCHES %@", fullnameRegex)
        return fullnamePred.evaluate(with: name)
    }
    
    func isValidateWithSpaceName(name: String) -> Bool {
        let fullnameRegex = "^[0-9a-zA-Z\\_]{2,32}$" //"(?<! )[-a-zA-Z' ]{2,32}"
        let fullnamePred =  NSPredicate(format:"SELF MATCHES %@", fullnameRegex)
        return fullnamePred.evaluate(with: name)
    }
    
    func isValidateCVV(cvv: String) -> Bool {
        let fullnameRegex = "^[0-9]{3,4}$"
        let fullnamePred =  NSPredicate(format:"SELF MATCHES %@", fullnameRegex)
        return fullnamePred.evaluate(with: cvv)
    }
}

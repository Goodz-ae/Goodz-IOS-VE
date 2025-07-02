//
//  UserDefault.swift
//  Goodz
//
//  Created by Priyanka Poojara on 02/11/23.
//

import Foundation

/// - Note: Write down project keys below
private enum UserDefaultKeys: String {
    case accessToken
    case isLogin
    case isBiometricOn
    case mobileNumber
    case userID
    case currency
    case email
    case recentSearch
    case isGuestUser
    case documentsSubmitted
    case documentsValidated
    case HasAuthenticatedWithFaceID
    case profileCheckExecutedInSession
}

extension UserDefaults {
    
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.isLogin.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.mobileNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.documentsSubmitted.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.documentsValidated.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.profileCheckExecutedInSession.rawValue)
        appUserDefaults.removeValue(.isGuestUser)
        appUserDefaults.removeValue(.isProUser)
        appUserDefaults.removeCodableObject(.currentUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.recentSearch.rawValue)
        
    }
    
    func clearRecentSearch() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.recentSearch.rawValue)
    }
    
    static var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.accessToken.rawValue) ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.accessToken.rawValue)
        }
    }
    
    static var HasAuthenticatedWithFaceID: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.HasAuthenticatedWithFaceID.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.HasAuthenticatedWithFaceID.rawValue)
        }
    }
    
    static var profileCheckExecutedInSession: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.profileCheckExecutedInSession.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.profileCheckExecutedInSession.rawValue)
        }
    }
    
    static var isLogin: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isLogin.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isLogin.rawValue)
        }
    }
    
    static var isBiometricOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isBiometricOn.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isBiometricOn.rawValue)
        }
    }
    
    static var isGuestUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isGuestUser.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isGuestUser.rawValue)
        }
    }
    
    static var isDocumentsSubmitted: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.documentsSubmitted.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.documentsSubmitted.rawValue)
        }
    }
    
    static var isDocumentsValidated: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.documentsValidated.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.documentsValidated.rawValue)
        }
    }
    
    static var userID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.userID.rawValue) ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.userID.rawValue)
        }
    }
    
    static var emailID: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.email.rawValue) ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.email.rawValue)
        }
    }
    
    static var mobileNumber: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.mobileNumber.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.mobileNumber.rawValue)
        }
    }
    
    static var currency: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.currency.rawValue) ?? ""
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.currency.rawValue)
        }
    }
    
    static var recentSearch : [String] {
        get {
            UserDefaults.standard.array(forKey: UserDefaultKeys.recentSearch.rawValue) as? [String] ?? []
        
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.recentSearch.rawValue)
        }
    }
}

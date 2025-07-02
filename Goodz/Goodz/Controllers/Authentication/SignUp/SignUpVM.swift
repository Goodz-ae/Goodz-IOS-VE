//
//  SignUpVM.swift
//  Goodz
//
//  Created by Akruti on 22/12/23.
//

import UIKit

class SignUpVM {
    
    var fail: BindFail?
    var repo = SignUpRepo()
    
    init(fail: BindFail? = nil, repo: SignUpRepo = SignUpRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    func checkLoginData(
        store_name: String?,
        username: String,
        email : String,
        password: String,
        isAgree: Bool,
        firebaseToken: String, userType: String,
        isProUser: Bool,
        completion: @escaping((Bool, [SignUpModel]?) -> Void)) {
            
        if username.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFullName)
            completion(false, [])
        } else if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
            completion(false, [])
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
           completion(false, [])
        }
            if isProUser {
                if (store_name?.isEmpty ?? false) {
                    notifier.showToast(message: Labels.please_enter_comapny_name)
                    completion(false, [])
                }
            }
//        else if !Validation.shared.isValidPhone(phoneNumber: mobile) {
//            notifier.showToast(message: Labels.pleaseEnterValidPhoneNumber)
//            completion(false, [])
//        }
        else if password.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterPassword)
            completion(false, [])
        } else if !Validation.shared.isValidPassword(password: password) {
            notifier.showToast(message: Labels.pleaseEnterValidPassword)
            completion(false, [])
        } else if !isAgree {
            notifier.showToast(message: Labels.pleaseAgreeWithTearmsCondition)
            completion(false, [])
        } else {
            repo.registerApi(store_name , username.trimmingCharacters(in: .whitespacesAndNewlines), email, password, firebaseToken, userType) { status, data, error in
                if status {
                    completion(true, data ?? [])
                } else {
                    if let errorMsg = error {
                        notifier.showToast(message: appLANG.retrive(label: errorMsg))
                    }
                    completion(false, [])
                }
                
            }
        }
    }
    
    
    func checkSocialLoginData(
        username: String,
//        mobile: String,
        isAgree: Bool,
        completion: @escaping((Bool) -> Void)) {
            
        if username.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterUsername)
            completion(false)
        }
//        else if mobile.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterPhoneNumber)
//            completion(false)
//        }
//        else if !Validation.shared.isValidPhone(phoneNumber: mobile) {
//            notifier.showToast(message: Labels.pleaseEnterValidPhoneNumber)
//            completion(false)
//        }
        else if !isAgree {
            notifier.showToast(message: Labels.pleaseAgreeWithTearmsCondition)
            completion(false)
        } else {
            completion(true)
        }
    }
    
}

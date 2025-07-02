//
//  ResetPasswordVM.swift
//  Goodz
//
//  Created by Akruti on 22/12/23.
//

import UIKit

class ResetPasswordVM {
    
    var fail: BindFail?
    var repo = ResetPasswordRepo()
    
    init(fail: BindFail? = nil, repo: ResetPasswordRepo = ResetPasswordRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    func checkResetPasswordData(email: String, newPassword : String, confirmPassword : String, completion : @escaping(Bool) -> Void) {
        if newPassword.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterNewPassword)
            completion(false)
        } else if !Validation.shared.isValidPassword(password: newPassword) {
            notifier.showToast(message: Labels.pleaseEnterValidNewPassword)
           completion(false)
        } else if confirmPassword.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterConfirmedPassword)
            completion(false)
        } else if confirmPassword != newPassword {
            notifier.showToast(message: Labels.newPasswordConfirmPasswordDoesNotMatch)
            completion(false)
        } else {
            completion(true)
        }
    }
    
    // --------------------------------------------
    
    func apiResetPassword(email: String, newPassword : String, confirmPassword : String, completion : @escaping(Bool) -> Void) {
        self.repo.resetPasswordApi(email, newPassword, confirmPassword) { status, message in
            if status {
                completion(true)
            } else {
                completion(false)
                print(message ?? "")
                notifier.showToast(message: appLANG.retrive(label: message ?? Labels.somethingWentWrong))
                
            }
        }
    }
    
    // --------------------------------------------
    
    func checkChangePasswordData(currentPassword : String, newPassword : String, confirmPassword : String, completion : @escaping(Bool) -> Void) {
        if currentPassword.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterCurrentPassword)
            completion(false)
        } else if newPassword.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterNewPassword)
            completion(false)
        } else if !Validation.shared.isValidPassword(password: newPassword) {
            notifier.showToast(message: Labels.pleaseEnterValidNewPassword)
           completion(false)
        } else if confirmPassword.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterConfirmedPassword)
            completion(false)
        } else if confirmPassword != newPassword {
            notifier.showToast(message: Labels.newPasswordConfirmPasswordDoesNotMatch)
           completion(false)
        } else {
            completion(true)
            
        }
    }
    
    // --------------------------------------------
    
    func apiChangePassword(currentPassword : String, newPassword : String, confirmPassword : String, completion : @escaping(Bool) -> Void) {
        self.repo.changePasswordAPI(newPassword, currentPassword) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
}

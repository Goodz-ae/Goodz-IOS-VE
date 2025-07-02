//
//  ForgotPasswordVM.swift
//  Goodz
//
//  Created by Akruti on 22/12/23.
//

import UIKit

class ForgotPasswordVM {
    
    var fail: BindFail?
    var repo = ForgotPasswordRepo()
    
    init(fail: BindFail? = nil, repo: ForgotPasswordRepo = ForgotPasswordRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    func checkLoginData(email : String, completion: @escaping(Bool, [ForgotPasswordModel]?) -> Void) {
        if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
            completion(false, nil)
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
           completion(false, nil)
        } else {
            repo.forgotPasswordApi(email) { status, data, error in
                if status {
                    completion(true, data)
                } else {
                    completion(false, nil)
                    if let errorMsg = error {
                        notifier.showToast(message: appLANG.retrive(label: errorMsg))
                    }
                }
            }
        }
    }
    
}

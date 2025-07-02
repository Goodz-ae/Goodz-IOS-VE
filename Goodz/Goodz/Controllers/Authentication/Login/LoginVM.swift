//
//  LoginVM.swift
//  Goodz
//
//  Created by Akruti on 22/12/23.
//

import UIKit

class LoginVM {
    
    var fail: BindFail?
    var repo = LoginRepo()
    
    init(fail: BindFail? = nil, repo: LoginRepo = LoginRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    func checkLoginData(email : String, password: String, firebaseToken: String, completion: @escaping(Bool, String, [CurrentUserModel]) -> Void) {
        if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
            completion(false, "", [])
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
           completion(false, "", [])
        } else if password.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterPassword)
            completion(false, "", [])
        } else {
            repo.loginApi(email, password, firebaseToken) { status, data, code, error  in
                if status {
                    completion(true, code ?? "", data ?? [])
                } else {
                    if let errorMsg = error {
                        notifier.showToast(message: appLANG.retrive(label: errorMsg))
                    }
                    completion(false, "", [])
                    print(appLANG.retrive(label: error ?? ""))
                }
            }
            
        }
    }
    
    func socialLogin(email : String, password: String, firebaseToken: String, socialType : String, socialRegisterId : String,  completion: @escaping(Bool, String, [CurrentUserModel]) -> Void) {
        repo.loginApi(email, password, firebaseToken, socialType: socialType, socialRegisterId: socialRegisterId) { status, data, code, error  in
            if status {
                completion(true, code ?? "", data ?? [])
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, "", [])
                print(appLANG.retrive(label: error ?? ""))
            }
        }
    }
}

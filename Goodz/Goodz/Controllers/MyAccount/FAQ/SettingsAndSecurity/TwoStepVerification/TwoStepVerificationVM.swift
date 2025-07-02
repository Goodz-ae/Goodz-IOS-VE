//
//  TwoStepVerificationVM.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
import UIKit

class TwoStepVerificationVM {
    // --------------------------------------------
    // MARK: - Custom variables -
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = TwoStepVerificationRepo()
    
    init(fail: BindFail? = nil, repo: TwoStepVerificationRepo = TwoStepVerificationRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom methods -
    // --------------------------------------------
    
    func editMobileNoValidation(
        mobile: String,
        completion: @escaping((Bool, String?) -> Void)) {
            
        if mobile.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterPhoneNumber)
            completion(false, nil)
        } else if !Validation.shared.isValidPhone(phoneNumber: mobile) {
            notifier.showToast(message: Labels.pleaseEnterValidPhoneNumber)
            completion(false, nil)
        }else {
            completion(true, nil)
        }
    }
    
    func editMobileNoAPI(
        mobile: String,
        completion: @escaping((Bool, String?) -> Void)) {
            
            notifier.showLoader()
           repo.editMobileNoAPI(mobile) { status, data, error in
               if status , let otp = data?.first?.result?.first {
                   completion(status, otp.otp ?? "")
               } else {
                   if let errorMsg = error {
                       notifier.showToast(message: appLANG.retrive(label: errorMsg))
                   }
                   completion(status, "")
               }
               notifier.hideLoader()
           }
    }
    
    func getTwoStepVerificationStatusAPI(completion: @escaping((Bool, String?, String?, String?) -> Void)) {
        notifier.showLoader()
        repo.getTwoStepVerificationStatusAPI { status, data, error in
            if status , let isProtectLogin = data?.first?.result?.first?.isProtectLogin , let mobileNo = data?.first?.result?.first?.mobileNo , let isVerified = data?.first?.result?.first?.isVerified {
                completion(status, isProtectLogin, mobileNo, isVerified)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(status, "", "", "")
            }
            notifier.hideLoader()
        }
    }
    
    func updateTwoStepVerificationStatusAPI(isProtectLogin: String, completion: @escaping((Bool, String?) -> Void)) {
        notifier.showLoader()
        repo.updateTwoStepVerificationStatusAPI(isProtectLogin: isProtectLogin) { status, data, error in
            if status {
                completion(status, "")
            }else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(status, "")
            }
            notifier.hideLoader()
        }
    }
}

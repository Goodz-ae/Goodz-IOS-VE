//
//  OTPVarificationVM.swift
//  Goodz
//
//  Created by Akruti on 22/12/23.
//

import UIKit

class OTPVarificationVM {
    
    // --------------------------------------------
    // MARK: - Custom variables -
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = OTPVerifyRepo()
    var repoEmailVerify = SecurityEmailRepo()
    
    init(fail: BindFail? = nil, repo: OTPVerifyRepo = OTPVerifyRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom methods -
    // --------------------------------------------
    
    func checkLoginData(email: String, otp: String, mobile: String, userid: String, completion: @escaping(Bool, String) -> Void) {
        
        repo.otpVerifyApi(email, otp, mobile, userid) { status, data, error in
            if status {
                UserDefaults.emailID = email
                appUserDefaults.setValue(.isGuestUser, to: false)
                completion(true, "")
            } else {
//                if let errorMsg = error {
//                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
//                }
                completion(false, error ?? "")
            }
        }
        
    }
    
    // --------------------------------------------
    
    func apiResendOTP(email: String, _ completion: @escaping((_ status: Bool) -> Void)) {
        repo.resendOTPApi(email) { status, data, error in
            if status {
                //notifier.showToast(message: data?.first?.result?.first?.otp ?? "")
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }

    // --------------------------------------------
    
    func verifyChangeEmailOtpAPI(oldEmail: String, currentEmail : String, otp: String, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repoEmailVerify.verifyChangeEmailOtpAPI(oldEmail: oldEmail, currentEmail: currentEmail, otp: otp) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func changeCurrentEmailAPI(email: String,completion: @escaping((_ otp : String,_ status : Bool)-> Void)) {
           self.repoEmailVerify.changeCurrentEmailAPI(email) { status, data, error in
               if status , let otp = data?.first?.result?.first {
                   completion(otp.otp ?? "", status)
               } else {
                   if let errorMsg = error {
                       notifier.showToast(message: appLANG.retrive(label: errorMsg))
                   }
                   completion( "", status)
               }
               
           }
       }
    
    // --------------------------------------------
    
    func verifyChangeMobileOtpAPI(otp: String, mobileNo: String, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.verifyChangeMobileOtpAPI(otp, mobileNo, { status, data, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        })
    }
}

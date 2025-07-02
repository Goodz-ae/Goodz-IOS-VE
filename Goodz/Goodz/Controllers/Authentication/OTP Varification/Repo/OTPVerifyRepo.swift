//
//  OTPVerifyRepo.swift
//  Goodz
//
//  Created by Priyanka Poojara on 02/01/24.
//

import UIKit
import Alamofire

enum OTPVerifyRouter: RouterProtocol {
    
    case otpVerifyAPI(_ email: String, _ otp: String, _ mobileNo: String, _ userId: String)
    case resendOTPAPI(_ email: String)
    case verifyChangeMobileOtpAPI(_ otp: String, _ mobileNo: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        
        switch self {
        case .otpVerifyAPI:
            return APIEndpoint.verifyOTP
        case .resendOTPAPI:
            return APIEndpoint.resendOTP
        case .verifyChangeMobileOtpAPI:
            return APIEndpoint.verifyChangeMobileOtp
        }
        
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .otpVerifyAPI(let email, let otp, let mobileNo, let userId):
            return [
                ParameterKey.email : email,
                ParameterKey.otp :otp,
                ParameterKey.mobileNo :mobileNo,
                ParameterKey.userId :userId
            ]
        case .resendOTPAPI(let email):
            return [
                ParameterKey.email : email
            ]
            
        case .verifyChangeMobileOtpAPI(let otp, let mobileNo):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.otp :otp,
                ParameterKey.mobileNo :mobileNo
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
}

class OTPVerifyRepo {
    
    func otpVerifyApi(_ email: String, _ otp: String, _ mobile: String, _ userID: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<OTPVerifyModel>]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: OTPVerifyRouter.otpVerifyAPI(email, otp, mobile, userID), responseModel: [ResponseModel<OTPVerifyModel>].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let statuscode = response.first?.code, statuscode == "1" {
                    completion(true, response, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func resendOTPApi(_ email: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<OTPVerifyModel>]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: OTPVerifyRouter.resendOTPAPI(email), responseModel: [ResponseModel<OTPVerifyModel>].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let statuscode = response.first?.code, statuscode == "1" {
                    completion(true, response, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func verifyChangeMobileOtpAPI(_ otp: String, _ mobileNo: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<OTPVerifyModel>]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: OTPVerifyRouter.verifyChangeMobileOtpAPI(otp, mobileNo), responseModel: [ResponseModel<OTPVerifyModel>].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let statuscode = response.first?.code, statuscode == "1" {
                    completion(true, response, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
}

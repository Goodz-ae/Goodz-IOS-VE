//
//  SecurityEmailRepo.swift
//  Goodz
//
//  Created by Akruti on 09/02/24.
//

import Foundation
// OTPVerifyModel
import Alamofire

enum SecurityEmailRouter: RouterProtocol {
    
    case verifyChangeEmailOtpAPI(oldEmail: String, currentEmail : String, otp: String)
    case changeCurrentEmailAPI(email: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        
        switch self {
        case .verifyChangeEmailOtpAPI:
            return APIEndpoint.verifyChangeEmailOtp
        case .changeCurrentEmailAPI:
            return APIEndpoint.changeCurrentEmail
        }
        
    }
    
    var parameters: [String : Any]? {
        switch self {
        
        case .verifyChangeEmailOtpAPI(oldEmail: let oldEmail, currentEmail: let currentEmail, otp: let otp):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.otp : otp,
                ParameterKey.currentEmail : currentEmail,
                ParameterKey.oldEmail : oldEmail
            ]
        case .changeCurrentEmailAPI(email: let email):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.email : email
                ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
}

class SecurityEmailRepo {
    
    func verifyChangeEmailOtpAPI(oldEmail: String, currentEmail : String, otp: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: SecurityEmailRouter.verifyChangeEmailOtpAPI(oldEmail: oldEmail, currentEmail: currentEmail, otp: otp), responseModel: [ResponseModelOne].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let statuscode = response.first?.code, statuscode == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func changeCurrentEmailAPI(_ email: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<OTPVerifyModel>]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: SecurityEmailRouter.changeCurrentEmailAPI(email: email), responseModel: [ResponseModel<OTPVerifyModel>].self) { result in
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

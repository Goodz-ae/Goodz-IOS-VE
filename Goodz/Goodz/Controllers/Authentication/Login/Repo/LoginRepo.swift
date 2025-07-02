//
//  LoginRepo.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit
import Alamofire

enum LoginRouter: RouterProtocol {
    
    case loginAPI(_ email: String, _ password: String, _ firebaseToken: String, socialType: String, socialRegisterId: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        return APIEndpoint.login
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .loginAPI(let email, let password, let firebaseToken, socialType : let socialType, socialRegisterId : let socialRegisterId):

            var params: [String: Any] = [
                ParameterKey.email:email,
                ParameterKey.password:password,
                ParameterKey.firebaseToken: firebaseToken,
                ParameterKey.deviceType : DeviceType.iOS.rawValue,
                ParameterKey.location : (appDelegate.ipInfo?.city ?? "").setComma() + (appDelegate.ipInfo?.region ?? "")
                //social_type, social_register_id
            ]
            if  !socialType.isEmpty {
                params[ParameterKey.socialType] = socialType
            }
            if  !socialRegisterId.isEmpty {
                params[ParameterKey.socialRegisterId] = socialRegisterId
            }
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class LoginRepo {
    
    func loginApi(_ email: String, _ password: String, _ firebaseToken: String, socialType : String = "",
                  socialRegisterId: String = "", _ completion: @escaping((_ status: Bool, _ data: [CurrentUserModel]?, _ code: String?, _ error: String?) -> Void)) {
         notifier.showLoader()
            NetworkManager.dataRequest(with: LoginRouter.loginAPI(email, password, firebaseToken, socialType: socialType, socialRegisterId: socialRegisterId), responseModel: [ResponseModel<CurrentUserModel>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" || firstResponse.code == "-6" {
                    // If there is data in the result property
                    completion(true, firstResponse.result, firstResponse.code, nil)
                } else {
                    // If there is no data or the count is zero
                    completion(false, nil, nil, response.first?.message ?? "")
                }
               
            case .failure(let error):
                print(error)
                completion(false, nil, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
}

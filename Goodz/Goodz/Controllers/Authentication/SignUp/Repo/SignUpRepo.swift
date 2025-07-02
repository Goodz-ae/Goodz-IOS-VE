//
//  SignUpRepo.swift
//  Goodz
//
//  Created by Priyanka Poojara on 01/01/24.
//

import UIKit
import Alamofire

enum SignUpRouter: RouterProtocol {
    
    case signUpAPI(_ store_name : String? , _ userName: String, _ email: String, _ password: String, _ firebaseToken: String, _ userType: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        return APIEndpoint.register
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .signUpAPI(let storeName , let userName, let email, let password, let firebaseToken, let userType):
            
            var parameters =   [
                ParameterKey.username:userName,
                ParameterKey.email:email,
//                ParameterKey.mobile:contact,
                ParameterKey.password:password,
                ParameterKey.firebaseToken:firebaseToken,
                ParameterKey.deviceType:DeviceType.iOS.rawValue,
                ParameterKey.location : (appDelegate.ipInfo?.city ?? "").setComma() + (appDelegate.ipInfo?.region ?? ""),
                ParameterKey.userType : userType
            ]
            if let _storeName = storeName {
                parameters[ParameterKey.store_name] = _storeName
            }
            return parameters
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class SignUpRepo {
    
    func registerApi(_ store_name: String?, _ userName: String, _ email: String, _ password: String, _ firebaseToken: String, _ userType : String, _ completion: @escaping((_ status: Bool, _ data: [SignUpModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: SignUpRouter.signUpAPI(store_name   , userName, email, password, firebaseToken, userType), responseModel: [ResponseModel<SignUpModel>].self) { result in
            switch result {
            case .success(let response):
                
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    // If there is data in the result property
                    completion(true, firstResponse.result, nil)
                } else {
                    // If there is no data or the count is zero
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

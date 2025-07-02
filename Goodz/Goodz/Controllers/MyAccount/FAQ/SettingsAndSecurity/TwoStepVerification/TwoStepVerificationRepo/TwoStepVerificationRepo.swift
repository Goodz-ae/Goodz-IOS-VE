//
//  TwoStepVerificationRepo.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 27/02/24.
//

import Foundation
import UIKit
import Alamofire

enum TwoStepVerificationRouter: RouterProtocol {

    case editMobileNoAPI(mobile: String)
    case getTwoStepVerificationStatus
    case updateTwoStepVerificationStatus(isProtectLogin: String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .editMobileNoAPI:
            return APIEndpoint.editMobileNo
        case .getTwoStepVerificationStatus:
            return APIEndpoint.getTwoStepVerificationStatus
        case .updateTwoStepVerificationStatus:
            return APIEndpoint.updateTwoStepVerificationStatus
        }
       
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .editMobileNoAPI(mobile: let mobile):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.mobileNo :mobile
                ]
        case .getTwoStepVerificationStatus:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .updateTwoStepVerificationStatus(isProtectLogin: let isProtectLogin):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.isProtectLogin :isProtectLogin
                ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}
class TwoStepVerificationRepo {
    
    func editMobileNoAPI(_ mobile: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<OTPVerifyModel>]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: TwoStepVerificationRouter.editMobileNoAPI(mobile: mobile), responseModel: [ResponseModel<OTPVerifyModel>].self) { result in
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
    
    func getTwoStepVerificationStatusAPI(_ completion: @escaping((_ status: Bool, _ data: [ResponseModel<TwoStepVerificationModel>]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: TwoStepVerificationRouter.getTwoStepVerificationStatus, responseModel: [ResponseModel<TwoStepVerificationModel>].self) { result in
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
    
    func updateTwoStepVerificationStatusAPI(isProtectLogin: String, _ completion: @escaping((_ status: Bool, _ data: [ResponseModel<TwoStepVerificationModel>]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: TwoStepVerificationRouter.updateTwoStepVerificationStatus(isProtectLogin: isProtectLogin), responseModel: [ResponseModel<TwoStepVerificationModel>].self) { result in
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

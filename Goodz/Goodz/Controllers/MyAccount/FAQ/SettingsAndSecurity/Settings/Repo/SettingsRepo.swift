//
//  SettingsRepo.swift
//  Goodz
//
//  Created by Akruti on 11/01/24.
//

import Foundation
import UIKit
import Alamofire

enum SettingsRouter: RouterProtocol {
    
    case deleteAccountAPI
    case logoutAccountAPI
    
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .deleteAccountAPI :
            return APIEndpoint.deleteAccount
        case .logoutAccountAPI :
            return APIEndpoint.logoutAccount
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
            
        case .deleteAccountAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
            
        case .logoutAccountAPI:
            return [
                ParameterKey.userId :  UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
            
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class SettingsRepo {
    
    func deleteAccountAPI(_ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: SettingsRouter.deleteAccountAPI, responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
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
    
    // --------------------------------------------
    
    func logoutAccountAPI(_ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: SettingsRouter.logoutAccountAPI, responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
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
    
    // --------------------------------------------
    
}

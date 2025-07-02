//
//  CustomizationRepo.swift
//  Goodz
//
//  Created by Akruti on 17/01/24.
//

import Foundation
import UIKit
import Alamofire
enum CustomizationRouter: RouterProtocol {
    
    case saveCustomizationAPI
    case getCustomizationAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
     
    var endpoint: String {
        switch self {
        case .getCustomizationAPI:
            return APIEndpoint.getCustomization
        case .saveCustomizationAPI:
            return APIEndpoint.saveCustomization
        }
       
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getCustomizationAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .saveCustomizationAPI:
            return nil
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class CustomizationRepo {
    
    func getCustomizationAPI(_ completion: @escaping((_ status: Bool, _ data: [CustomizationModels]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: CustomizationRouter.getCustomizationAPI, responseModel: [ResponseModel<CustomizationModels>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil)
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
    
    func saveCustomizationAPI(_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        let jsonDataStr = SaveCustomizationModel(userID: UserDefaults.userID, token: UserDefaults.accessToken, result: appDelegate.arrCustomization).getJsonString
        let rawData = jsonDataStr?.data(using: .utf8)
        
        NetworkManager.rawDataRequest(with: CustomizationRouter.saveCustomizationAPI, rawData: rawData, responseModel: [ResponseModelOne].self) { result in
           
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
}

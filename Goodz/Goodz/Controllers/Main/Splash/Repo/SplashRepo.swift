//
//  SplashRepo.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
import UIKit
import Alamofire

enum SplashRouter: RouterProtocol {
    
    case generalAPI
    case labelAPI(updateDate : String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .generalAPI:
            return APIEndpoint.general
        case .labelAPI:
            return APIEndpoint.label
        }
       
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .generalAPI:
            return nil
        case .labelAPI(let updateDate):
            return [
                ParameterKey.updatedDate : updateDate
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class SplashRepo {
    
    func generalApi(_ completion: @escaping((_ status: Bool, _ data: [SplashModel]?, _ error: String?) -> Void)) {
         
        NetworkManager.dataRequest(with: SplashRouter.generalAPI, responseModel: [ResponseModel<SplashModel>].self) { result in
           
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
             
        }
    }
    
    func labelApi(updateDate : String, _ completion: @escaping((_ status: Bool, _ data: [LBL]?, _ error: String?, _ updatedData: String) -> Void)) {
         
        NetworkManager.dataRequest(with: SplashRouter.labelAPI(updateDate: updateDate), responseModel: [ResponseModel<LBL>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message, "")
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil, firstResponse.updatedDate ?? "date")
                } else {
                    completion(false, nil, response.first?.message ?? "", "")
                }
               
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, "")
            }

        }
    }
    
}

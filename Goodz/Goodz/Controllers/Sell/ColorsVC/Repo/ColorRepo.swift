//
//  ColorRepo.swift
//  Goodz
//
//  Created by Akruti on 19/01/24.
//

import Foundation
import UIKit
import Alamofire
enum ColorRouter: RouterProtocol {
    
    case getColorsAPI
    case getMaterial
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .getColorsAPI:
            return APIEndpoint.getColors
        case .getMaterial:
            return APIEndpoint.getMaterial
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
       
        case .getColorsAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .getMaterial:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ColorRepo {
    
    func getColorsAPI(_ completion: @escaping((_ status: Bool, _ data: [ColorModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: ColorRouter.getColorsAPI, responseModel: [ResponseModel<ColorModel>].self) { result in
           
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
    
    func getMaterial(_ completion: @escaping((_ status: Bool, _ data: [ColorModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: ColorRouter.getMaterial, responseModel: [ResponseModel<ColorModel>].self) { result in
           
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
    
}

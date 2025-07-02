//
//  BuildingProductRepo.swift
//  Goodz
//
//  Created by Akruti on 07/02/24.
//

import Foundation
import UIKit
import Alamofire

enum BuildingProductRouter: RouterProtocol {
    
    case bundlingProductsAPI(firstStageAmount: String, firstStageDiscount : String, secondStageAmount : String,
                             secondStageDiscount : String, thirdStageAmount : String, thirdStageDiscount : String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
            
        case .bundlingProductsAPI :
            return APIEndpoint.bundlingProducts
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .bundlingProductsAPI(firstStageAmount: let firstStageAmount, firstStageDiscount: let firstStageDiscount, secondStageAmount: let secondStageAmount, secondStageDiscount: let secondStageDiscount, thirdStageAmount: let thirdStageAmount, thirdStageDiscount: let thirdStageDiscount):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
            if !firstStageAmount.isEmpty {
                params[ParameterKey.firstStageAmount] = firstStageAmount
                params[ParameterKey.firstStageDiscount] = firstStageDiscount
            }
            if !secondStageAmount.isEmpty {
                params[ParameterKey.secondStageAmount] = secondStageAmount
                params[ParameterKey.secondStageDiscount] = secondStageDiscount
                       }
            if !thirdStageAmount.isEmpty {
                params[ParameterKey.thirdStageAmount] = thirdStageAmount
                params[ParameterKey.thirdStageDiscount] = thirdStageDiscount
            }
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class BuildingProductRepo {
    
    func bundlingProductsAPI(firstStageAmount: String, firstStageDiscount : String, secondStageAmount : String,
                         secondStageDiscount : String, thirdStageAmount : String, thirdStageDiscount : String, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BuildingProductRouter.bundlingProductsAPI(firstStageAmount: firstStageAmount, firstStageDiscount: firstStageDiscount, secondStageAmount: secondStageAmount, secondStageDiscount: secondStageDiscount, thirdStageAmount: thirdStageAmount, thirdStageDiscount: thirdStageDiscount), responseModel: [ResponseModelOne].self) { result in
           
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

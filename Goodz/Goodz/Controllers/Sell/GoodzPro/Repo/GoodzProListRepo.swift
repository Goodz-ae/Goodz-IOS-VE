//
//  GoodzProListRepo.swift
//  Goodz
//
//  Created by Akruti on 18/03/24.
//

import Foundation
import UIKit
import Alamofire

enum GoodzProListRouter: RouterProtocol {
    
    case subscribeProSellerAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
            
        case .subscribeProSellerAPI :
            return APIEndpoint.subscribeProSeller
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .subscribeProSellerAPI :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.amount : "20",
                ParameterKey.storeId : (appUserDefaults.codableObject(dataType : CurrentUserModel.self, key: .currentUser)?.storeID ?? ""),
                ParameterKey.fcmtoken : "abc123"
                ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class GoodzProListRepo {
    
    func subscribeProSellerAPI(_ completion: @escaping((_ status: Bool, _ data: [GoodzProListModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: GoodzProListRouter.subscribeProSellerAPI, responseModel: [ResponseModel<GoodzProListModel>].self) { result in
            
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

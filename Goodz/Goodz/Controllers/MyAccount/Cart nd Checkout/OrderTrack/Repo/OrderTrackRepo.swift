//
//  OrderTrackRepo.swift
//  Goodz
//
//  Created by Akruti on 19/04/24.
//

import Foundation
import UIKit
import Alamofire

enum OrderTrackRouter: RouterProtocol {
    
    case trackOrderStatusAPI(orderID : String)
    
    
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .trackOrderStatusAPI :
            return APIEndpoint.trackOrderStatus
       
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
            
        case .trackOrderStatusAPI(orderID : let orderID):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.orderId : orderID
                
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class OrderTrackRepo {
    
    func trackOrderStatusAPI(orderID: String,_ completion: @escaping((_ status: Bool, _ data: [OrderTrackDataModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
            
            NetworkManager.dataRequest(with: OrderTrackRouter.trackOrderStatusAPI(orderID: orderID), responseModel: [ResponseModel<OrderTrackDataModel>].self) { result in
                
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
    
    // --------------------------------------------
    
}

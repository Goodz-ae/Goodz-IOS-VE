//
//  AddReviewRepo.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 29/03/24.
//

import Foundation
import UIKit
import Alamofire

enum AddReviewRouter: RouterProtocol {

    case addStoreReview(toStoreID: String, orderId: String, rating: String, comment: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .addStoreReview :
            return APIEndpoint.addStoreReview
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .addStoreReview(toStoreID: let toStoreID, orderId: let orderId, rating: let rating, comment: let comment):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toStoreID : toStoreID,
                ParameterKey.orderId : orderId,
                ParameterKey.comment : comment,
                ParameterKey.rating : rating
            ]
        
            return params
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class AddReviewRepo {
    
    func addStoreReviewAPI(toStoreID: String, orderId: String, rating: String, comment: String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        
        NetworkManager.dataRequest(with: AddReviewRouter.addStoreReview(toStoreID: toStoreID, orderId: orderId, rating: rating, comment: comment), responseModel: [ResponseModelOne].self) { result in
           
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

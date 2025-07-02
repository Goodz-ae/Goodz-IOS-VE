//
//  NegotiationOfferRepo.swift
//  Goodz
//
//  Created by on 10/04/25.
//

import Foundation
import UIKit
import Alamofire

enum NegotiationOfferRouter: RouterProtocol {
    
    case getNegotiationOffers(negotiationStatus: Bool)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .getNegotiationOffers :
            return APIEndpoint.getNegotiationOffers
        default :
            return ""
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getNegotiationOffers(negotiationStatus: let negotiationStatus):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.negotiationStatus : negotiationStatus
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class NegotiationOfferRepo {
    
    func getNegotiationOffer(negotiationStatus: Bool,_ completion: @escaping((_ status: Bool, _ data: [NegotiationOfferModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: NegotiationOfferRouter.getNegotiationOffers(negotiationStatus: negotiationStatus), responseModel: [NegotiationOfferModel].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, [firstResponse], nil)
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


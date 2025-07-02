//
//  MakeAnOfferRepo.swift
//  Goodz
//
//  Created by Akruti on 05/02/24.
//

import Foundation
import UIKit
import Alamofire
/*
 offer_type :
 1= single product
 2= bundle product
 */

struct MakeAnOfferResponseModel: Codable {
    
    let chatId: String?
    
    enum CodingKeys: String, CodingKey {
        
        case chatId = "chat_id"
    }
}

enum MakeAnOfferRouter: RouterProtocol {
    
    case makeAnOfferAPI(offerType : String, productId : String, bundleId: String, amount: String, storeId: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .makeAnOfferAPI :
            return APIEndpoint.makeAnOffer
        }
        
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .makeAnOfferAPI(offerType: let offerType, productId: let productId, bundleId: let bundleId, amount: let amount, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.offerType : offerType,
                ParameterKey.productId : productId,
                ParameterKey.bundleId : bundleId,
                ParameterKey.amount : amount,
                ParameterKey.storeId : storeId
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class MakeAnOfferRepo {
    
    func deleteAddressAPI(offerType : String, productId : String, bundleId: String, amount: String, storeId: String ,_ completion: @escaping((_ status: Bool, _ data: [MakeAnOfferResponseModel]?,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MakeAnOfferRouter.makeAnOfferAPI(offerType: offerType, productId: productId, bundleId: bundleId, amount: amount, storeId: storeId), responseModel: [ResponseModel<MakeAnOfferResponseModel>].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    // If there is data in the result property
                    if firstResponse.code == "1" {
                        completion(true, firstResponse.result, nil)
                    }else if firstResponse.code == "-5" {
                        completion(false, nil, Labels.offerAlreadyAccepted)
                    }else{
                        completion(false, nil, response.first?.message ?? "")
                    }
                    
                } else {
                    // If there is no data or the count is zero
                    
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

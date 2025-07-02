//
//  MyAdsRepo.swift
//  Goodz
//
//  Created by Akruti on 02/02/24.
//

import Foundation
import UIKit
import Alamofire

enum MyAdsRouter: RouterProtocol {
    
    case myAdsItemsAPI(page: Int)
    case boostItemAPI(storeId : String, productId: String, boostID : String, amount: String)
    case boostItemInfoAPI(productId: String)
    case boostedItemInfoAPI(productId: String)
    case boostStoreInfoAPI(storeId : String)
    case boostedStoreInfoAPI(storeId : String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .myAdsItemsAPI :
            return APIEndpoint.myAdsItems
        case .boostItemAPI :
            return APIEndpoint.boostItem
        case .boostItemInfoAPI :
            return APIEndpoint.boostItemInfo
        case .boostedItemInfoAPI :
            return APIEndpoint.boostedItemInfo
        case .boostStoreInfoAPI(storeId: let storeId):
            return APIEndpoint.boostStoreInfo
        case .boostedStoreInfoAPI(storeId: let storeId):
            return APIEndpoint.boostedStoreInfo
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .myAdsItemsAPI(page: let page):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : page
            ]
        
        case .boostItemAPI(storeId: let storeId, productId: let productId, boostID: let boostID, amount: let amount):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId,
                ParameterKey.boostId : boostID,
                ParameterKey.productId : productId,
                ParameterKey.amount : amount

            ]
        case .boostItemInfoAPI(productId: let productId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productId
            ]
        case .boostedItemInfoAPI(productId: let productId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productId
            ]
        case .boostStoreInfoAPI(storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId
                ]
        case .boostedStoreInfoAPI(storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId
                ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class MyAdsRepo {
    
    func boostItemAPI(page: Int,_  completion: @escaping((_ status: Bool, _ data: [MyAdsModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.myAdsItemsAPI(page: page), responseModel: [ResponseModel<MyAdsModel>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message, 0)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil, Int(firstResponse.totalRecords  ?? "0") ?? 0)
                } else {
                    completion(false, nil, response.first?.message ?? "", 0)
                }
               
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, 0)
            }
            notifier.hideLoader()
        }
    }
    
    func boostItemAPI(storeId : String, productId: String, boostID : String, amount: String,_ completion: @escaping((_ status: Bool, _ data: [PaymentModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.boostItemAPI(storeId: storeId, productId: productId, boostID: boostID, amount: amount), responseModel: [PaymentModel].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, [], LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, response, nil)
                } else {
                    completion(false, [],response.first?.message ?? "")
                }
               
            case .failure(let error):
                print(error)
                completion(false, [], LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func boostItemInfoAPI(productId: String,_  completion: @escaping((_ status: Bool, _ data: BoostInfoModal?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.boostItemInfoAPI(productId: productId), responseModel: [ResponseModel<BoostInfoModal>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
               
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
        }
        notifier.hideLoader()
    }
    
    func boostedItemInfoAPI(productId: String,_  completion: @escaping((_ status: Bool, _ data: BoostedInfoModel?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.boostedItemInfoAPI(productId: productId), responseModel: [ResponseModel<BoostedInfoModel>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first, nil)
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
    
    func boostStoreInfoAPI(storeId: String,_  completion: @escaping((_ status: Bool, _ data: [BoostStoreInfoModal]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.boostStoreInfoAPI(storeId: storeId), responseModel: [ResponseModel<BoostStoreInfoModal>].self) { result in
           
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
    
    func boostedStoreInfoAPI(storeId: String,_  completion: @escaping((_ status: Bool, _ data: [BoostedStoreInfoModal]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAdsRouter.boostedStoreInfoAPI(storeId: storeId), responseModel: [ResponseModel<BoostedStoreInfoModal>].self) { result in
           
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

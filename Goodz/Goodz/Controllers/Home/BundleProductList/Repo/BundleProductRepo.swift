//
//  BundleProductRepo.swift
//  Goodz
//
//  Created by Akruti on 18/01/24.
//

import Foundation
import UIKit
import Alamofire

enum BundleProductRouter: RouterProtocol {
    
    case bundleProductListAPI(pageNo : Int,storeId : String)
    case bundleDeleteCart(bundleId : String)
    case addRemoveBundleAPI(productId : String, isAdd : String)
    case bundleCartProductListAPI(isUseCashback : String,isSelectedDeliveryMethod : String, logisticPrice : String, couponCode : String, storeID: String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .bundleProductListAPI:
            return APIEndpoint.bundleProductList
        case .addRemoveBundleAPI:
            return APIEndpoint.addRemoveBundle
        case .bundleCartProductListAPI:
            return APIEndpoint.bundleCartProductList
        case .bundleDeleteCart:
            return APIEndpoint.bundleDeleteCart
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .bundleDeleteCart(bundleId: let bundleId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.bundleId : bundleId
            ]
        case .addRemoveBundleAPI(productId: let productId, isAdd: let isAdd):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productId,
                ParameterKey.isAdd : isAdd
            ]
        case .bundleProductListAPI(pageNo: let pageNo, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId,
                ParameterKey.pageNo : pageNo.description
            ]
        case .bundleCartProductListAPI(let isUseCashback, let isSelectedDeliveryMethod, let logisticPrice, let couponCode, let storeID):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeID,
                ParameterKey.isUseCashback : isUseCashback,
                ParameterKey.logisticPrice : logisticPrice,
                ParameterKey.isSelectedDeliveryMethod : isSelectedDeliveryMethod,
                ParameterKey.couponCode : couponCode
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class BundleProductRepo {
    static let shared : BundleProductRepo = BundleProductRepo()
    
    func bundleProductListAPI(pageNo : Int,storeId : String,_ completion: @escaping((_ status: Bool, _ data: [BundleProductModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BundleProductRouter.bundleProductListAPI(pageNo: pageNo, storeId: storeId), responseModel: [ResponseModel<BundleProductModel>].self) { result in
            
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
    
    func addRemoveBundleAPI(productId : String, isAdd : String, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BundleProductRouter.addRemoveBundleAPI(productId: productId, isAdd: isAdd), responseModel: [ResponseModelOne].self) { result in
            
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
    
    func clearBundleAPI(bundleId : String, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BundleProductRouter.bundleDeleteCart(bundleId: bundleId), responseModel: [ResponseModelOne].self) { result in
            
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
    
    func bundleProductListAPI(isUseCashback : String, logisticPrice : String, isSelectedDeliveryMethod : String, couponCode : String, storeID : String,_ completion: @escaping((_ status: Bool, _ data: [BundleProductCartModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BundleProductRouter.bundleCartProductListAPI(isUseCashback: isUseCashback, isSelectedDeliveryMethod : isSelectedDeliveryMethod, logisticPrice : logisticPrice, couponCode: couponCode, storeID: storeID), responseModel: [ResponseModel<BundleProductCartModel>].self) { result in
            
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
    
    func proceedToCheckoutAPI(chatId : String, toId : String, productId: String = "", bundleId: String = "", isFromBundle: String, _ completion: @escaping((_ status: Bool, _ data: [MyAddressModel]? , _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatListRouter.proceedToCheckoutAPI(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle), responseModel: [ResponseModel<AddressListModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first?.address, nil)
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

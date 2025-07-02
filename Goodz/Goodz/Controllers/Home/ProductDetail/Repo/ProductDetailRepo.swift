//
//  ProductDetailRepo.swift
//  Goodz
//
//  Created by Akruti on 16/01/24.
//

import Foundation
import UIKit
import Alamofire

enum ProductDetailRouter: RouterProtocol {
    
    case productDetailsAPI(storeId : String, productId: String)
    case similarProductListAPI(page : Int, id: String, productId : String)
    case deleteItemAPI(productID: String, storeID: String)
    case hideItemAPI(productID: String, storeID: String, isHide: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .productDetailsAPI :
            return APIEndpoint.productDetails
            
        case .similarProductListAPI:
            return APIEndpoint.similarProductList
        case .deleteItemAPI :
            return APIEndpoint.deleteItem
        case .hideItemAPI :
            return APIEndpoint.hideItem
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .productDetailsAPI(storeId: let storeId, productId: let productId):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.storeId : storeId,
                ParameterKey.productId : productId
            ]
        case .similarProductListAPI(page: let page,id: let id, productId: let productId):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.arrSubSubCategoryId : id,
                ParameterKey.productId : productId,
                ParameterKey.pageNo : page
            ]
        case .deleteItemAPI(productID: let productID, storeID: let storeID):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.storeId : storeID,
                ParameterKey.productId : productID
            ]
        case .hideItemAPI(productID: let productID, storeID: let storeID, isHide: let isHide):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.storeId : storeID,
                ParameterKey.productId : productID,
                ParameterKey.isHide : isHide
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ProductDetailRepo {
    
    func productDetailsAPI(storeId : String, productId: String, _ completion: @escaping((_ status: Bool, _ data: [ProductDetailsModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductDetailRouter.productDetailsAPI(storeId: storeId, productId: productId), responseModel: [ResponseModel<ProductDetailsModel>].self) { result in
            
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
    
    func similarProductListAPI(page : Int,productId : String, categoryId : String, _ completion: @escaping((_ status: Bool, _ data: [SimilarProductModel]?, _ error: String?, _ totalRecoerd : Int?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductDetailRouter.similarProductListAPI(page: page, id: categoryId, productId : productId), responseModel: [ResponseModel<SimilarProductModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message,0)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil,Int(firstResponse.totalRecords ?? "0") ?? 0)
                } else {
                    completion(false, nil, response.first?.message ?? "",0)
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message, 0)
            }
            notifier.hideLoader()
        }
    }
    
    func deleteItemAPI(productID: String, storeID: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductDetailRouter.deleteItemAPI(productID: productID, storeID: storeID), responseModel: [ResponseModelOne].self) { result in
            
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
    
    func hideItemAPI(productID: String, storeID: String, isHide: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ProductDetailRouter.hideItemAPI(productID: productID, storeID: storeID, isHide: isHide), responseModel: [ResponseModelOne].self) { result in
            
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

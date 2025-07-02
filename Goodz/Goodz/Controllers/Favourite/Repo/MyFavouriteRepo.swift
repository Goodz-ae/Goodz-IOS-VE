//
//  MyFavouriteRepo.swift
//  Goodz
//
//  Created by Akruti on 04/01/24.
//

import Foundation

import UIKit
import Alamofire

enum MyFavouriteRouter: RouterProtocol {
    
    case addFavRemoveFavAPI(_ isFav: String, _ productID: String)
    case myFavouriteProductListAPI
    case removeALLFavouriteAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .addFavRemoveFavAPI :
            return APIEndpoint.addFavRemoveFav
        case .myFavouriteProductListAPI :
            return APIEndpoint.favoriteProductList
        case .removeALLFavouriteAPI:
            return APIEndpoint.removeAllFavorites
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .addFavRemoveFavAPI(let isFav, let productID):
            return [
                ParameterKey.isFav : isFav,
                ParameterKey.productId : productID,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .myFavouriteProductListAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .removeALLFavouriteAPI:
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

class MyFavouriteRepo {
    
    func addFavRemoveFavAPI(_ isFav: String, _ productID: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
            NetworkManager.dataRequest(with: MyFavouriteRouter.addFavRemoveFavAPI(isFav, productID), responseModel: [ResponseModelOne].self) { result in
           
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
    
    func myFavouriteProductListAPI(_ completion: @escaping((_ status: Bool, _ data: [MyFavouriteModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: MyFavouriteRouter.myFavouriteProductListAPI, responseModel: [ResponseModel<MyFavouriteModel>].self) { result in
           
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
    
    func removeALLFavouriteAPI(_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: MyFavouriteRouter.removeALLFavouriteAPI, responseModel: [ResponseModelOne].self) { result in
           
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

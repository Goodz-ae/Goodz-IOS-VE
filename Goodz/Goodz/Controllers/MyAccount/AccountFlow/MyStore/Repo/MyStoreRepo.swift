//
//  MyStoreRepo.swift
//  Goodz
//
//  Created by Akruti on 09/01/24.
//

import Foundation
import UIKit
import Alamofire

enum MyStoreRouter: RouterProtocol {
    
    case storeListAPI(pageNo : Int, search : String, isPopular : String)
    case storeDetailsAPI(pageNo : Int, storeId : String)
    case myStoreDetailsAPI(pageNo : Int, storeId : String)
    case storeReviewsAPI(pageNo : Int, storeId : String, sortId : String)
    case reviewsReplyAPI(reviewId: String, message: String, storeId : String)
    case storeFollowerAPI(search : String,pageNo : Int, storeId : String)
    case storeFollowUnFollowAPI(storeId : String, isFollow : String)
    case pinUnpinItemAPI(storeId: String, productId : String, isPinUnpin : String)
    case getCitiesAPI
    case getAreaAPI(_ cityId : String)
    case editStoreDetailsAPI(storeId: String, storeName: String, storeImage: UIImage, storeCityId: String, storeAreaId: String, description: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .storeDetailsAPI :
            return APIEndpoint.storeDetail
        case .storeListAPI :
            return APIEndpoint.storeList
        case .storeReviewsAPI :
            return APIEndpoint.storeReviews
        case .reviewsReplyAPI :
            return APIEndpoint.reviewsReply
        case .storeFollowerAPI :
            return APIEndpoint.storeFollowers
        case .storeFollowUnFollowAPI :
            return APIEndpoint.followUnfollowStore
        case .pinUnpinItemAPI :
            return APIEndpoint.pinUnpinItem
        case .getCitiesAPI :
            return APIEndpoint.getCities
        case .getAreaAPI :
            return APIEndpoint.getAreas
        case .editStoreDetailsAPI :
            return APIEndpoint.editStore
        case .myStoreDetailsAPI :
            return APIEndpoint.myStore
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .storeListAPI(pageNo: let pageNo, search: let search, isPopular: let isPopular):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.search : search,
                ParameterKey.isPopular : isPopular
            ]
        case .storeDetailsAPI(pageNo: let pageNo, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.storeId : storeId
            ]
        case .storeReviewsAPI(pageNo: let pageNo, storeId: let storeId, sortId : let sortId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.storeId : storeId,
                ParameterKey.sortId : sortId
            ]
        case .reviewsReplyAPI(reviewId: let reviewId, message: let message, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.message : message,
                ParameterKey.storeId : storeId,
                ParameterKey.reviewId : reviewId
            ]
        case .storeFollowerAPI(search : let search, pageNo: let pageNo, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.storeId : storeId,
                ParameterKey.searchKeyword : search
            ]
        case .storeFollowUnFollowAPI(storeId: let storeId, isFollow: let isFollow):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId,
                ParameterKey.isFollow : isFollow
            ]
        case .pinUnpinItemAPI(storeId: let storeId, productId: let productId, isPinUnpin: let isPinUnpin):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId,
                ParameterKey.productId : productId,
                ParameterKey.isPinUnpin : isPinUnpin
            ]
        case .getAreaAPI(let cityId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.cityId : cityId
            ]
        case .getCitiesAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .editStoreDetailsAPI(storeId: let storeId, storeName: let storeName, storeImage: let storeImage, storeCityId: let storeCityId, storeAreaId: let storeAreaId, description: let description):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.storeId : storeId,
                ParameterKey.storeName : storeName,
                ParameterKey.storeImage : storeImage,
                ParameterKey.storeCityId : storeCityId,
                ParameterKey.storeAreaId : storeAreaId,
                ParameterKey.description : description
                ]
        case .myStoreDetailsAPI(pageNo: let pageNo, storeId: let storeId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo.description,
                ParameterKey.storeId : storeId
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class MyStoreRepo {
    
    
    func makeAnOfferAPI(offerType : String, productId : String, bundleId: String, amount: String, storeId: String ,_ completion: @escaping((_ status: Bool, _ data: [MakeAnOfferResponseModel]?,_ error: String?) -> Void)) {
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
    
    
    
    func myStoreDetailsAPI(pageNo : Int, storeId : String, _ completion: @escaping((_ status: Bool, _ data: [MyStoreModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.myStoreDetailsAPI(pageNo: pageNo, storeId: storeId), responseModel: [ResponseModel<MyStoreModel>].self) { result in
            
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
    
    func storeDetailsAPI(pageNo : Int, storeId : String, _ completion: @escaping((_ status: Bool, _ data: [StoreDetailsModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.storeDetailsAPI(pageNo: pageNo, storeId: storeId), responseModel: [ResponseModel<StoreDetailsModel>].self) { result in
            
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
    
    // --------------------------------------------
    
    func storeListAPI(pageNo : Int, search : String, isPopular : String, _ completion: @escaping((_ status: Bool, _ data: [StoreModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        NetworkManager.dataRequest(with: MyStoreRouter.storeListAPI(pageNo: pageNo, search: search, isPopular: isPopular), responseModel: [ResponseModel<StoreModel>].self) { result in
            
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
        }
    }
    
    // --------------------------------------------
    
    func storeReviewsAPI(sortId: String, pageNo : Int, storeId : String, _ completion: @escaping((_ status: Bool, _ data: [StoreReviewModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
       //  notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.storeReviewsAPI(pageNo: pageNo, storeId: storeId, sortId: sortId), responseModel: [ResponseModel<StoreReviewModel>].self) { result in
            
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
           // notifier.hideLoader()
        }
    }
    
    // --------------------------------------------
    
    func reviewsReplyAPI(reviewId: String, message: String, storeId : String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.reviewsReplyAPI(reviewId: reviewId, message: message, storeId: storeId), responseModel: [ResponseModel<StoreReviewModel>].self) { result in
            
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
    
    func storeFollowUnFollowAPI(storeId : String, isFollow : String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.storeFollowUnFollowAPI(storeId: storeId, isFollow: isFollow), responseModel: [ResponseModel<StoreReviewModel>].self) { result in
            
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
    
    func storeFollowerAPI(search: String,pageNo : Int, storeId : String, _ completion: @escaping((_ status: Bool, _ data: [StoreFollowerModel]?, _ error: String?, _ totalRecords : Int) -> Void)) {
        NetworkManager.dataRequest(with: MyStoreRouter.storeFollowerAPI(search: search, pageNo: pageNo, storeId: storeId), responseModel: [ResponseModel<StoreFollowerModel>].self) { result in
            
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
        }
    }
    
    // --------------------------------------------
    
    func pinUnpinItemAPI(storeId: String, productId : String, isPinUnpin : String, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.pinUnpinItemAPI(storeId: storeId, productId: productId, isPinUnpin: isPinUnpin), responseModel: [ResponseModelOne].self) { result in
           
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
    
    func getCitiesAPI(_ completion: @escaping((_ status: Bool, _ data: [CitiesModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.getCitiesAPI, responseModel: [ResponseModel<CitiesModel>].self) { result in
           
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
    
    func getAreaAPI(cityId : String,_ completion: @escaping((_ status: Bool, _ data: [AreaModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyStoreRouter.getAreaAPI(cityId), responseModel: [ResponseModel<AreaModel>].self) { result in
           
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
    
    func editStoreDetailsAPI(storeId: String, storeName: String, storeImage: UIImage, storeCityId: String, storeAreaId: String, description: String,_ completion: @escaping((_ status: Bool, _ data: ResponseModelOne?, _ error: String?) -> Void)) {
        notifier.showLoader()
            NetworkManager.multiFormDataRequest(with: MyStoreRouter.editStoreDetailsAPI(storeId: storeId, storeName: storeName, storeImage: storeImage, storeCityId: storeCityId, storeAreaId: storeAreaId, description: description), responseModel: [ResponseModelOne].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first {
                    completion(true, firstResponse, nil)
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


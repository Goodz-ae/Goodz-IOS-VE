//
//  GlobalRepo.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
import UIKit
import Alamofire

enum GlobalRouter: RouterProtocol {
    
    case countryListAPI
    case getProfileAPI
    case addFavRemoveFavAPI(_ isFav: String, _ productID: String)
    case sortListAPI(type: String)
    case addtoCartAPI(productId: String)
    case socialRegisterAPI(socialLoginData: SocialLoginData, userType: String)
    case getIPAddressAPI
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getIPAddressAPI:
            return .get
        default:
            return .post
        }
    }
    
    var endpoint: String {
        switch self {
        case .countryListAPI:
            return APIEndpoint.countryList
        case .getProfileAPI:
            return APIEndpoint.getProfile
        case .addFavRemoveFavAPI:
            return APIEndpoint.addFavRemoveFav
        case .sortListAPI:
            return APIEndpoint.sortList
        case .addtoCartAPI:
            return APIEndpoint.addCart
        case .socialRegisterAPI:
            return APIEndpoint.socialRegister
        case .getIPAddressAPI:
            return ""
        }
        
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .countryListAPI:
            return nil
        case .getProfileAPI:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .addFavRemoveFavAPI(let isFav, let productID):
            return [
                ParameterKey.isFav : isFav,
                ParameterKey.productId : productID,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .sortListAPI(type: let type):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.type : type
            ]
        case .addtoCartAPI(productId: let productId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productId
            ]
        case .socialRegisterAPI(socialLoginData: let socialLoginModel, userType : let userType):
            return [
                ParameterKey.username : socialLoginModel.userName,
                ParameterKey.email : socialLoginModel.email,
                ParameterKey.mobile : socialLoginModel.mobile,
                ParameterKey.firebaseToken : appDelegate.firebaseDeviceToken,
                ParameterKey.countryCode : socialLoginModel.countryCode,
                ParameterKey.socialRegisterId : socialLoginModel.socialId,
                ParameterKey.socialRegisterType : appDelegate.selectedSocialLoginType.rawValue,
                ParameterKey.deviceType : DeviceType.iOS.rawValue,
                ParameterKey.location : (appDelegate.ipInfo?.city ?? "").setComma() + (appDelegate.ipInfo?.region ?? ""),
                ParameterKey.userType : userType
            ]
        case .getIPAddressAPI:
            return nil
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class GlobalRepo {
    
    static let shared : GlobalRepo = GlobalRepo()
    
    func coutryListApi(_ completion: @escaping((_ status: Bool, _ data: [CountryListModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: GlobalRouter.countryListAPI, responseModel: [ResponseModel<CountryListModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    // If there is data in the result property
                    completion(true, firstResponse.result, nil)
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
    
    func getProfileAPI(_ completion: @escaping((_ status: Bool, _ data: [CurrentUserModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: GlobalRouter.getProfileAPI, responseModel: [ResponseModel<CurrentUserModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 , let currentUser = firstResponse.result?.first {
                    appUserDefaults.removeCodableObject(.currentUser)
                    appUserDefaults.setCodableObject(currentUser, forKey: .currentUser)
                    appUserDefaults.setValue(.isProUser, to: (currentUser.isGoodzPro == Status.two.rawValue) ? true : false)
                    completion(true, firstResponse.result, nil)
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
    
    func addFavRemoveFavAPI(_ isFav: String, _ productID: String, _ completion: @escaping((_ status: Bool, _ fromFav: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: GlobalRouter.addFavRemoveFavAPI(isFav, productID), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, true,LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, true,nil)
                } else {
                    completion(false, true,response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, true,LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func sortListAPI(_ type: SortType, isShowLoader: Bool = false, _ completion: @escaping((_ status: Bool, _ data: [SortModel]?, _ error: String?) -> Void)) {
        if isShowLoader {
            notifier.showLoader()
        }
        NetworkManager.dataRequest(with: GlobalRouter.sortListAPI(type: type.title), responseModel: [ResponseModel<SortModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    // If there is data in the result property
                    completion(true, firstResponse.result, nil)
                } else {
                    // If there is no data or the count is zero
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
            
            if isShowLoader {
                notifier.hideLoader()
            }
        }
    }
    
    func addtoCartAPI(_ productId: String, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: GlobalRouter.addtoCartAPI(productId: productId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
                    // If there is data in the result property
                    completion(true, nil)
                } else {
                    // If there is no data or the count is zero
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func socialRegisterAPI(_ socialLoginData: SocialLoginData, userType : String, _ completion: @escaping((_ status: Bool, _ data: [CurrentUserModel]?,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: GlobalRouter.socialRegisterAPI(socialLoginData: socialLoginData, userType: userType), responseModel: [ResponseModel<CurrentUserModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 , let currentUser = firstResponse.result?.first {
                    
                    appUserDefaults.setCodableObject(currentUser, forKey: .currentUser)
                    // If there is data in the result property
                    completion(true, firstResponse.result, nil)
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
    
    func getIPAddressAPI(_ completion: @escaping((_ status: Bool, _ data: IPAddressDataModel?,_ error: String?) -> Void)) {

        NetworkManager.dataRequest(with: GlobalRouter.getIPAddressAPI, responseModel: IPAddressDataModel.self, isGetIpAddress: true) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                completion(true, response, nil)
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
        }
    }
}


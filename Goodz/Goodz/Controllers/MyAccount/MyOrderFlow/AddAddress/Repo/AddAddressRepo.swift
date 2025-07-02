//
//  AddAddressRepo.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
import UIKit
import Alamofire

enum AddAddressRouter: RouterProtocol {
    case getCitiesAPI
    case getAreaAPI(_ cityId : String)
    case addEditAddressAPI(_ fullname : String,_ countryCode : String,_ mobile: String,_ cityId: String,_ areaId: String,_ floor: String,_ streetAddress : String,_ addressId : String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .getCitiesAPI :
            return APIEndpoint.getCities
        case .getAreaAPI :
            return APIEndpoint.getAreas
        case .addEditAddressAPI :
            return APIEndpoint.addEditAddress
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
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
        case .addEditAddressAPI(let fullname, let countryCode, let mobile, let cityId, let areaId, let floor, let streetAddress, let addressId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.fullName : fullname,
                ParameterKey.countryCode : countryCode,
                ParameterKey.mobile : mobile,
                ParameterKey.cityId : cityId,
                ParameterKey.areaId : areaId,
                ParameterKey.floor : floor,
                ParameterKey.streetAddress : streetAddress,
                ParameterKey.addressId : addressId
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class AddAddressRepo {
    
    func getCitiesAPI(_ completion: @escaping((_ status: Bool, _ data: [CitiesModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: AddAddressRouter.getCitiesAPI, responseModel: [ResponseModel<CitiesModel>].self) { result in
           
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
        NetworkManager.dataRequest(with: AddAddressRouter.getAreaAPI(cityId), responseModel: [ResponseModel<AreaModel>].self) { result in
           
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
    
    func addEditAddressAPI(fullname : String, countryCode : String, mobile: String, cityId: String, areaId: String, floor: String, streetAddress : String, addressId : String,
                    _ completion: @escaping((_ status: Bool, _ data: [AddEditAddressModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: AddAddressRouter.addEditAddressAPI(fullname, countryCode, mobile, cityId, areaId, floor, streetAddress, addressId), responseModel: [ResponseModel<AddEditAddressModel>].self) { result in
           
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

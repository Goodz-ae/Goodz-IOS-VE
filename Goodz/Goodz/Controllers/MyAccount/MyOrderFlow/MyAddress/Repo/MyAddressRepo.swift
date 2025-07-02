//
//  MyAddressRepo.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
import UIKit
import Alamofire

enum MyAddressRouter: RouterProtocol {
    
    case myAddressAPI(_ pageNo : String)
    case deleteAddressAPI(_ addressId : String)
    case setDefaultAddress(addressId : String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .myAddressAPI :
            return APIEndpoint.myAddressList
        case .deleteAddressAPI :
            return APIEndpoint.deleteAddress
        case .setDefaultAddress:
            return APIEndpoint.setDefaultAddress
        }
       
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .myAddressAPI(let pageNo):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.pageNo : pageNo
            ]
        case .deleteAddressAPI(let addressId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.addressId : addressId
            ]
        case .setDefaultAddress(addressId: let addressId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.addressId : addressId
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class MyAddressRepo {
    
    func myAddressAPI(pageNo : Int,_ completion: @escaping((_ status: Bool, _ data: [MyAddressModel]?, _ error: String?,_ totalRecords : Int) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAddressRouter.myAddressAPI(String(pageNo)), responseModel: [ResponseModel<MyAddressModel>].self) { result in
            
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
    
    func deleteAddressAPI(addressId : String,_ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAddressRouter.deleteAddressAPI(addressId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, response.first?.message ?? "")
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
    
    func setDefaultAddress(addressId : String,_ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: MyAddressRouter.setDefaultAddress(addressId: addressId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, response.first?.message ?? "")
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

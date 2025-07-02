//
//  OrderDetailsRepo.swift
//  Goodz
//
//  Created by Akruti on 30/01/24.
//

import Foundation
import UIKit
import Alamofire

enum OrderDetailsRouter: RouterProtocol {
    
    case orderDetailsAPI(orderId: String)
    case sellDetailsAPI(sellId: String)
    case confirmReceptionAPI(orderId: String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .confirmReceptionAPI :
            return APIEndpoint.confirmReception
        case .orderDetailsAPI :
            return APIEndpoint.orderDetails
        case .sellDetailsAPI :
            return APIEndpoint.sellDetails
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .confirmReceptionAPI(orderId: let orderId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.orderId : orderId
            ]
        case .orderDetailsAPI(orderId: let orderId):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.orderId : orderId
            ]
        case .sellDetailsAPI(sellId: let sellId):
            return [
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.sellId : sellId
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class OrderDetailsRepo {
    
    func confrimReception(param : ConfrimReception,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.confrimReception(param: param), responseModel: [ResponseModelOne].self) { result in
            
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
     
    
    
    func chat_add_pickup_slots(param : slotBookingModel,_   completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        let jsonDataStr = param.getJsonString
        let rawData = jsonDataStr?.data(using: .utf8)
        
        NetworkManager.rawDataRequest(with: ChatListRouter.chat_add_pickup_slots2, rawData: rawData, responseModel: [ResponseModelOne].self) { result in
           
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
    
    func chat_confirm_pickup_slot(messageData : ConfirPickSlotModel,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.chat_confirm_pickup_slot(messageData: messageData), responseModel: [ResponseModelOne].self) { result in
            
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
    
    func chat_update_pickup_availability(messageData : ConfirAvailbelity,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)){
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ChatListRouter.chat_update_pickup_availability(messageData: messageData), responseModel: [ResponseModelOne].self) { result in
            
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
    
    func confirmReceptionAPI(orderId: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
            NetworkManager.dataRequest(with: OrderDetailsRouter.confirmReceptionAPI(orderId: orderId), responseModel: [ResponseModelOne].self) { result in
           
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
    
    func orderDetailsAPI(orderId: String, _ completion: @escaping((_ status: Bool, _ data: [OrderDetailsResult]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: OrderDetailsRouter.orderDetailsAPI(orderId: orderId), responseModel: [ResponseModel<OrderDetailsResult>].self) { result in
           
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
    
    func sellDetailsAPI(sellId: String, _ completion: @escaping((_ status: Bool, _ data: [OrderDetailsResult]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: OrderDetailsRouter.sellDetailsAPI(sellId: sellId), responseModel: [ResponseModel<OrderDetailsResult>].self) { result in
           
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

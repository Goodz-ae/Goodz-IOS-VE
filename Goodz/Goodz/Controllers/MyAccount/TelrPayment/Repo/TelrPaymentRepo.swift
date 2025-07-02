//
//  TelrPaymentRepo.swift
//  Goodz
//
//  Created by Akruti on 10/05/24.
//

import Foundation
import UIKit
import Alamofire

enum TelrPaymentRouter: RouterProtocol {
    
    case handlePaymentCancelAPI(data : PaymentModel?, cartData: AddOrderModel?)
    case handlePaymentSuccessAPI(data : PaymentModel?, cartData: AddOrderModel?)
    
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .handlePaymentCancelAPI :
            return APIEndpoint.handlePaymentCancel
        case .handlePaymentSuccessAPI :
            return APIEndpoint.handlePaymentSuccess
        
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .handlePaymentCancelAPI(data: let data, cartData : let cartdata):
           
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
            ]
            if let boostData = data {
                params[ParameterKey.boostPlan] = boostData.boostPlan
                params[ParameterKey.boostId] = boostData.boostID
                params[ParameterKey.productId] = boostData.productID
                params[ParameterKey.boostPlanId] = boostData.boostPlanID
                params[ParameterKey.storeId] = boostData.storeID
                params[ParameterKey.boostPlanStore] = boostData.boostPlanStore
            }
            if let dataCart = cartdata {
                params[ParameterKey.orderId] = dataCart.orderID
                params[ParameterKey.uniqueOrderId] = dataCart.uniqueOrderID
                params[ParameterKey.storeId] = dataCart.storeID
                params[ParameterKey.chatId] = dataCart.chatId
                params[ParameterKey.deliveryMethod] = dataCart.deliveryMethod
                params[ParameterKey.goodzWalletCashback] = dataCart.goodzWalletCashback
                params[ParameterKey.totalPrice] = dataCart.totalPrice
                params[ParameterKey.subTotal] = dataCart.subTotal
                params[ParameterKey.isFromChat] = dataCart.isFromChat
                params[ParameterKey.addressId] = dataCart.addressID
                params[ParameterKey.bundleId] = dataCart.bundleID
            }
                
            return params
        case .handlePaymentSuccessAPI(data: let data, cartData : let cartdata):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
            ]
            if let boostData = data {
                params[ParameterKey.boostPlan] = boostData.boostPlan
                params[ParameterKey.boostId] = boostData.boostID
                params[ParameterKey.productId] = boostData.productID
                params[ParameterKey.boostPlanId] = boostData.boostPlanID
                params[ParameterKey.storeId] = boostData.storeID
                params[ParameterKey.boostPlanStore] = boostData.boostPlanStore
            }
            if let dataCart = cartdata {
                params[ParameterKey.orderId] = dataCart.orderID
                params[ParameterKey.uniqueOrderId] = dataCart.uniqueOrderID
                params[ParameterKey.storeId] = dataCart.storeID
                params[ParameterKey.chatId] = dataCart.chatId
                params[ParameterKey.deliveryMethod] = dataCart.deliveryMethod
                params[ParameterKey.goodzWalletCashback] = dataCart.goodzWalletCashback
                params[ParameterKey.totalPrice] = dataCart.totalPrice
                params[ParameterKey.subTotal] = dataCart.subTotal
                params[ParameterKey.isFromChat] = dataCart.isFromChat
                params[ParameterKey.addressId] = dataCart.addressID
                params[ParameterKey.bundleId] = dataCart.bundleID
            }
                
            return params
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class TelrPaymentRepo {
    
    func handlePaymentCancelAPI(data : PaymentModel?, cartData: AddOrderModel?, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         //notifier.showLoader()
        NetworkManager.dataRequest(with: TelrPaymentRouter.handlePaymentCancelAPI(data: data, cartData: cartData), responseModel: [ResponseModelOne].self) { result in
           
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
            // notifier.hideLoader()
        }
    }
    
    func handlePaymentSuccessAPI(data : PaymentModel?, cartData: AddOrderModel?, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         //notifier.showLoader()
        NetworkManager.dataRequest(with: TelrPaymentRouter.handlePaymentSuccessAPI(data: data, cartData: cartData), responseModel: [ResponseModelOne].self) { result in
           
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

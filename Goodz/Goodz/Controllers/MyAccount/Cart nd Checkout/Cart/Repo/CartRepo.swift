//
//  CartRepo.swift
//  Goodz
//
//  Created by Akruti on 22/01/24.
//

import Foundation
import UIKit
import Alamofire

enum CartRouter: RouterProtocol {
    
    case cartListAPI(couponCode : String, deviceId :String, isUseCashback : String)
    case deleteCartItem(cartId : String)
    case updateCartDeliveryMethodAPi(cartId : String, deliveryMethodId : String)
    case addOrder(productId: String,couponCode : String, addressId : String, vat : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String, deliveryMethod: String, walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .cartListAPI:
            return APIEndpoint.cartList
        case .deleteCartItem :
            return APIEndpoint.deleteCart
        case .updateCartDeliveryMethodAPi :
            return APIEndpoint.updateCartDeliveryMethod
        case .addOrder:
            return APIEndpoint.addOrder
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .cartListAPI(couponCode: let couponCode, deviceId: let deviceId, let isUseCashback) :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.deviceId : deviceId,
                ParameterKey.couponCode : couponCode,
                ParameterKey.isUseCashback : isUseCashback
            ]
        case .deleteCartItem(cartId: let cartId):
            return [
                ParameterKey.cartId : cartId
                ]
        case .updateCartDeliveryMethodAPi(cartId: let cartId, deliveryMethodId: let deliveryMethodId):
            return [
                ParameterKey.cartId : cartId,
                ParameterKey.deliveryMethodId : deliveryMethodId
                ]
        case .addOrder(productId : let productId,couponCode: let couponCode, addressId: let addressId, vat: let vat, discountedPrice: let discountedPrice, subtotalPrice: let subtotalPrice, payablePrice: let payablePrice, deliveryPrice: let deliveryPrice, orderType: let orderType, deliveryMethod: let deliveryMethod, walletCashbackBalance: let walletCashbackBalance, goodzWalletCashback: let  goodzWalletCashback,
                       remaimingWalletCashbackBalance: let remaimingWalletCashbackBalance):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.productId : productId,
                ParameterKey.couponCode : couponCode,
                ParameterKey.addressId : addressId,
                ParameterKey.vat : vat,
                ParameterKey.discountedPrice : discountedPrice,
                ParameterKey.subtotalPrice : subtotalPrice,
                ParameterKey.payablePrice : payablePrice,
                ParameterKey.deliveryPrice : deliveryPrice,
                ParameterKey.orderType : orderType,
                ParameterKey.deliveryMethod : deliveryMethod,
                ParameterKey.remaimingWalletCashbackBalance : remaimingWalletCashbackBalance,
                ParameterKey.goodzWalletCashback : goodzWalletCashback,
                ParameterKey.walletCashbackBalance : walletCashbackBalance
                
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class CartRepo {
    
    func cartListAPI(couponCode : String, deviceId :String, isUseCashback : String,_ completion: @escaping((_ status: Bool, _ data: [CartModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: CartRouter.cartListAPI(couponCode: couponCode, deviceId: deviceId, isUseCashback: isUseCashback), responseModel: [ResponseModel<CartModel>].self) { result in
           
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
    
    func deleteCartItem(cartId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: CartRouter.deleteCartItem(cartId: cartId), responseModel: [ResponseModelOne].self) { result in
           
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
    
    func updateCartDeliveryMethodAPi(cartId : String, deliveryMethodId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: CartRouter.updateCartDeliveryMethodAPi(cartId: cartId, deliveryMethodId: deliveryMethodId), responseModel: [ResponseModelOne].self) { result in
           
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
    
    func addOrderAPI(productId : String, couponCode : String, addressId : String, vat : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String, deliveryMethod : String, walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String,_ completion: @escaping((_ status: Bool, _ data: [AddOrderModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
    NetworkManager.dataRequest(with: CartRouter.addOrder(productId : productId,couponCode: couponCode, addressId: addressId, vat: vat, discountedPrice: discountedPrice, subtotalPrice: subtotalPrice, payablePrice: payablePrice, deliveryPrice: deliveryPrice, orderType: orderType, deliveryMethod: deliveryMethod,walletCashbackBalance: walletCashbackBalance, goodzWalletCashback: goodzWalletCashback,remaimingWalletCashbackBalance: remaimingWalletCashbackBalance), responseModel: [ResponseModel<AddOrderModel>].self) { result in
           
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

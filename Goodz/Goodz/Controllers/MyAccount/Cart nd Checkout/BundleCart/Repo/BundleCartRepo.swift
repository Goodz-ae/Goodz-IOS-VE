//
//  CartRepo.swift
//  Goodz
//
//  Created by Akruti on 22/01/24.
//

import Foundation
import UIKit
import Alamofire

enum BundleCartRouter: RouterProtocol {
    case deliveryMethodsListAPI(bundleId: String)
    case cartListAPI(couponCode : String, deviceId :String)
    case deleteCartItem(cartId : String)
    case updateCartDeliveryMethodAPi(cartId : String, deliveryMethodId : String)
    case addOrder(bundleId: String, storeId : String, addressId : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String, deliveryMethod : String, walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String, vatPrice : String, bundleDiscountPrice: String, bundleDiscountPercentage: String)

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
            return APIEndpoint.addOrderBundle
        case .deliveryMethodsListAPI :
            return APIEndpoint.deliveryMethodsList
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .cartListAPI(couponCode: let couponCode, deviceId: let deviceId) :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.deviceId : deviceId,
                ParameterKey.couponCode : couponCode
            ]
        case .deliveryMethodsListAPI(bundleId: let bundleId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.cartType : "1",
                ParameterKey.bundleId : bundleId,
                ParameterKey.isCart : "1"
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
        case .addOrder(bundleId : let bundleId, storeId: let storeId, addressId: let addressId, discountedPrice: let discountedPrice, subtotalPrice: let subtotalPrice, payablePrice: let payablePrice, deliveryPrice: let deliveryPrice, orderType: let orderType, let deliveryMethod, let walletCashbackBalance, let goodzWalletCashback, let remaimingWalletCashbackBalance, vatPrice : let vatPrice, bundleDiscountPrice: let bundleDiscountPrice, bundleDiscountPercentage: let bundleDiscountPercentage):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.bundleId : bundleId,
                ParameterKey.storeId : storeId,
                ParameterKey.addressId : addressId,
                ParameterKey.discountedPrice : discountedPrice,
                ParameterKey.subtotalPrice : subtotalPrice,
                ParameterKey.payablePrice : payablePrice,
                ParameterKey.deliveryPrice : deliveryPrice,
                ParameterKey.orderType : orderType,
                ParameterKey.deliveryMethod : deliveryMethod,
                ParameterKey.walletCashbackBalance : walletCashbackBalance,
                ParameterKey.goodzWalletCashback : goodzWalletCashback,
                ParameterKey.remaimingWalletCashbackBalance : remaimingWalletCashbackBalance,
                ParameterKey.vat : vatPrice,
                ParameterKey.bundleDiscountPrice : bundleDiscountPrice,
                ParameterKey.bundleDiscountPercentage : bundleDiscountPercentage
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class BundleCartRepo {
    func deliveryMethodsListAPI(bundleId : String,_ completion: @escaping((_ status: Bool, _ data: [DeliveryMethodsModel]?, _ logisticPrice : String, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: BundleCartRouter.deliveryMethodsListAPI(bundleId: bundleId), responseModel: [ResponseModel<DeliveryMethodsModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil,"", LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result,firstResponse.logisticPrice ?? "", nil)
                } else {
                    completion(false, nil,"", response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil,"", LocalErrors.serverError(error.errorMessage()).message)
            }
             notifier.hideLoader()
        }
    }
    
    func cartListAPI(couponCode : String, deviceId :String,_ completion: @escaping((_ status: Bool, _ data: [BundleCartModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: BundleCartRouter.cartListAPI(couponCode: couponCode, deviceId: deviceId), responseModel: [ResponseModel<BundleCartModel>].self) { result in

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

    func addBundleOrderAPI(bundleId : String, storeId : String, addressId : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String, deliveryMethod : String, walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String, vatPrice : String, bundleDiscountPrice: String, bundleDiscountPercentage: String,_ completion: @escaping((_ status: Bool, _ data: [AddOrderModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
      NetworkManager.dataRequest(with: BundleCartRouter.addOrder(bundleId : bundleId, storeId: storeId, addressId: addressId, discountedPrice: discountedPrice, subtotalPrice: subtotalPrice, payablePrice: payablePrice, deliveryPrice: deliveryPrice, orderType: orderType, deliveryMethod: deliveryMethod, walletCashbackBalance : walletCashbackBalance, goodzWalletCashback: goodzWalletCashback, remaimingWalletCashbackBalance : remaimingWalletCashbackBalance, vatPrice: vatPrice, bundleDiscountPrice: bundleDiscountPrice, bundleDiscountPercentage: bundleDiscountPercentage), responseModel: [ResponseModel<AddOrderModel>].self) { result in

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

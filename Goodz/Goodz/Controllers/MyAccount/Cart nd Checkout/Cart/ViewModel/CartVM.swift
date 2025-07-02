//
//  CartVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class CartVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrPayment : [PaymentOptionModel] = []
    var arrItems : [CartProductModel] = []
    var fail: BindFail?
    var repo = CartRepo()
    var dataCart : CartModel?
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrPayment = [PaymentOptionModel(title: Labels.creditCard, imgCards: .iconCards),
                           PaymentOptionModel(title: Labels.applePay, imgCards: .applePay),
                           PaymentOptionModel(title: Labels.googlePay, imgCards: .googlePayLogo),
                           PaymentOptionModel(title: Labels.payPal, imgCards: .paypal)]
    }
    
    // --------------------------------------------
    
    func fetchCart(couponCode : String, deviceId : String,isUseCashback : String, completion: @escaping((Bool) -> Void)) {
        
        self.repo.cartListAPI(couponCode: couponCode, deviceId: deviceId, isUseCashback: isUseCashback) { status, data, error in
            if status {
                if let cart = data?.first {
                    self.dataCart = cart
                    self.arrItems = self.dataCart?.products ?? []
                    completion(true)
                    return
                }
                self.arrItems =  []
                self.dataCart = nil
                completion(false)
            } else {
                self.arrItems =  []
                self.dataCart = nil
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func setNumberOfPayment() -> Int {
        self.arrPayment.count
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> PaymentOptionModel {
        self.arrPayment[row]
    }
    
    // --------------------------------------------
    
    func setNumberOfItems() -> Int {
        self.arrItems.count
    }
    
    // --------------------------------------------
    
    func setRowDataOfItme(row: Int) -> CartProductModel {
        self.arrItems[row]
    }
    
    // --------------------------------------------
 
    func deleteItem(cartId: String, completion: @escaping((Bool) -> Void)) {
        self.repo.deleteCartItem(cartId: cartId) { status, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
 
    func updateDeliveryMethods(cartId: String,deliveryMethodId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.updateCartDeliveryMethodAPi(cartId: cartId, deliveryMethodId: deliveryMethodId) { status, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func orderPay(productId : String,couponCode : String, addressId : String, vat : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String, deliveryMethod : String,walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String, completion: @escaping((Bool, AddOrderModel) -> Void)) {
      self.repo.addOrderAPI(productId : productId,couponCode: couponCode, addressId: addressId, vat: vat, discountedPrice: discountedPrice, subtotalPrice: subtotalPrice, payablePrice: payablePrice, deliveryPrice: deliveryPrice, orderType: orderType, deliveryMethod: deliveryMethod,walletCashbackBalance: walletCashbackBalance, goodzWalletCashback: goodzWalletCashback, remaimingWalletCashbackBalance: remaimingWalletCashbackBalance) { status, data, error  in
          let addOrder = AddOrderModel(orderID: "", uniqueOrderID: "", storeID: "", chatId: "", deliveryMethod: "", goodzWalletCashback: "", totalPrice: "", subTotal: "", isFromChat: "", redirectURL: "", successURL: "", cancelURL: "", declinedURL: "", bundleID: "", addressID: "")
          if let errorMsg = error {
              notifier.showToast(message: appLANG.retrive(label: errorMsg))
          }
      if status {
          completion(true, data?.first ?? addOrder)
      } else {
        completion(false, addOrder)
      }
          
    }
  }
}

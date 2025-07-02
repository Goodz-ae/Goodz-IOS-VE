//
//  CartVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class BundleCartVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = BundleCartRepo()
    var repoBundle = BundleProductRepo()
    var totalRecords = Int()
    var arrBundleProducts : [BundleProductCartModel] = [BundleProductCartModel]()
    var arrDeliveryMethods : [DeliveryMethodsModel] = [DeliveryMethodsModel]()
    var logisticPrice : String = "0"
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(isUseCashback : String, logisticPrice: String,isSelectedDeliveryMethod : String, couponCode : String, storeID: String,completion: @escaping((Bool) -> Void)) {
        repoBundle.bundleProductListAPI(isUseCashback: isUseCashback, logisticPrice: logisticPrice, isSelectedDeliveryMethod: isSelectedDeliveryMethod, couponCode: couponCode, storeID: storeID) { status, data, error  in
            if status {
                if let res = data {
                    self.arrBundleProducts = res
                    completion(true)
                    return
                }
                self.arrBundleProducts = []
                completion(false)
            } else {
                self.arrBundleProducts = []
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrBundleProducts.first?.bundleAddedProductList?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setCollectionCategories(row: Int) -> BundleProductModel {
        (self.arrBundleProducts.first?.bundleAddedProductList?[row]) ?? BundleProductModel(productID: "", storeId: "", storeImage: "", likecount: "", pruductName: "", storeName: "", discountPrice: "", price: "", isAdded: "", isFav: "", isOwner: "", brandName: "")
    }
    
    // --------------------------------------------
    
    func addRemoveBundle(productId: String, isAdd : String, completion: @escaping((Bool, String) -> Void)) {
        self.repoBundle.addRemoveBundleAPI(productId: productId, isAdd: isAdd) { status, error in
            if status {
                completion(true, "")
            } else {
                completion(false, error ?? "")
            }
        }
    }
    
    // --------------------------------------------
    
    func clearBundle(bundleId: String, completion: @escaping((Bool) -> Void)) {
        self.repoBundle.clearBundleAPI(bundleId: bundleId) { status, error in
            if status {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func orderPay(bundleId : String, storeId : String, addressId : String, discountedPrice : String, subtotalPrice : String, payablePrice : String, deliveryPrice : String, orderType : String,deliveryMethod : String, walletCashbackBalance : String, goodzWalletCashback : String, remaimingWalletCashbackBalance : String, vatPrice: String, bundleDiscountPrice: String, bundleDiscountPercentage: String, completion: @escaping((Bool, AddOrderModel) -> Void)) {
        self.repo.addBundleOrderAPI(bundleId: bundleId, storeId: storeId, addressId: addressId, discountedPrice: discountedPrice, subtotalPrice: subtotalPrice, payablePrice: payablePrice, deliveryPrice: deliveryPrice, orderType: orderType, deliveryMethod: deliveryMethod, walletCashbackBalance : walletCashbackBalance, goodzWalletCashback: goodzWalletCashback, remaimingWalletCashbackBalance : remaimingWalletCashbackBalance, vatPrice: vatPrice, bundleDiscountPrice: bundleDiscountPrice, bundleDiscountPercentage: bundleDiscountPercentage) { status,data, error in
            let addOrder = AddOrderModel(orderID: "", uniqueOrderID: "", storeID: "", chatId: "", deliveryMethod: "", goodzWalletCashback: "", totalPrice: "", subTotal: "", isFromChat: "", redirectURL: "", successURL: "", cancelURL: "", declinedURL: "", bundleID: "", addressID: "")
            if status {
                if let orderDAta = data?.first {
                    completion(true, orderDAta)
                } else {
                    completion(false, addOrder)
                }
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, addOrder)
            }
        }
    }
    
    func fetchConditionsData(bundleId: String, completion: @escaping((Bool) -> Void)) {
        self.repo.deliveryMethodsListAPI(bundleId: bundleId) { status, data, logisticPrice, error in
            if status, let list = data {
                self.arrDeliveryMethods = list
                self.logisticPrice = logisticPrice
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
}

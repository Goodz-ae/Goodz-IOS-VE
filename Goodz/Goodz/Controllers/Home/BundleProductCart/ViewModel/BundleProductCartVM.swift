//
//  BundleProductCartVM.swift
//  Goodz
//
//  Created by Akruti on 22/01/24.
//

import Foundation
class BundleProductCartVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = BundleProductRepo()
    var totalRecords = Int()
    var arrBundleProducts : [BundleProductCartModel] = [BundleProductCartModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(storeID: String, completion: @escaping((Bool) -> Void)) {
        repo.bundleProductListAPI(isUseCashback: "0", logisticPrice: "0", isSelectedDeliveryMethod: "0", couponCode: "0", storeID: storeID){ status, data, error  in
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
        self.repo.addRemoveBundleAPI(productId: productId, isAdd: isAdd) { status, error in
            if status {
                print("success fully add remove bundle")
                completion(true, "")
            } else {
                completion(false, error ?? "")
            }
        }
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            if status {
                print("success fullt add remove favourite")
                completion(true)
            } else {
                print(error)
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func proceedToCheckoutAPI(chatId : String = "", toId: String = "", productId: String = "", bundleId: String = "", isFromBundle: String,_ completion: @escaping((_ status: Bool, _ address:[MyAddressModel]? ) -> Void)) {
        self.repo.proceedToCheckoutAPI(chatId: chatId, toId: toId, productId: productId, bundleId: bundleId, isFromBundle: isFromBundle) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false, data)
            } else {
                completion(true, data)
            }
            
            
        }
    }
    
    // --------------------------------------------
    
}

//
//  BoostItemDetailsVM.swift
//  Goodz
//
//  Created by Akruti on 13/12/23.
//

import Foundation
class BoostItemDetailsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrBoostPlan : [BoostPlan] = []
    var fail: BindFail?
    var repo = MyAdsRepo()
    var myAdsModel: MyAdsModel?
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func boostItemInfo(productId: String,completion: @escaping((Bool, BoostInfoModal) -> Void)) {
        self.repo.boostItemInfoAPI(productId: productId) { status, data, error in
            if status ,let response = data {
                self.arrBoostPlan = response.boostPlans ?? []
                completion(status, response)
            } else {
                self.arrBoostPlan = []
                completion(false, BoostInfoModal(productID: "", productName: "", brandName: "", discountedPrice: "", originalPrice: "", productImage: "", isBoosted: "", remainingDaysOfBoost: "", boostPlans: []))
            }
        }
    }
    
    // --------------------------------------------
    
    func boostedItemInfoAPI(productId: String,completion: @escaping((Bool, BoostedInfoModel) -> Void)) {
        self.repo.boostedItemInfoAPI(productId: productId) { status, data, error in
            if status ,let response = data {
                self.arrBoostPlan = response.boostPlans ?? []
                completion(status, response)
            } else {
                self.arrBoostPlan = []
                completion(false, BoostedInfoModel(productID: "", planID: "", productName: "", brandName: "", discountedPrice: "", originalPrice: "", productImage: "", totalReachCount: "", remainingBoostDays: "", graphInfo: [], boostPlans: []))
            }
            
        }
    }
    
    // --------------------------------------------
    
    func numberOfBoostplan() -> Int {
        self.arrBoostPlan.count
    }
    
    // --------------------------------------------
    
    func setBoostplanData(row: Int) -> BoostPlan {
        self.arrBoostPlan[row]
    }
    
    // --------------------------------------------
    
    func boostItem(storeId : String, productId: String, boostID : String, amount: String, completion: @escaping((_ status :Bool, _ data: [PaymentModel]?) -> Void)) {
        self.repo.boostItemAPI(storeId: storeId, productId: productId, boostID: boostID, amount: amount) { status, data,error  in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? ""))
            }
            completion(status, data)
        }
    }
    
    // --------------------------------------------
    
}

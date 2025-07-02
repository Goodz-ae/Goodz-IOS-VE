//
//  MyAdsVM.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
class MyAdsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrMyAddItems : [MyAdsModel] = []
    var arrBoostPlan : [BoostPlan] = []
    var fail: BindFail?
    var repo = MyAdsRepo()
    var totalRecoerd : Int = 0
    var boostStoreInfoModal : BoostStoreInfoModal?
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func fetchBoostItem(page: Int,completion: @escaping((Bool) -> Void)) {
        self.repo.boostItemAPI(page: page) { status, data, error, totalRecords in
            if status {
                self.totalRecoerd = totalRecords
                let model = data ?? []
                if page == 1 {
                    self.arrMyAddItems = model
                } else {
                    self.arrMyAddItems.append(contentsOf: model)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    // --------------------------------------------
    
    func numberOfMyAddItems() -> Int {
        self.arrMyAddItems.count
    }
    
    // --------------------------------------------
    
    func setMyAddItemsData(row: Int) -> MyAdsModel {
        self.arrMyAddItems[row]
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
    
    func boostStoreInfoAPI(storeId: String,completion: @escaping((Bool, BoostStoreInfoModal) -> Void)) {
        self.repo.boostStoreInfoAPI(storeId: storeId) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            
            self.boostStoreInfoModal = data?.first
            
            if let response = data?.first, let plan = response.boostPlans {
                self.arrBoostPlan = plan
                completion(status, response)
            } else {
                self.arrBoostPlan = []
                completion(false, BoostStoreInfoModal(storeName: "", storeRate: "", followers: "", storeImage: "", storeItem: "", boostPlans: []))
            }
        }
    }
    
    func boostedStoreInfoAPI(storeId: String,completion: @escaping((Bool, BoostedStoreInfoModal) -> Void)) {
        self.repo.boostedStoreInfoAPI(storeId: storeId) { status, data, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            if let response = data?.first, let plan = response.boostPlans {
                self.arrBoostPlan = plan
                completion(status, response)
            } else {
                self.arrBoostPlan = []
                completion(false, BoostedStoreInfoModal(storeName: "", storeRate: "", followers: "", storeImage: "", planID: "", daysRemaining: "", totalReachCount: "", graphInfo: [], boostPlans: []) )
            }
        }
    }
    
    func boostItem(storeId : String, productId: String, boostID : String, amount: String, completion: @escaping((_ status :Bool, _ data: [PaymentModel]?) -> Void)) {
        self.repo.boostItemAPI(storeId: storeId, productId: productId, boostID: boostID, amount: amount) { status, data, error  in
            if !status {
                notifier.showToast(message: appLANG.retrive(label: error ?? ""))
            }
            completion(status, data)
        }
    }
}

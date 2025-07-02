//
//  StoreVM.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import Foundation
import UIKit

class StoreVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrFollower : [StoreFollowerModel] = []
    var arrReview : [StoreReviewModel] = []
    var fail: BindFail?
    var repo = MyStoreRepo()
    var arrStoreDetails : [StoreDetailsModel] = [StoreDetailsModel]()
    var arrMyStoreDetails : [MyStoreModel] = [MyStoreModel]()
    var arrProductList : [ProductListModel] = [ProductListModel]()
    var totalRecordsOfProductList = Int()
    var totalRecordsOfReviews = Int()
    var totalRecordsOfFollower = Int()

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------

    func fetchData(pageNo : Int, storeId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.storeDetailsAPI(pageNo: pageNo, storeId: storeId) { status, data, error, totalRecords  in
            if status, let details = data {
                self.totalRecordsOfProductList = totalRecords
                self.arrStoreDetails = details
                if pageNo == 1 {
                    self.arrProductList = data?.first?.productList ?? []
                    
                } else {
                    self.arrProductList.append(contentsOf: data?.first?.productList ?? [])
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    //TODO: letter
    func myStoreDetailsData(pageNo : Int, storeId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.myStoreDetailsAPI(pageNo: pageNo, storeId: storeId) { status, data, error, totalRecords  in
            if status, let details = data {
                self.totalRecordsOfProductList = totalRecords
                self.arrMyStoreDetails = details
                if pageNo == 1 {
                    self.arrProductList = data?.first?.productList ?? []
                    
                } else {
                    self.arrProductList.append(contentsOf: data?.first?.productList ?? [])
                }
               
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func fetchMakeAnOfferAPI(offerType : String, productId : String, bundleId: String, amount: String, storeId: String ,_ completion: @escaping((_ status: Bool, _ chatId : String, _ error: String) -> Void)) {
        self.repo.makeAnOfferAPI(offerType: offerType, productId: productId, bundleId: bundleId, amount: amount, storeId: storeId) { status, data, error in
            if let errorMsg = error {
                notifier.showToast(message: appLANG.retrive(label: errorMsg))
            }
            if !status {
                completion(status, "", error ?? "")
            } else {
                if let chatId = data?.first?.chatId {
                    completion(status, chatId, "")
                }
            }
        }
    }
    
    // --------------------------------------------

    func fetchReviewsData(sortId: String,pageNo : Int, storeId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.storeReviewsAPI(sortId: sortId, pageNo: pageNo, storeId: storeId) { status, data, error, totalRecords  in
            if status, let reviewList = data {
                self.totalRecordsOfReviews = totalRecords
                if pageNo == 1 {
                    self.arrReview = reviewList
                } else {
                    self.arrReview.append(contentsOf: reviewList)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func fetchFollowersData(search : String,pageNo : Int, storeId : String, completion: @escaping((Bool) -> Void)) {
        self.repo.storeFollowerAPI(search: search, pageNo: pageNo, storeId: storeId) { status, data, error, totalRecords in
            if status, let followerList = data {
                self.totalRecordsOfFollower = totalRecords
                if pageNo == 1 {
                    self.arrFollower = followerList
                } else {
                    self.arrFollower.append(contentsOf: followerList)
                }
                completion(true)
                return
            } else {
                self.arrFollower = []
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func followUnfollow(storeId: String, isFollow : String,completion: @escaping((Bool) -> Void)) {
        self.repo.storeFollowUnFollowAPI(storeId: storeId, isFollow: isFollow) { status, error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func numberOfProducts() -> Int {
        return self.arrProductList.count
    }
    
    // --------------------------------------------
    
    func setProductsData(row: Int) -> ProductListModel {
        return (self.arrProductList[row]) 
    }
    
    // --------------------------------------------
    
    func numberOfFollower() -> Int {
        self.arrFollower.count
    }
    
    // --------------------------------------------
    
    func setFollowerData(row: Int) -> StoreFollowerModel {
        self.arrFollower[row]
    }
    
    // --------------------------------------------
    
    func numberOfReviews() -> Int {
        self.arrReview.count
    }
    
    // --------------------------------------------
    
    func setReviewsData(row: Int) -> StoreReviewModel {
        self.arrReview[row]
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
          completion(status)
        }
    }
    
    // --------------------------------------------
    
    func fetchPinUnpinItemAPI(storeId: String, productId : String, isPinUnpin : String, completion: @escaping((Bool) -> Void)) {
        self.repo.pinUnpinItemAPI(storeId: storeId, productId: productId, isPinUnpin: isPinUnpin) { status, error in
            completion(status)
        }
    }
    
}

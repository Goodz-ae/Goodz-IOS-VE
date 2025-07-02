//
//  BundleProductListVM.swift
//  Goodz
//
//  Created by Akruti on 18/01/24.
//

import Foundation
class BundleProductListVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = BundleProductRepo()
    var totalRecords = Int()
    var arrBundleProducts : [BundleProductModel] = [BundleProductModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo: Int, storeId : String, completion: @escaping((Bool) -> Void)) {
        repo.bundleProductListAPI(pageNo: pageNo, storeId: storeId) { status, data, error, totalRecords  in
            if status, let productList = data {
                
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrBundleProducts = productList
                } else {
                    self.arrBundleProducts.append(contentsOf: productList)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrBundleProducts.count
    }
    
    // --------------------------------------------
    
    func setCollectionCategories(row: Int) -> BundleProductModel {
        self.arrBundleProducts[row]
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
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav, error in
            completion(status)
        }
    }
    
}

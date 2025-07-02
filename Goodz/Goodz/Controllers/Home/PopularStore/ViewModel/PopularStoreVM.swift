//
//  PopularStoreVM.swift
//  Goodz
//
//  Created by Akruti on 09/01/24.
//

import Foundation
class PopularStoreVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = MyStoreRepo()
    var arrPopularStore : [StoreModel] = [StoreModel]()
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo : Int, search : String, isPopular : String, completion: @escaping((Bool) -> Void)) {
        self.repo.storeListAPI(pageNo: pageNo, search: search, isPopular: isPopular) { status, data, error, totalRecords  in
            if status, let storeList = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrPopularStore = storeList
                } else {
                    self.arrPopularStore.append(contentsOf: storeList)
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
        self.arrPopularStore.count
    }
    
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> StoreModel {
        self.arrPopularStore[row]
    }
    
    // --------------------------------------------
    
}

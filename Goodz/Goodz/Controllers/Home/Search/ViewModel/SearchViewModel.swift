//
//  SearchViewModel.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class SearchVM {
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var searchData : SearchDataModel = SearchDataModel()
    var totalRecords = Int()
    var arrStore : [StoreModel] = [StoreModel]()
    var totalStore = Int()
    var repoStore = MyStoreRepo()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: CategoryRepo = CategoryRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo: Int,completion: @escaping((Bool) -> Void)) {
        repo.categoryMainAPI(showLoader : false, pageNo) { status, data, error, totalRecords in
            
            if status, let mainCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.searchData.categoryList = mainCat
                } else {
                    self.searchData.categoryList?.append(contentsOf: mainCat)
                }
                
                self.searchData.recentData = UserDefaults.recentSearch.reversed()
                self.searchData.goodDeals = [Labels.goodzDeals]
                self.searchData.section = 3
                
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfSection() -> Int {
        self.searchData.section ?? 2
    }
    
    // --------------------------------------------
    
    func numberOfRecentSearch() -> Int {
        self.searchData.recentData?.count ?? 0
    }
    
    // --------------------------------------------
    
    func numberOfCategoryMain() -> Int {
        self.searchData.categoryList?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setDataOfRecentSearch(row: Int) -> String {
        self.searchData.recentData?[row] ?? ""
    }
    
    // --------------------------------------------
    
    func getCategories(row: Int) -> CategoryMainModel {
        self.searchData.categoryList?[row] ?? CategoryMainModel(categoriesMainTitle: "", categoriesMainId: "", categoriesMainImage: "", isCustomizationSelected: "")
    }
    
    // --------------------------------------------
    
    func removeRecentSearch(row: Int) {
        self.searchData.recentData?.remove(at: row)
    }
    
    // --------------------------------------------
    
    func fetchStoreList(pageNo : Int, search : String, isPopular : String, completion: @escaping((Bool) -> Void)) {
        self.repoStore.storeListAPI(pageNo: pageNo, search: search, isPopular: isPopular) { status, data, error, totalRecords  in
            if status, let storeList = data {
                self.totalStore = totalRecords
                if pageNo == 1 {
                    self.arrStore = storeList
                } else {
                    self.arrStore.append(contentsOf: storeList)
                }
                completion(true)
                return
            } else {
                if pageNo == 1 {
                    self.arrStore = []
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfStore() -> Int {
        self.arrStore.count
    }
    
    // --------------------------------------------
    
    func setStore(row: Int) -> StoreModel {
        self.arrStore[row]
    }
    
    // --------------------------------------------
    
}

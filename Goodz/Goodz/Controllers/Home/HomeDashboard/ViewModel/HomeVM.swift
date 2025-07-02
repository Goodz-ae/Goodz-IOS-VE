//
//  HomeVM.swift
//  Goodz
//
//  Created by Akruti on 24/01/24.
//

import Foundation
class HomeVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = HomeRepo()
    var repoStore = MyStoreRepo()
    var arrHome : [HomeModel] = [HomeModel]()
    var totalRecords = Int()
    var categoryRepo = CategoryRepo()
    var arrCategoryData : [CategoryMainModel] = []
    var totalCategories = Int()
    var totalStore = Int()
    var arrStore = [StoreList]()
    var customSelectionArr = [ProductList]()
    var ourSelectionArr = [ProductList]()
    var latestArrivalsProductsArr = [ProductList]()
    
    var latestArrivalLoadCount = 5
    
    var goodzDealProductsArr = [ProductList]() //For Dummy Data
    
    var popularProductsArr = [newHomeProductsStr]() //For Dummy Data
     
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchHomeData(pageNo: Int, completion: @escaping((Bool) -> Void)) {
        repo.homeAPI(pageNo: pageNo) { status, data, error, totalRecords in
            if status, let homeData = data {
                self.totalRecords = totalRecords
                self.totalStore = Int(homeData.first?.totalPopularStoreRecord ?? "0") ?? 0
                if pageNo == 1 {
                    self.arrHome = homeData
                    
                    self.intilizeData()
                    
                }
                completion(true)
            } else {
                self.arrStore = []
                completion(false)
            }
        }
    }
    
    private func intilizeData(){
         
        
        
        
        
        if (self.arrHome.first?.result?.count ?? 0) > 0 {
            self.goodzDealProductsArr = self.arrHome.first?.result?[0].productList ?? []
        }
        
        if (self.arrHome.first?.result?.count ?? 0) > 1 {
            self.customSelectionArr = self.arrHome.first?.result?[1].productList ?? []
        }
        
        if (self.arrHome.first?.result?.count ?? 0) > 2 {
            self.ourSelectionArr = self.arrHome.first?.result?[2].productList ?? []
        }
        
        if (self.arrHome.first?.result?.count ?? 0) > 4 {
            self.arrStore = self.arrHome.first?.result?[4].storeList ?? []
        }
        
        
        if (self.arrHome.first?.result?.count ?? 0) > 5 {
            self.latestArrivalsProductsArr = self.arrHome.first?.result?[5].latest_arrivals ?? []
        }
        
        
        
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        (self.arrHome.first?.result?.count) ?? 0
    }
    
    // --------------------------------------------
    
    func setHomeData(row: Int) -> HomeData {
        
        guard let data = arrHome.first, let res = data.result, row < numberOfRows() - 1 else {
            return HomeData(type: "", title: "", redirectType: "", categoryID: "", subcategoryID: "", subSubcategoryID: "", productList: [], latest_arrivals: [],
                            productID: "", bannerImgurl: "", totalSavedWoodKg: "", redirectionURL: "", redirectionID: "", storeList: [])
        }
        
        return res[row]
    }
    
    // --------------------------------------------
    
    func numberOfStore() -> Int {
        return self.arrStore.count// self.arrHome.first?.result?.last?.storeList?.count ?? 0
    }
    
    // --------------------------------------------
    
    func setStoreData(row: Int) -> StoreList {
        return self.arrStore[row]
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func followUnfollow(storeId: String, isFollow : String, completion: @escaping((Bool) -> Void)) {
        self.repoStore.storeFollowUnFollowAPI(storeId: storeId, isFollow: isFollow) { status, error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    // MARK: - set categories
    // --------------------------------------------
    
    func fetchCategoryData(pageNo : Int, completion: @escaping((Bool) -> Void)) {
        
        self.categoryRepo.categoryMainAPI(pageNo) { status, data, error, totalRecords  in
            if status, let cat = data {
                if pageNo == 1 {
                    self.arrCategoryData = [CategoryMainModel(categoriesMainTitle : "All", categoriesMainId : "", categoriesMainImage : "", isCustomizationSelected: "")]
                }
                self.arrCategoryData.append(contentsOf: cat)
                self.totalCategories = totalRecords
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfCategories() -> Int {
        self.arrCategoryData.count
    }
    
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> CategoryMainModel {
        self.arrCategoryData[row]
    }
    
    // --------------------------------------------
    
}

struct newHomeProductsStr : Hashable {
    var title : String?
    var imgStr : String?
    var violationCheck : Bool?
    var tag : String?
    static func == (lhs: newHomeProductsStr, rhs: newHomeProductsStr) -> Bool {
        return lhs.title == rhs.title
    }
}

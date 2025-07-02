//
//  DashboardVM.swift
//  Goodz
//
//  Created by Akruti on 20/12/23.
//

import Foundation
class DashboardVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    var repo = DashboardRepo()
    var arrInvoice : [MyInvoiceModel] = []
    var arrStore : [DashboardSortModel] = []
    var salesByCategory: SalesByCategoryeModel?
    var arrSalesCategory : [SalesGraphModel] = []
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func fetchMyInvoices(sortId: String, pageNo : Int, isShowLoader: Bool, completion: @escaping((Bool) -> Void)) {
        self.repo.myInvoicesAPI(sortId: sortId, pageNo: pageNo, isShowLoader: isShowLoader, { status, data, error, totalRecords  in
            if status , let myInvoicesData = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrInvoice = myInvoicesData
                } else {
                    self.arrInvoice.append(contentsOf: myInvoicesData)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        })
    }
    
    func fetchMyFiguresStore(sortSalesByCategory: String, completion: @escaping((Bool) -> Void)) {
        self.repo.myFiguresStoreAPI(sortSalesByCategory: sortSalesByCategory) { status, data, error in
            if status , let myfigureStoreData = data?.first {
                self.arrStore = [DashboardSortModel(title: Labels.totalFollowers, amount: (myfigureStoreData.totalFollowers ?? "0")),
                                 DashboardSortModel(title: Labels.totalReviews, amount: (myfigureStoreData.totalReview ?? "0")),
                                 DashboardSortModel(title: Labels.productViews, amount: (myfigureStoreData.totalViews ?? "0")),
                                 DashboardSortModel(title: Labels.productLikes, amount: (myfigureStoreData.totalLikes ?? "0"))]
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func fetchTotalSales(sortTotalSales: String, completion: @escaping((Bool, TotalSalesModel?) -> Void)) {
        self.repo.totalSaleAPI(sortTotalSales: sortTotalSales) { status, data, error in
            if status , let totalSalesData = data?.first {
                completion(true, totalSalesData)
                return
            } else {
                completion(false, nil)
            }
        }
    }

    func fetchStoreViews(sortStoreViews: String, completion: @escaping((Bool, StoreViewsModel?) -> Void)) {
        self.repo.storeViewsAPI(sortStoreViews: sortStoreViews) { status, data, error in
            if status , let storeViewsData = data?.first {
                completion(true, storeViewsData)
                return
            } else {
                completion(false, nil)
            }
        }
    }
    
    func fetchSalesByCategory(sortSalesByCategory: String, completion: @escaping((Bool) -> Void)) {
        self.repo.salesByCategoryeAPI(sortSalesByCategory: sortSalesByCategory) { status, data, error in
            if status , let myfigureStoreData = data?.first {
                self.salesByCategory = myfigureStoreData
                self.setData()
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func setData() {
        if let salesByCategory = salesByCategory?.salesByCategory {
            self.arrSalesCategory = salesByCategory
        }
        
    }
    
    // --------------------------------------------
    
    func numberOfMyAddItems() -> Int {
        self.arrInvoice.count
    }
    
    // --------------------------------------------
    
    func setMyAddItemsData(row: Int) -> MyInvoiceModel {
        self.arrInvoice[row]
    }
    
    // --------------------------------------------
    
    func numberOfSalesCategory() -> Int {
        self.arrSalesCategory.count
    }
    
    // --------------------------------------------
    
    func setSalesCategoryData(row: Int) -> SalesGraphModel {
        self.arrSalesCategory[row]
    }
    
    // --------------------------------------------
    
    func numberOfStore() -> Int {
        self.arrStore.count
    }
    
    // --------------------------------------------
    
    func setStoreData(row: Int) -> DashboardSortModel {
        self.arrStore[row]
    }
    
    // --------------------------------------------
    
    // --------------------------------------------
}

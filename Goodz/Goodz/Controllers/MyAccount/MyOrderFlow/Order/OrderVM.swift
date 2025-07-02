//
//  OrderVM.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
class OrderVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = OrderRepo()
    var arrOrderList = [OrderListResult]()
    var arrSellList = [SellListResult]()
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: OrderRepo = OrderRepo(), arrOrderList: [OrderListResult] = [], arrSellList: [SellListResult] = []) {
        self.fail = fail
        self.repo = repo
        self.arrOrderList = arrOrderList
        self.arrSellList = arrSellList
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchOrderList(pageNo : Int, sortID: String, completion: @escaping((Bool) -> Void)) {
        self.repo.orderListAPI(pageNo, sortID) { status, data, error, totalRecords in
        
            if status {
                self.totalRecords = totalRecords
                
                let model = data ?? []
                
                if pageNo == 1 {
                    self.arrOrderList = model
                } else {
                    self.arrOrderList.append(contentsOf: model)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func fetchSellList(pageNo : Int, sortID: String, completion: @escaping((Bool) -> Void)) {
        self.repo.sellListAPI(pageNo, sortID) { status, data, error, totalRecords in
        
            if status {
                self.totalRecords = totalRecords
                
                let model = data ?? []
                
                if pageNo == 1 {
                    self.arrSellList = model
                } else {
                    self.arrSellList.append(contentsOf: model)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfMyOrder() -> Int {
        self.arrOrderList.count
    }
    
    // --------------------------------------------
    
    func setMyOrderData(row: Int) -> OrderListResult {
        self.arrOrderList[row]
    }
    
    // --------------------------------------------
    
    func numberOfMySales() -> Int {
        self.arrSellList.count
    }
    
    // --------------------------------------------
    
    func setMySalesData(row: Int) -> SellListResult {
        self.arrSellList[row]
    }
    
    // --------------------------------------------
    
    func findMyOrderData(orderID: String) -> OrderListResult? {
        if let index = self.arrOrderList.firstIndex(where: {$0.orderID == orderID}) {
            return self.arrOrderList[index]
        }else{
            return nil
        }
    }
    
    // --------------------------------------------
    
    func findMySalesData(orderID: String) -> SellListResult? {
        if let index = self.arrSellList.firstIndex(where: {$0.sellID == orderID}) {
            return self.arrSellList[index]
        }else{
            return nil
        }
    }
}

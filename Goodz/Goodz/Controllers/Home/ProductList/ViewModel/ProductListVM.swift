//
//  ProductVM.swift
//  Goodz
//
//  Created by Akruti on 08/01/24.
//

import Foundation
class ProductListVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ProductRepo()
    var arrProducts : [ProductModel] = [ProductModel]()
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrProducts.count
    }
    
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> ProductModel {
        self.arrProducts[row]
    }
    
    // --------------------------------------------
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            completion(status)
        }
    }
    
    func fetchFilter(pageNo: Int, data: ProductListParameter?, completion: @escaping((Bool) -> Void)) {
        self.repo.productListAPI(page: pageNo, data: data ?? kProductListParameter) { status, data, error, totalRecords in
            self.totalRecords = totalRecords
            if status, let productList = data {
                if pageNo == 1 {
                    self.arrProducts = productList
                } else {
                    self.arrProducts.append(contentsOf: productList)
                }
                completion(true)
            } else {
                if pageNo == 1 {
                    self.arrProducts = []
                }
                completion(false)
            }
        }
    }
    
}

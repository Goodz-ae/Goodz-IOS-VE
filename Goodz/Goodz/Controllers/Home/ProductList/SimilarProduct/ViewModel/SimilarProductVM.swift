//
//  SimilarProductVM.swift
//  Goodz
//
//  Created by Akruti on 10/04/24.
//

import Foundation
class SimilarProductVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ProductDetailRepo()
    var arrSimilarProduct :[SimilarProductModel] = []
    var totalRecords : Int = 0
    
    // --------------------------------------------
    // MARK: - Similar Products API
    // --------------------------------------------
    
    func fetchSimilarProducts(page: Int,productId : String, categoryId: String, completion: @escaping((Bool, Int) -> Void)) {
        self.repo.similarProductListAPI(page: page,productId : productId,categoryId: categoryId) { status, data, error,totalRecords  in
            if status, let products = data {
                self.totalRecords = totalRecords ?? 0
                if page == 1 {
                    self.arrSimilarProduct = products
                } else {
                    self.arrSimilarProduct.append(contentsOf: products)
                }
                completion(true, totalRecords ?? 0)
            } else {
                self.arrSimilarProduct = []
                completion(false, 0)
                
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfSimiliarProducts() -> Int {
        self.arrSimilarProduct.count
    }
    
    // --------------------------------------------
    
    func setSimilarProducts(row: Int) -> SimilarProductModel {
        self.arrSimilarProduct[row]
    }
    
    func addRemoveFavourite(isFav: String, productId : String, completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.addFavRemoveFavAPI(isFav, productId) { status, fromFav,error in
            completion(status)
        }
    }
    
}

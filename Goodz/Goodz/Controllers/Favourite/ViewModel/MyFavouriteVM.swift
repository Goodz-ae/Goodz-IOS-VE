//
//  MyFavouriteVM.swift
//  Goodz
//
//  Created by Akruti on 04/01/24.
//

import Foundation
class MyFavouriteVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    private var fail: BindFail?
    private var repo = MyFavouriteRepo()
    private var arrMyFavouriteProduct : [MyFavouriteModel] = [MyFavouriteModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func addFavRemoveFavAPI(isFav : String, productID : String, completion: @escaping((Bool) -> Void)) {
        repo.addFavRemoveFavAPI(isFav, productID) { status, error in
            if status {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func fetchMyFavouriteProductList(completion: @escaping((Bool) -> Void)) {
        self.repo.myFavouriteProductListAPI { status, data, error in
            self.arrMyFavouriteProduct.removeAll()
            if status, let productList = data {
                self.arrMyFavouriteProduct = productList
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func removeAll(completion: @escaping((Bool) -> Void)) {
        self.repo.removeALLFavouriteAPI { status, error in
            if status {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfProduct() -> Int {
        self.arrMyFavouriteProduct.count
    }
    
    // --------------------------------------------
    
    func setProduct(row : Int) -> MyFavouriteModel {
        self.arrMyFavouriteProduct[row]
    }
    
    // --------------------------------------------
    
}

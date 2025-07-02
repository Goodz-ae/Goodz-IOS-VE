//
//  BrandVM.swift
//  Goodz
//
//  Created by Akruti on 10/01/24.
//

import Foundation

class BrandVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = SellRepo()
    var customizationRepo = CustomizationRepo()
    var totalRecords = Int()
    var arrBrand : [BrandModel] = [BrandModel]()
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo: Int, serach : String,isShowLoader: Bool = true , completion: @escaping((Bool) -> Void)) {
        self.repo.getBrandsAPI(pageNo: pageNo, search: serach, isShowLoader: isShowLoader) { status, data, error, totalRecords, iconUrl  in
            if status, let  brandList = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrBrand = brandList
                } else {
                    self.arrBrand.append(contentsOf: brandList)
                }
                
                completion(true)
                return
            } else {
                self.arrBrand.removeAll()
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrBrand.count
    }
    
    // --------------------------------------------
    
    func setBrands(row: Int) -> BrandModel {
        self.arrBrand[row]
    }
    
    // --------------------------------------------
}

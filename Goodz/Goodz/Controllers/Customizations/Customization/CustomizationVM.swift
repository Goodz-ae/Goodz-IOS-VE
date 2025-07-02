//
//  CustomizationVM.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import Foundation
import UIKit

class CustomizationVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var sellRepo = SellRepo()
    var customizationRepo = CustomizationRepo()
    var arrMainCategory : [CategoryMainModel] = [CategoryMainModel]()
    var totalRecords = Int()
    var brandUrl = ""

    var dispatchGroup = DispatchGroup()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo : Int, completion: @escaping((Bool) -> Void)) {
        self.repo.categoryMainAPI(pageNo) { status, data, error, totalRecords  in
            if status, let mainCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrMainCategory = mainCat
                } else {
                    self.arrMainCategory.append(contentsOf: mainCat)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func fetchCustomizationData(completion: @escaping((Bool) -> Void)) {
        self.customizationRepo.getCustomizationAPI() { status, data, error  in
            if status, let mainCat = data {
                appDelegate.arrCustomization = data ?? []
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    func fetchBrandsData(completion: @escaping((Bool) -> Void)) {
        self.sellRepo.getBrandsAPI(pageNo: 1, search: "") { status, data, error, totalRecords, iconUrl  in
            self.brandUrl = iconUrl ?? ""
            completion(true)
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrMainCategory.count + 1
    }
     
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> CategoryMainModel {
        self.arrMainCategory[row]
    }
    
    // --------------------------------------------
    
}

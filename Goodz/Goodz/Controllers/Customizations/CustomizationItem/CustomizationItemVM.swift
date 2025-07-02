//
//  CustomizationItemVM.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import Foundation
class CustomizationItemVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var arrSubCategory : [CategorySubModel] = []
    var totalRecords = Int()

    var customizationRepo = CustomizationRepo()
    var arrCustomization : [CustomizationModels] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo : Int, id : String, completion: @escaping((Bool) -> Void)) {
        self.repo.categorySubAPI(pageNo, categoriesMainId: id) { status, data, error, totalRecords  in
            if status, let mainCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrSubCategory = mainCat
                } else {
                    self.arrSubCategory.append(contentsOf: mainCat)
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
        self.arrSubCategory.count
    }
     
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> CategorySubModel {
        self.arrSubCategory[row]
    }
    
    // --------------------------------------------
    
    func fetchGetCustomization(mainId : String, completion: @escaping((Bool) -> Void)) {
//        self.customizationRepo.getCustomizationAPI(mainId) { status, data, error in
//            if status, let selectedData = data {
//                self.arrCustomization = selectedData
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
    }
    
    // --------------------------------------------
    
    func saveCustomization(categoryMainId : String, arrSubId : String, arrCollectionId :String, completion: @escaping((Bool) -> Void)) {
//        self.customizationRepo.saveCustomizationAPI(categoryMainId: categoryMainId, arrSubId: arrSubId, arrCollectionId: arrCollectionId) { status, error in
//            if status {
//                completion(true)
//            } else {
//                notifier.showToast(message: appLANG.retrive(label: error ?? ""))
//                completion(false)
//            }
//        }
    }
    
}

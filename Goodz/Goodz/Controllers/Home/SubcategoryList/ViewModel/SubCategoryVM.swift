//
//  SubCategoryVM.swift
//  Goodz
//
//  Created by Akruti on 03/01/24.
//

import Foundation

class SubCategoryVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var arrSubCategory : [CategorySubModel] = [CategorySubModel]()
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: CategoryRepo = CategoryRepo(), arrSubCategory: [CategorySubModel]) {
        self.fail = fail
        self.repo = repo
        self.arrSubCategory = arrSubCategory
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo : Int, id : String, searchText : String, completion: @escaping((Bool) -> Void)) {
        self.repo.categorySubAPI(pageNo, categoriesMainId: id, searchText: searchText) { status, data, error, totalRecords  in
            if status, let subCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrSubCategory = subCat
                } else {
                    self.arrSubCategory.append(contentsOf: subCat)
                }
                completion(true)
                return
            } else {
                self.arrSubCategory.removeAll()
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
    
}

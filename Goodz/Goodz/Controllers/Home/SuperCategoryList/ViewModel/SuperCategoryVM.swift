//
//  SuperCategoryVM.swift
//  Goodz
//
//  Created by Akruti on 08/01/24.
//

import Foundation

class SuperCategoryVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var arrMainCategory : [CategoryMainModel] = [CategoryMainModel]()
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: CategoryRepo = CategoryRepo(), arrMainCategory: [CategoryMainModel], totalRecords: Int = Int()) {
        self.fail = fail
        self.repo = repo
        self.arrMainCategory = arrMainCategory
        self.totalRecords = totalRecords
    }
    
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
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrMainCategory.count
    }
    
    // --------------------------------------------
    
    func setSubCategories(row: Int) -> CategoryMainModel {
        self.arrMainCategory[row]
    }
    
    // --------------------------------------------
    
}

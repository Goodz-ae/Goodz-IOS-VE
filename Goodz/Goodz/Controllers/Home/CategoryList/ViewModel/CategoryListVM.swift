//
//  CategoryListVM.swift
//  Goodz
//
//  Created by Akruti on 03/01/24.
//

import Foundation
class CategoryListVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = CategoryRepo()
    var customizationRepo = CustomizationRepo()
    var totalRecords = Int()
    var arrSubCollectionCategory : [CategoryCollectionModel] = [CategoryCollectionModel]()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: CategoryRepo = CategoryRepo(), arrSubCollectionCategory: [CategoryCollectionModel]) {
        self.fail = fail
        self.repo = repo
        self.arrSubCollectionCategory = arrSubCollectionCategory
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo: Int, id : String, completion: @escaping((Bool) -> Void)) {
        repo.categoryCollectionAPI(pageNo, categoriesSubId: id) { status, data, error, totalRecords  in
            if status, let subCat = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrSubCollectionCategory = subCat
                } else {
                    self.arrSubCollectionCategory.append(contentsOf: subCat)
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
        self.arrSubCollectionCategory.count
    }
    
    // --------------------------------------------
    
    func setCollectionCategories(row: Int) -> CategoryCollectionModel {
        self.arrSubCollectionCategory[row]
    }
    
    // --------------------------------------------
    
}

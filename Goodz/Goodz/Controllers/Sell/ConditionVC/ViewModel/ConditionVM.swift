//
//  ConditionVM.swift
//  Goodz
//
//  Created by Akruti on 10/01/24.
//

import Foundation
class ConditionVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = SellRepo()
    
    var arrConditions : [ConditionModel] = [ConditionModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchConditionsData(completion: @escaping((Bool) -> Void)) {
        self.repo.getConditionsAPI { status, data, error in
            if status, let conditions = data {
                self.arrConditions = conditions
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrConditions.count
    }
    
    // --------------------------------------------
    
    func setCondition(row: Int) -> ConditionModel {
        self.arrConditions[row]
    }
    
    // --------------------------------------------
}

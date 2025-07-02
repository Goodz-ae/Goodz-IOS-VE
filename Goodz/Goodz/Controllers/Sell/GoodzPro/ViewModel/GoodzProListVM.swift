//
//  GoodzProListVM.swift
//  Goodz
//
//  Created by Akruti on 18/03/24.
//

import Foundation

class GoodzProListVM {
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = GoodzProListRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(completion: @escaping((Bool) -> Void)) {
        self.repo.subscribeProSellerAPI { Status, data, error in
            completion(Status)
            print(data)
            if let error = error {
                notifier.showToast(message: appLANG.retrive(label: error))
            }
        }
    }
    
}

//
//  ConnectionsVM.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
class ConnectionsVM {
    // --------------------------------------------
    // MARK: - Custom variables -
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = ConnectionsRepo()
    
    init(fail: BindFail? = nil, repo: ConnectionsRepo = ConnectionsRepo()) {
        self.fail = fail
        self.repo = repo
    }
    // --------------------------------------------
    // MARK: - Custom Variables
    // --------------------------------------------
    
    var arrConnection : [ConnectionsModel] = []
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    func setData() {
        self.arrConnection = [ConnectionsModel]()
    }
    
    // --------------------------------------------
    
    func setNumberOfConnection() -> Int {
        self.arrConnection.count
    }
    
    // --------------------------------------------
    
    func setRowDataOfConnection(row: Int) -> ConnectionsModel {
        self.arrConnection[row]
    }
    
    func getConnectionList(completion: @escaping((Bool, String?) -> Void)) {
        repo.getConnectionsAPI { status, data, error in
            if status, let response = data?.first?.result {
                self.arrConnection = response
                completion(status, "")
            }else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(status, "")
            }
        }
    }
}

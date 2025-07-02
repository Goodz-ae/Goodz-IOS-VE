//
//  NotificationVM.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

class NotificationVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = NotificationRepo()
    var arrNotification : [NotificationListResult] = []
    var totalRecords = Int()
    
    // --------------------------------------------
    // MARK: - Init methods
    // --------------------------------------------
    
    init(fail: BindFail? = nil, repo: NotificationRepo = NotificationRepo(), arrNotification: [NotificationListResult] = []) {
        self.fail = fail
        self.repo = repo
        self.arrNotification = arrNotification
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func numberOfRows() -> Int {
        self.arrNotification.count
    }
    
    // --------------------------------------------
    
    func setRowData(row: Int) -> NotificationListResult {
        self.arrNotification[row]
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchNotificationList(pageNo : Int, completion: @escaping((Bool) -> Void)) {
        self.repo.notificationListAPI(pageNo: pageNo) { status, data, error, totalRecords in
        
            if status {
                self.totalRecords = totalRecords
                
                let model = data ?? []
                
                if pageNo == 1 {
                    self.arrNotification = model
                } else {
                    self.arrNotification.append(contentsOf: model)
                }
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
}

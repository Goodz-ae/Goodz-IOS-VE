//
//  NotificationListVM.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import Foundation
//class NotificationListModel {
//    var title : String
//    var isActive : Bool
//    internal init(title: String, isActive: Bool) {
//        self.title = title
//        self.isActive = isActive
//    }
//}

class NotificationListVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrNotification : [NotificationListModel] = []
    var fail: BindFail?
    var repo = NotificationListRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func getNotificationStatusList(completion: @escaping((Bool) -> Void)) {
        self.repo.getNotificationStatusList { status, data, error in
            if status, let res = data {
                self.arrNotification = res
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    
    // --------------------------------------------
    
    func updateNotificationStatusAPI(notificationId: String, status: String, completion: @escaping((Bool) -> Void)) {
        self.repo.updateNotificationStatusAPI(notificationId: notificationId, status: status) { status, error in
            if !status {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func numberOfNotification() -> Int {
        return self.arrNotification.count
    }
    
    // --------------------------------------------
    
    func setRowNotification(row: Int) -> NotificationListModel {
        return self.arrNotification[row]
    }
    
    // --------------------------------------------
    
}

//
//  NotificationListModel.swift
//  Goodz
//
//  Created by Akruti on 23/02/24.
//

import Foundation
struct NotificationListModel: Codable {
    let notificationID, title, status: String?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case title, status
    }
}

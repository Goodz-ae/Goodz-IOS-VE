//
//  NotificationModel.swift
//  Goodz
//
//  Created by vtadmin on 20/02/24.
//

import Foundation


//struct NotificationListResult: Codable {
//    let pushNotificationMessage, isRead, pushNotificationID, dateTime, notificationType, redirectionID : String?
//    
//    enum CodingKeys: String, CodingKey {
//        case pushNotificationMessage = "push_notification_message"
//        case isRead = "is_read"
//        case pushNotificationID = "push_notification_id"
//        case dateTime = "date_time"
//        case notificationType = "notification_type"
//        case redirectionID = "redirection_id"
//    }
//}
struct NotificationListResult : Codable {
    let pushNotificationMessage : String?
    let isRead : String?
    let pushNotificationID : String?
    let notificationType : String?
    let redirectionID : String?
    let dateTime : String?

    enum CodingKeys: String, CodingKey {

        case pushNotificationMessage = "push_notification_message"
        case isRead = "is_read"
        case pushNotificationID = "push_notification_id"
        case notificationType = "notification_type"
        case redirectionID = "redirection_id"
        case dateTime = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pushNotificationMessage = try values.decodeIfPresent(String.self, forKey: .pushNotificationMessage)
        isRead = try values.decodeIfPresent(String.self, forKey: .isRead)
        pushNotificationID = try values.decodeIfPresent(String.self, forKey: .pushNotificationID)
        notificationType = try values.decodeIfPresent(String.self, forKey: .notificationType)
        redirectionID = try values.decodeIfPresent(String.self, forKey: .redirectionID)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
    }

}

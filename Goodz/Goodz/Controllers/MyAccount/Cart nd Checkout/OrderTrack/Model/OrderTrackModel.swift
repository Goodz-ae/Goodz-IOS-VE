//
//  OrderTrackModel.swift
//  Goodz
//
//  Created by Akruti on 19/04/24.
//

import Foundation
struct OrderTrackDataModel: Codable {
    let orderID, deliveryDate: String
    let status: [OrderStatusModel]

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case deliveryDate = "delivery_date"
        case status
    }
}

// MARK: - Status
struct OrderStatusModel: Codable {
    let trackStatus, date, isActive: String

    enum CodingKeys: String, CodingKey {
        case trackStatus = "track_status"
        case date
        case isActive = "is_active"
    }
}

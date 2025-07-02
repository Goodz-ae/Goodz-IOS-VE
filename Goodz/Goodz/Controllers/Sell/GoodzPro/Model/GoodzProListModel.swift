//
//  GoodzProListModel.swift
//  Goodz
//
//  Created by Akruti on 18/03/24.
//

import Foundation
struct GoodzProListModel: Codable {
    let proRequestStatus, successURL, paymentURL, failURL: String
    let proPlanStartDate, proPlanEndDate: String

    enum CodingKeys: String, CodingKey {
        case proRequestStatus
        case successURL = "success_url"
        case paymentURL = "payment_url"
        case failURL = "fail_url"
        case proPlanStartDate = "pro_plan_start_date"
        case proPlanEndDate = "pro_plan_end_date"
    }
}

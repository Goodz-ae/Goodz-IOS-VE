//
//  NegotiationOfferModel.swift
//  Goodz
//
//  Created by on 10/04/25.
//

import Foundation
struct NegotiationOfferModel: Codable {
    let code, message: String?
    let negotiationStatus: Int?

    enum CodingKeys: String, CodingKey {
        case code, message
        case negotiationStatus = "negotiation_status"
    }
}


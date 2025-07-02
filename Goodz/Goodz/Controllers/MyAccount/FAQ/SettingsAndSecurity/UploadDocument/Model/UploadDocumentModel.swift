//
//  UploadDocumentModel.swift
//  Goodz
//
//  Created by Akruti on 08/02/24.
//

import Foundation
struct UploadDocumentModel: Codable {
    let frontSideDocURL, backSideDocURL, tradeLicense, companyLetterHead, bankLetter: String?
    let emiratesIdReceivedDate, emiratesIdValidatedDate, bankLetterReceivedDate, bankLetterValidatedDate, letterHeadReceivedDate, letterHeadValidatedDate, tradeLicenseReceivedDate, tradeLicenseValidatedDate: String?
    let bankAdded, bankLetterStatus, emiratesStatus, tradeLicenseStatus: Int?

    enum CodingKeys: String, CodingKey {
        case frontSideDocURL = "front_side_doc_url"
        case backSideDocURL = "back_side_doc_url"
        case companyLetterHead = "company_letter_head"
        case bankLetter = "bank_letter"
        case bankAdded = "bankAdded"
        case emiratesIdReceivedDate = "emirates_id_received_date"
        case emiratesIdValidatedDate = "emirates_id_validated_date"
        case letterHeadReceivedDate = "letter_head_received_date"
        case letterHeadValidatedDate = "letter_head_validated_date"
        case bankLetterReceivedDate = "bank_letter_received_date"
        case bankLetterValidatedDate = "bank_letter_validated_date"
        case tradeLicense = "trade_license"
        case tradeLicenseReceivedDate = "trade_license_received_date"
        case tradeLicenseValidatedDate = "trade_license_validated_date"
        case bankLetterStatus = "bank_letter_status"
        case emiratesStatus = "emirates_status"
        case tradeLicenseStatus = "trade_licence_status"
    }
}

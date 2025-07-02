//
//  FAQModel.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation

struct CMSModel: Codable {
    
    let cmsTitle, descriptions : String?
   
    enum CodingKeys: String, CodingKey {
        case cmsTitle = "cms_title"
        case descriptions = "descriptions"
    }
}

struct FAQModel: Codable {
    let faqTitle, id: String?
    let data: [SubFAQModel]?

    enum CodingKeys: String, CodingKey {
        case faqTitle = "faq_title"
        case id, data
    }
}

// MARK: - Datum
struct SubFAQModel: Codable {
    let id, title, descriptions: String?
}

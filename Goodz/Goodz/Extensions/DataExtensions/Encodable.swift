//
//  Encodable.swift
//  Goodz
//
//  Created by vtadmin on 23/02/24.
//

import Foundation

extension Encodable {
    var getJsonString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

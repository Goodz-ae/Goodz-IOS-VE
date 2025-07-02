//
//  Codable+Extension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import Foundation

extension Encodable {
    func encodeAsDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

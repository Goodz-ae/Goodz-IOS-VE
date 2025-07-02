//
//  Dictionary+Extension.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

extension Dictionary where Key == String, Value: Any {
    
    static func stringValueOf(_ dict: [String: Any], url: String) -> String {
        var temp = ""
        let sortedKeys = dict.sorted(by: { $0.key < $1.key })
        sortedKeys.forEach { (_, value) in
            if let dictionary = value as? [String: Any] {
                temp.append(stringValueOf(dictionary, url: url))
            } else if let boolValue = value as CFTypeRef?,
                     CFGetTypeID(boolValue) == CFBooleanGetTypeID() {
                temp.append("\(value as? Bool)")
            } else if let arrayValue = value as? [Any] {
                arrayValue.forEach { (item) in
                    if let dictionary = item as? [String: Any] {
                        temp.append(stringValueOf(dictionary, url: url))
                    } else if let boolValue = item as CFTypeRef?,
                             CFGetTypeID(boolValue) == CFBooleanGetTypeID() {
                        temp.append("\(item as? Bool)")
                    } else {
                        //                            temp.append("\(item)")
                    }
                }
            } else {
                temp.append("\(value)")
            }
        }
        return temp
    }
    
    var data: Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
    
    func getJsonString() -> String {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: json, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        } catch {
            return ""
        }
    }
}

//
//  Array.swift
//  Goodz
//
//  Created by vtadmin on 22/02/24.
//

import Foundation

extension Array {
    
    func getJsonString() -> String {

        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: json, encoding: .utf8) ?? ""
            
        } catch {
            return ""
        }
    }
}

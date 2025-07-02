//
//  GraphValueFormatter.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 22/02/24.
//

import Foundation
import Charts

public class GraphValueFormatter: NSObject, AxisValueFormatter {
    private var keys : [String] = []
        
    init(keys: [String]) {
        self.keys = keys
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        
        guard index >= 0, index < keys.count else {
            return ""
        }
        
        return keys[index]
    }
}

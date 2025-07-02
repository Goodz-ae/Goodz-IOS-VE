//
//  Multipart.swift
//  Goodz
//
//  Created by Priyanka Poojara on 06/11/23.
//

import Foundation
import UIKit

/// Struct to define mutlipart data to be sent to API
public struct MultiPartData {
    /// File name of upload file
    var fileName: String!
    /// Data in binary format
    var data: Data!
    /// Param for multipart
    var paramKey: String!
    /// Mime type for uplaod file
    var mimeType: String!
    /// File Key (API Key)
    var fileKey: String?
}

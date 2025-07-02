//
//  HTTPRequestProtocol.swift
//  Goodz
//
//  Created by Priyanka Poojara on 02/11/23.
//

import Foundation

protocol HTTPRequestProtocol {
    associatedtype GenericProperty
    var path: String { get}
    var httpBody: GenericProperty { get }
    var queryParams: [String: String]? { get }
}

public protocol NetworkProtocol {
    
    /// Make a HTTP Request and Get HTTP Response
    /// - parameter request : provide an enum case confroming to RouterProtocol
    /// - parameter responseModel : provide class or structure with model of type Codable
    /// - parameter completionHandler : This is a completion block of the request once the request is completed and response is recieved this block will be called.
    /// - Note : Completion Handler : This block will return a Result Type. This Result type will have two cases
    /// 1. success : This case will return the response decoded in model provided
    /// 2. failure : This case will return the Network Error containig error message describing the error
    static func dataRequest<T : Decodable>(with request: RouterProtocol,responseModel : T.Type, isGetIpAddress: Bool, completionHandler: @escaping (Swift.Result<(T?), NetworkError>) -> Void)
}

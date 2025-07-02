//
//  RouterProtocol.swift
//  Goodz
//
//  Created by Priyanka Poojara on 06/11/23.
//

import Alamofire
import UIKit

/// Router Protocol default for whole app
public protocol RouterProtocol: URLRequestConvertible {

    /// HTTP Method
    var method: HTTPMethod { get }
    
    /// Base URL String to  call API
    var baseUrlString: String { get }
    
    /// Base URL String to  call IP Address API
    var ipAddressBaseUrlString: String { get }
    
    /// Endpoint for api
    var endpoint: String { get }
    
    /// Parameters for API
    var parameters: [String: Any]? { get }
    
    /// Parameters encoding
    var parameterEncoding: ParameterEncoding { get }
    
    /// Headers
    var headers: [String: String]? { get }
//    var headers: [HTTPHeader] { get }
    
    /// Array of parameters
    var arrayParameters: [Any]? { get }
    
    /// Query Parameters
    var queryParameters: [String: String]? { get }
    
    /// Files multipart
    var files: [MultiPartData]? { get }
    
    /// Device info
    var deviceInfo: [String: Any]? { get }
}

// MARK: - URL Request Extension
public extension RouterProtocol {
    /// get URL Request
    ///
    /// - Returns: return urls request object
    /// - Throws: throws exception if any error
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.baseUrlString) else {
            throw(NetworkError.requestError(errorMessage: "Unable to create url"))
        }
        var request = URLRequest(url: (endpoint.contains("http://") || endpoint.contains("https://")) ? URL(string: endpoint)! : url.appendingPathComponent(endpoint))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.timeoutInterval = 60.0 * 0.5
        do {
            let req = try URLEncoding.default.encode(request as URLRequestConvertible, with: parameters)
            return req
        } catch let error {
            print("error occured \(error)")
        }
        return request
    }
    
    /// Base URL String to call API
    var baseUrlString: String {
        get {
            return infoForKey("App_BaseURL") ?? ""
        }
    }
    
    var backendUrlString: String {
        get {
            return infoForKey("App_BackendURL") ?? ""
        }
    }
    
    func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    
    /// Base URL String to call API
    var ipAddressBaseUrlString: String {
        
        get {
            return "https://ipinfo.io/json"
        }
    }
    
    /// Array of parameters
    var arrayParameters: [Any]? {
        return nil
    }
    
    /// Files multipart
    var files: [MultiPartData]? {
        return nil
    }
    
    /// Device info
    var deviceInfo: [String: Any]? {
        return nil
    }
    
    /// Headers
    var headers: [String : String]? {
        return [
            "Username":"Goodz",
            "password":"12345678"
        ]
    }
    
    /// Parameters encoding
    var parameterEncoding: Alamofire.ParameterEncoding {
        return URLEncoding.httpBody
    }
}

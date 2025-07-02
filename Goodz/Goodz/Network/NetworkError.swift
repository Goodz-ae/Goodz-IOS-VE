//
//  NetworkError.swift
//  Goodz
//
//  Created by Priyanka Poojara on 06/11/23.
//

import Foundation

/// Enum for response error
public enum NetworkError: Error {
    
    // MARK: - Client Error: 400...499
    case clientError(statusCode: Int)
    
    // MARK: - Server Error: 500...599
    case serverError(statusCode: Int)
    
    // MARK: - Parsing Error
    case parsingError(error: Error)
    
    case requestError(errorMessage: String, errorCode : Int? = nil)
    
    // MARK: - Other
    case other(statusCode: Int?, error: Error?)
    
    // MARK: - Network Error With Status Code
    case requestErrorMessageWithStatusCode(errorMessage: String)
    
    func errorMessage() -> String {
        switch self {
        case .requestErrorMessageWithStatusCode(let errorMessage): return errorMessage
        case .clientError(let statusCode):
            return String(statusCode)
        case .serverError(let statusCode):
            return  String(statusCode)
        case .parsingError(let error):
            return error.localizedDescription
            
        case .requestError(let errorMessage, _):
            return errorMessage
        case .other(_, let error):
            return error?.localizedDescription ?? ""
            
        }
    }
    
    func errorCode() -> Int? {
        switch self {
        case .requestErrorMessageWithStatusCode(_):
            return 1000
        case .clientError(let statusCode):
            return statusCode
        case .serverError(let statusCode):
            return  statusCode
        case .parsingError(_):
            return 1001
        case .requestError(_, let errorCode):
            return errorCode
        case .other(_, _):
            return -1
            
        }
    }
    
}

//
//  ChatDropDownRepo.swift
//  Goodz
//
//  Created by Akruti on 12/02/24.
//

import Foundation
import UIKit
import Alamofire

enum ChatDropDownRouter: RouterProtocol {
    
    case blockUserAPI(toId : String, chatId: String, isBlock : String)
    case reportUserAPI(message: String, toId : String, chatId: String)
    case deleteChatAPI(toId : String, chatId: String)
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .blockUserAPI :
            return APIEndpoint.blockUser
        case .reportUserAPI :
            return APIEndpoint.reportUser
        case .deleteChatAPI :
            return APIEndpoint.deleteUser
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
            
        case .blockUserAPI(toId: let toId, chatId: let chatId, isBlock: let isBlock):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId,
                ParameterKey.isBlock : isBlock
                
            ]
        case .reportUserAPI(message: let message,toId: let toId, chatId: let chatId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId,
                ParameterKey.message : message
            ]
        case .deleteChatAPI(toId: let toId, chatId: let chatId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.toId : toId,
                ParameterKey.chatId : chatId
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ChatDropDownRepo {
    
    func blockUserAPI(toId : String, chatId: String,isBlock : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatDropDownRouter.blockUserAPI(toId: toId, chatId: chatId, isBlock: isBlock), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func reportUserAPI(message : String, toId : String, chatId: String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatDropDownRouter.reportUserAPI(message: message, toId: toId, chatId: chatId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
    func deleteChatAPI(toId : String, chatId: String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ChatDropDownRouter.deleteChatAPI(toId: toId, chatId: chatId), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, nil)
                } else {
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
    
}

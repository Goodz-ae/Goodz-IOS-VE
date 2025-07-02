//
//  PriorityContactRepo.swift
//  Goodz
//
//  Created by vtadmin on 23/02/24.
//

import Foundation
import Alamofire
import AVFoundation

enum PriorityContactRouter: RouterProtocol {
    
    case priorityContactAPI(name : String, email : String, subject : String, message : String, attachFile : UIImage?, fileUrl: URL?)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .priorityContactAPI :
            return APIEndpoint.priorityContact
        }
        
    }
   
    var parameters: [String : Any]? {
        
        switch self {
        case .priorityContactAPI(name : let name, email : let email, subject : let subject, message : let message, attachFile : let attachFile, fileUrl: let fileUrl):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.name : name,
                ParameterKey.email : email,
                ParameterKey.subject : subject,
                ParameterKey.message : message,
                ParameterKey.attachFile : attachFile != nil ? (attachFile as Any) : (fileUrl as Any)
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class PriorityContactRepo {
    
    func priorityContactAPI(name : String, email : String, subject : String, message : String, attachFile : UIImage?, fileUrl: URL?, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        // notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: PriorityContactRouter.priorityContactAPI(name : name, email : email, subject : subject, message : message, attachFile : attachFile, fileUrl: fileUrl), responseModel: [ResponseModelOne].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    // If there is data in the result property
                    completion(true, nil)
                } else {
                    // If there is no data or the count is zero
                    completion(false, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, LocalErrors.serverError(error.errorMessage()).message)
            }
            // notifier.hideLoader()
        }
    }
}

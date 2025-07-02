//
//  ConnectionsRepo.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 28/02/24.
//

import Foundation
import UIKit
import Alamofire

enum ConnectionsRouter: RouterProtocol {

    case getConnections

    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .getConnections:
            return APIEndpoint.getConnections
        }
       
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getConnections:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ConnectionsRepo {
    
    func getConnectionsAPI(_ completion: @escaping((_ status: Bool, _ data: [ResponseModel<ConnectionsModel>]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: ConnectionsRouter.getConnections, responseModel: [ResponseModel<ConnectionsModel>].self) { result in
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let statuscode = response.first?.code, statuscode == "1" {
                    completion(true, response, nil)
                } else {
                    completion(false, nil, response.first?.message ?? "")
                }
                
            case .failure(let error):
                print(error)
                completion(false, nil, LocalErrors.serverError(error.errorMessage()).message)
            }
            notifier.hideLoader()
        }
    }
}

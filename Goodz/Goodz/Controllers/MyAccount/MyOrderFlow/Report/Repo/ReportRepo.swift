//
//  ReportRepo.swift
//  Goodz
//
//  Created by Akruti on 30/01/24.
//

import Foundation
import UIKit
import Alamofire

enum ReportRouter: RouterProtocol {

    case reportAproblemAPI(issue: String, image: URL?, orderProductId : String)
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .reportAproblemAPI :
            return APIEndpoint.reportAproblem
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .reportAproblemAPI(issue: let issue, image: let image, orderProductId: let orderProductId):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.orderProductId : orderProductId,
                ParameterKey.issue : issue
            ]
            
            if let url = image {
                params[ParameterKey.image] = url
            }
            
            return params
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ReportRepo {
    
    func confirmReceptionAPI(issue: String, image: URL?, orderProductId : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        
        NetworkManager.multiFormDataRequest(with: ReportRouter.reportAproblemAPI(issue: issue, image: image, orderProductId: orderProductId), responseModel: [ResponseModelOne].self) { result in
           
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
    
    // --------------------------------------------
    
}

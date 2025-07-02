//
//  ForgotPasswordRepo.swift
//  Goodz
//
//  Created by Priyanka Poojara on 04/01/24.
//

import UIKit
import Alamofire

enum ForgotPasswordRouter: RouterProtocol {

    case forgotPasswordAPI(_ email: String)
    
    var method: Alamofire.HTTPMethod {
        .post
    }
    
    var endpoint: String {
        return APIEndpoint.forgotPassword
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .forgotPasswordAPI(let email):
            return [
                "email":email
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }

}

class ForgotPasswordRepo {
    
    func forgotPasswordApi(_ email: String, _ completion: @escaping((_ status: Bool, _ data: [ForgotPasswordModel]?, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: ForgotPasswordRouter.forgotPasswordAPI(email), responseModel: [ResponseModel<ForgotPasswordModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                
                if let firstResponse = response.first, firstResponse.code == "1" {
                    // If there is data in the result property
                    completion(true, firstResponse.result, nil)
                } else if  let firstResponse = response.first, (Int(firstResponse.code ?? "") ?? 0)  < 0  {
                    completion(false, nil, response.first?.message ?? "")
                } else {
                    // If there is no data or the count is zero
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

//
//  ContactUsRepo.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
import UIKit
import Alamofire

enum ContactUsRepoRouter: RouterProtocol {
    // user_name, dob, email, country_code, mobile  , full_name, city, street_Address, area, floor
    case contactUsAPI(_ name : String,_ email : String,_ subject: String,_ message: String,_ imgUrl : URL?)

    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        return APIEndpoint.contactUs
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .contactUsAPI(let name, let email ,let subject,let message,let imgUrl):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.name : name,
                ParameterKey.email : email,
                ParameterKey.subject : subject,
                ParameterKey.message : message,
            ]
            if let url = imgUrl {
                params[ParameterKey.imgUrl] = url
            }
            
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class ContactUsRepoRepo {
    
    func contactUsAPI(_ name : String,_ email : String,_ subject: String,_ message: String,_ imgUrl : URL?,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: ContactUsRepoRouter.contactUsAPI(name, email, subject, message, imgUrl), responseModel : [ResponseModelOne].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.code == "1" {
                    completion(true, response.first?.message ?? "")
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

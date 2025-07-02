//
//  FAQRepo.swift
//  Goodz
//
//  Created by Akruti on 05/01/24.
//

import Foundation
import UIKit
import Alamofire

enum FAQRouter: RouterProtocol {
    case faqAPI
    case cmsAPI(_ cmsId : String)

    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .cmsAPI :
            return APIEndpoint.cms
        case .faqAPI :
            return APIEndpoint.faq
        }

    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .cmsAPI(let cmsId):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.cmsId : cmsId
            ]
        case .faqAPI:
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

class FAQRepo {
    
    func faqAPI(_ completion: @escaping((_ status: Bool, _ data: [FAQModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: FAQRouter.faqAPI, responseModel: [ResponseModel<FAQModel>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil)
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
    
    func cmsAPI(cmsId : String,_ completion: @escaping((_ status: Bool, _ data: [CMSModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: FAQRouter.cmsAPI(cmsId), responseModel: [ResponseModel<CMSModel>].self) { result in
           
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result, nil)
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

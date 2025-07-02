//
//  UploadDocumentRepo.swift
//  Goodz
//
//  Created by Akruti on 08/02/24.
//

import Foundation
import UIKit
import Alamofire

enum UploadDocumentRouter: RouterProtocol {
    
    case uploadDocumentsAPI(frontSideDocUrl:  URL?, backSideDocUrl:  URL?, companyLetterHead :  URL?)
    case getUploadedDocumentsAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .uploadDocumentsAPI :
            return APIEndpoint.uploadDocuments
        case .getUploadedDocumentsAPI :
            return APIEndpoint.getUploadedDocuments
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getUploadedDocumentsAPI :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .uploadDocumentsAPI(frontSideDocUrl: let frontSideDocUrl, backSideDocUrl: let backSideDocUrl, companyLetterHead: let companyLetterHead) :
            var params: [String: Any] = [
                ParameterKey.userId: UserDefaults.userID,
                ParameterKey.token: UserDefaults.accessToken
            ]
            
            if let frontSideDocUrl = frontSideDocUrl {
                params[ParameterKey.frontSideDocUrl] = frontSideDocUrl
            }
            if let backSideDocUrl = backSideDocUrl {
                params[ParameterKey.backSideDocUrl] = backSideDocUrl
            }
            if let companyLetterHead = companyLetterHead {
                params[ParameterKey.companyLetterHead] = companyLetterHead
            }
            
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class UploadDocumentRepo {
    
    func uploadDocumentsAPI(frontSideDocUrl:  URL?, backSideDocUrl:  URL?, tradeLicense:  URL?, companyLetterHead :  URL?, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: UploadDocumentRouter.uploadDocumentsAPI(frontSideDocUrl: frontSideDocUrl, backSideDocUrl: backSideDocUrl,  companyLetterHead: companyLetterHead), responseModel: [ResponseModelOne].self) { result in
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
    
    func getUploadedDocumentsAPI(_ completion: @escaping((_ status: Bool, _ data: [UploadDocumentModel]?, _ error: String?) -> Void)) {
        NetworkManager.dataRequest(with: UploadDocumentRouter.getUploadedDocumentsAPI, responseModel: [ResponseModel<UploadDocumentModel>].self) { result in
            
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
        }
    }
    
}
// MARK: - Bank Letter
enum UploadBankLetterRouter: RouterProtocol {
    
    case uploadDocumentsAPI(bankLetterUrl:  URL?)
    case getUploadedDocumentsAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .uploadDocumentsAPI :
            return APIEndpoint.uploadDocuments
        case .getUploadedDocumentsAPI :
            return APIEndpoint.getUploadedDocuments
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getUploadedDocumentsAPI :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .uploadDocumentsAPI(bankLetterUrl: let bankLetterUrl) :
            var params: [String: Any] = [
                ParameterKey.userId: UserDefaults.userID,
                ParameterKey.token: UserDefaults.accessToken
            ]
            
            
            if let bankLetterUrl = bankLetterUrl {
                params[ParameterKey.bankLetter] = bankLetterUrl
            }
            
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class UploadBankLetterRepo {
    
    func uploadDocumentsAPI(bankLetterUrl: URL?, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: UploadBankLetterRouter.uploadDocumentsAPI(bankLetterUrl: bankLetterUrl), responseModel: [ResponseModelOne].self) { result in
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
    
    func getUploadedDocumentsAPI(_ completion: @escaping((_ status: Bool, _ data: [UploadDocumentModel]?, _ error: String?) -> Void)) {
        NetworkManager.dataRequest(with: UploadDocumentRouter.getUploadedDocumentsAPI, responseModel: [ResponseModel<UploadDocumentModel>].self) { result in
            
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
        }
    }
    
}

// MARK: - Trade Licence

enum UploadTradeLicenceRouter: RouterProtocol {
    
    case uploadDocumentsAPI(tradeLicenceURL:  URL?)
    case getUploadedDocumentsAPI
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        switch self {
        case .uploadDocumentsAPI :
            return APIEndpoint.uploadDocuments
        case .getUploadedDocumentsAPI :
            return APIEndpoint.getUploadedDocuments
        }
        
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .getUploadedDocumentsAPI :
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .uploadDocumentsAPI(tradeLicenceURL: let tradeLicenceURL) :
            var params: [String: Any] = [
                ParameterKey.userId: UserDefaults.userID,
                ParameterKey.token: UserDefaults.accessToken
            ]
            
            
            if let tradeLicenceURL = tradeLicenceURL {
                params[ParameterKey.tradeLicense] = tradeLicenceURL
            }
            
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class UploadTradeLicenceRepo {
    
    func uploadDocumentsAPI(tradeLicenceUrl: URL?, _ completion: @escaping((_ status: Bool,_ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: UploadTradeLicenceRouter.uploadDocumentsAPI(tradeLicenceURL: tradeLicenceUrl), responseModel: [ResponseModelOne].self) { result in
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
    
    func getUploadedDocumentsAPI(_ completion: @escaping((_ status: Bool, _ data: [UploadDocumentModel]?, _ error: String?) -> Void)) {
        NetworkManager.dataRequest(with: UploadDocumentRouter.getUploadedDocumentsAPI, responseModel: [ResponseModel<UploadDocumentModel>].self) { result in
            
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
        }
    }
    
}

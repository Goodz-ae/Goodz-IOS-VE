//
//  WalletRepo.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 06/04/24.
//

import UIKit
import Alamofire

enum WalletRouter: RouterProtocol {
    
    
    case myWalletDetails
    case walletTransactionList
    case getWalletSetup
    case addBankDetail(bankName: String, accountHolderName: String, accountNumber: String, ibanNumber: String, swiftCode: String, imgUrl : URL?)
    case changeBankDetail(bankName: String, accountHolderName: String, accountNumber: String, ibanNumber: String, swiftCode: String, imgUrl : URL?)
    case deleteBankDetail
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        switch self {
        case .myWalletDetails :
            return APIEndpoint.myWalletDetails
        case .walletTransactionList :
            return APIEndpoint.walletTransactionList
        case .getWalletSetup :
            return APIEndpoint.getWalletSetup
        case .addBankDetail :
            return APIEndpoint.addBankDetail
        case .deleteBankDetail :
            return APIEndpoint.deleteBankDetail
        case .changeBankDetail :
            return APIEndpoint.changeBankDetail
        }
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .myWalletDetails:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.sortId : "1",
                ParameterKey.isCredit : "1",
                ParameterKey.pageNo : "1"
            ]
        case .walletTransactionList:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .getWalletSetup:
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken
            ]
        case .addBankDetail(bankName: let bankName, accountHolderName: let accountHolderName, accountNumber: let accountNumber, ibanNumber: let ibanNumber, swiftCode: let swiftCode, imgUrl: let imgUrl):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.bankName : bankName,
                ParameterKey.accountHolderName : accountHolderName,
                ParameterKey.accountNumber : accountNumber,
                ParameterKey.ibanNumber : ibanNumber,
                ParameterKey.swiftCode : swiftCode
            ]
            
            if let url = imgUrl {
                params[ParameterKey.bankLetter] = url
            }
            
            return params
        case .changeBankDetail(bankName: let bankName, accountHolderName: let accountHolderName, accountNumber: let accountNumber, ibanNumber: let ibanNumber, swiftCode: let swiftCode, imgUrl: let imgUrl):
            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.bankName : bankName,
                ParameterKey.accountHolderName : accountHolderName,
                ParameterKey.accountNumber : accountNumber,
                ParameterKey.ibanNumber : ibanNumber,
                ParameterKey.swiftCode : swiftCode
            ]
            
            if let url = imgUrl {
                params[ParameterKey.bankLetter] = url
            }
            
            return params
        case .deleteBankDetail:
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

class WalletRepo {
    
    func getMyWalletDetailsAPI(_ completion: @escaping((_ status: Bool, _ data: WalletDetailsModel?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: WalletRouter.myWalletDetails, responseModel: [ResponseModel<WalletDetailsModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first, nil)
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
    
    func getWalletTransactionListAPI(_ completion: @escaping((_ status: Bool, _ data: [WalletTransactionModel]?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: WalletRouter.walletTransactionList, responseModel: [ResponseModel<WalletDetailsModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first?.walletTransactions, nil)
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
    
    func getWalletSetupAPI(_ completion: @escaping((_ status: Bool, _ data: WalletSetupModel?, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.dataRequest(with: WalletRouter.getWalletSetup, responseModel: [ResponseModel<WalletSetupModel>].self) { result in
            
            switch result {
            case .success(let response):
                guard let response = response else {
                    completion(false, nil, LocalErrors.nullResponse.message)
                    return
                }
                if let firstResponse = response.first, firstResponse.result?.count ?? 0 > 0 {
                    completion(true, firstResponse.result?.first, nil)
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
    
    func addBankDetailAPI(isEdit: Bool, bankName : String, accountHolderName : String, accountNumber : String, ibanNumber: String, swiftCode: String, imgUrl: URL?,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        var value: WalletRouter?
        if isEdit {
            value = .changeBankDetail(bankName: bankName, accountHolderName: accountHolderName, accountNumber: accountNumber, ibanNumber: ibanNumber, swiftCode: swiftCode, imgUrl: imgUrl)
        }else{
            value = .addBankDetail(bankName: bankName, accountHolderName: accountHolderName, accountNumber: accountNumber, ibanNumber: ibanNumber, swiftCode: swiftCode, imgUrl: imgUrl)
        }
        if let value = value {
            NetworkManager.multiFormDataRequest(with: value , responseModel: [ResponseModelOne].self) { result in
               
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
    
    func deleteBankDetailAPI(_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: WalletRouter.deleteBankDetail, responseModel: [ResponseModelOne].self) { result in
           
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

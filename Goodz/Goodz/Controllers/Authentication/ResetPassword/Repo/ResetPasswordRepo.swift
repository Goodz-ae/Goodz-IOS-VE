//
//  ResetPasswordRepo.swift
//  Goodz
//
//  Created by Priyanka Poojara on 04/01/24.
//

import UIKit
import Alamofire

enum ResetPasswordRouter: RouterProtocol {

    case resetPasswordAPI(_ email: String, _ newPassword: String, _ confirmPassword: String)
    case changePasswordAPI(_ newPassword: String, _ currentPassword: String)
    var method: Alamofire.HTTPMethod {
        .post
    }
    
    var endpoint: String {
        switch self {
        case .resetPasswordAPI :
            return APIEndpoint.resetPassword
        case .changePasswordAPI :
            return APIEndpoint.changePassword
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .resetPasswordAPI(let email, let newPassword, let confirmPassword):
            return [
                ParameterKey.email : email,
                ParameterKey.newPassword : newPassword,
                ParameterKey.confirmPassword: confirmPassword
            ]
        case .changePasswordAPI(let newPassword, let currentPassword):
            return [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.newPassword : newPassword,
                ParameterKey.currentPassword: currentPassword
            ]
        }
    }
    
    var queryParameters: [String : String]? {
        return nil
    }

}

class ResetPasswordRepo {
    
    func resetPasswordApi(_ userId: String, _ newPassword: String, _ confirmPassword: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: ResetPasswordRouter.resetPasswordAPI(userId, newPassword, confirmPassword), responseModel: [ResponseModelOne].self) { result in
            
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
             notifier.hideLoader()
        }
    }
    
    // --------------------------------------------
    
    func changePasswordAPI(_ newPassword: String, _ currentPassword: String, _ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
         notifier.showLoader()
        NetworkManager.dataRequest(with: ResetPasswordRouter.changePasswordAPI(newPassword, currentPassword), responseModel: [ResponseModelOne].self) { result in
            
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
             notifier.hideLoader()
        }
    }
}

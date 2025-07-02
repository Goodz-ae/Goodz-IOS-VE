//
//  EditProfileRepo.swift
//  Goodz
//
//  Created by Akruti on 04/01/24.
//

import Foundation
import UIKit
import Alamofire

enum EditProfileRouter: RouterProtocol {
    // user_name, dob, email, country_code, mobile  , full_name, city, street_Address, area, floor
    case editProfileAPI(profilePicture : UIImage,_ userName : String,_ dob : String,_ email: String,_ countryCode: String,_ mobile : String , _ name : String,_ city : String,_ streetAddress : String,_ area : String,_ floor : String,_ lastName : String,_ companyName : String)

    var method: Alamofire.HTTPMethod {
        return .post
    }
        
    var endpoint: String {
        return APIEndpoint.editProfile
    }
    
    var parameters: [String : Any]? {
        
        switch self {
        case .editProfileAPI(let profilePicture, let userName, let dob ,let email,let countryCode,let mobile,let name,let city, let streetAddress,let area,let floor, let lastName, let companyName):

            var params: [String: Any] = [
                ParameterKey.userId : UserDefaults.userID,
                ParameterKey.token : UserDefaults.accessToken,
                ParameterKey.userName : userName,
                ParameterKey.dob : dob,
                ParameterKey.email : email,
                ParameterKey.countryCode : countryCode,
                ParameterKey.mobile : mobile,
                ParameterKey.name : name,
                ParameterKey.lastName : lastName,
                ParameterKey.storeName : companyName,
                ParameterKey.profilePicture : profilePicture
            ]
            if !city.isEmpty {
                params[ParameterKey.city] = city
            }
            if !streetAddress.isEmpty {
                params[ParameterKey.streeetAddress] = streetAddress
            }
            if !area.isEmpty {
                params[ParameterKey.area] = area
            }
            if !floor.isEmpty {
                params[ParameterKey.floor] = floor
            }
            return params
        }
        
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
}

class EditProfileRepo {
    
    func editProfileAPI(profilePicture : UIImage, userName : String, dob : String, email: String, countryCode: String, mobile : String ,  name : String, city : String, streetAddress : String, area : String, floor : String, lastName : String, companyName : String,_ completion: @escaping((_ status: Bool, _ error: String?) -> Void)) {
        notifier.showLoader()
        NetworkManager.multiFormDataRequest(with: EditProfileRouter.editProfileAPI(profilePicture: profilePicture, userName, dob, email, countryCode, mobile, name, city, streetAddress, area, floor, lastName, companyName), responseModel: [ResponseModelOne].self) { result in
           
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

//
//  EditProfileVM.swift
//  Goodz
//
//  Created by Akruti on 26/12/23.
//

import Foundation
import UIKit
class EditProfileVM {
  
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = EditProfileRepo()
    var addressrepo = AddAddressRepo()
    var arrCities : [CitiesModel] = [CitiesModel]()
    var arrArea : [AreaModel] = [AreaModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchCityData(completion: @escaping((Bool) -> Void)) {
        addressrepo.getCitiesAPI() { status, data, error  in
            if status, let cityData = data {
                self.arrCities = cityData
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfCity() -> Int {
        self.arrCities.count
    }
    
    // --------------------------------------------
    
    func setCityRow(row: Int) -> CitiesModel {
        self.arrCities[row]
    }
    
    // --------------------------------------------
    
    func fetchAreaData(cityId : String, completion: @escaping((Bool) -> Void)) {
        addressrepo.getAreaAPI(cityId: cityId) { status, data, error  in
            if status, let areaData = data {
                self.arrArea = areaData
                completion(true)
                return
            } else {
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfArea() -> Int {
        self.arrArea.count
    }
    
    // --------------------------------------------
    
    func setAreaRow(row: Int) -> AreaModel {
        self.arrArea[row]
    }
    func checkUserData(profilePicture: UIImage,username : String, firstName: String, email : String, countryCode : String, mobile: String, dob : String, lastName: String, companyName: String,  completion: @escaping (Bool) -> Void) {
//        if username.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterUsername)
//            completion(false)
//        } else if !Validation.shared.isValidateUsername(username: username) {
//            notifier.showToast(message: Labels.pleaseEnterValidUsername)
//            completion(false)
//        } else 
        if firstName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFirstName)
            completion(false)
        } 
//        else if !Validation.shared.isValidateUsername(username: firstName) {
//            notifier.showToast(message: Labels.pleaseEnterValidFirstName)
//            completion(false)
//        } 
        else if lastName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterLastName)
            completion(false)
        } 
//        else if !Validation.shared.isValidateUsername(username: lastName) {
//            notifier.showToast(message: Labels.pleaseEnterValidLastName)
//            completion(false)
//        } 
        else if email.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterEmail)
            completion(false)
        } else if !Validation.shared.isValidEmail(email) {
            notifier.showToast(message: Labels.pleaseEnterValidEmail)
            completion(false)
        } else if mobile.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterPhoneNumber)
            completion(false)
        } else if !Validation.shared.isValidPhone(phoneNumber: mobile) {
            notifier.showToast(message: Labels.pleaseEnterValidPhoneNumber)
            completion(false)
        }
//        else if dob.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterDOB)
//            completion(false)
//        }
        else {
            self.repo.editProfileAPI(profilePicture: profilePicture, userName: username, dob: dob, email: email, countryCode: countryCode, mobile: mobile, name: firstName, city: "", streetAddress: "", area: "", floor: "", lastName: lastName, companyName: "") { status, error in
                if status {
                    GlobalRepo.shared.getProfileAPI { status, data, error in
                        print(data)
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
    func checkProUserDataFirst(profilePicture: UIImage,username : String, fName: String, lName : String , companyName: String, dob : String, completion: (Bool) -> Void) {
//        if username.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterUsername)
//            completion(false)
//        } else if !Validation.shared.isValidateUsername(username: username) {
//            notifier.showToast(message: Labels.pleaseEnterValidUsername)
//            completion(false)
//        } else 
        if fName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFirstName)
            completion(false)
        } 
//        else if !Validation.shared.isValidateName(name: fName) {
//            notifier.showToast(message: Labels.pleaseEnterValidFirstName)
//            completion(false)
//        } 
        else if lName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterLastName)
            completion(false)
        }
//        else if !Validation.shared.isValidateName(name: lName) {
//            notifier.showToast(message: Labels.pleaseEnterValidLastName)
//            completion(false)
//        } 
        else if companyName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterCompanyName)
            completion(false)
        }
//        else if dob.isEmpty {
//            notifier.showToast(message: Labels.pleaseEnterDOB)
//            completion(false)
//        }
        else {
            completion(true)
        }
    }
    
    // --------------------------------------------
    
    func checkProUserDataSecond(city : String, area: String, streetAddress : String, floor : String, completion: (Bool) -> Void) {
        if city.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectCity)
            completion(false)
        } else if area.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectArea)
            completion(false)
        } else if streetAddress.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterStreetAddress)
            completion(false)
        } else if floor.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFloor)
            completion(false)
        } else {
            completion(true)
        }
    }
    
    // --------------------------------------------
    
}

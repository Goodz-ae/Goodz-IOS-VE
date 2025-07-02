//
//  AddAddressVM.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
class AddAddressVM {
    
    // --------------------------------------------
    // MARK: - Custom Variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = AddAddressRepo()
    var arrCities : [CitiesModel] = [CitiesModel]()
    var arrArea : [AreaModel] = [AreaModel]()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchCityData(completion: @escaping((Bool) -> Void)) {
        repo.getCitiesAPI() { status, data, error  in
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
        repo.getAreaAPI(cityId: cityId) { status, data, error  in
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
    
    // --------------------------------------------
    
    func checkAddressData(firstName : String, lastName : String, countryCode : String, mobile: String, city : String, area: String, streetAddress : String, floor : String, cityId: String, areaId : String, addressId: String ,completion: @escaping(Bool) -> Void) {
        if firstName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFirstName)
            completion(false)
        } else if lastName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterLastName)
            completion(false)
        } else if mobile.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterPhoneNumber)
            completion(false)
        } else if !Validation.shared.isValidPhone(phoneNumber: mobile) {
            notifier.showToast(message: Labels.pleaseEnterValidPhoneNumber)
            completion(false)
        } else if city.isEmpty {
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
            repo.addEditAddressAPI(fullname: firstName + " " + lastName, countryCode: countryCode, mobile: mobile, cityId: cityId, areaId: areaId, floor: floor, streetAddress: streetAddress, addressId: addressId) { status, data, error in
                if status {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    // --------------------------------------------
    
}

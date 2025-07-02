//
//  MyStoreVM.swift
//  Goodz
//
//  Created by Akruti on 26/12/23.
//

import UIKit

class MyStoreVM {

    var fail: BindFail?
    var repo = MyStoreRepo()
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
    
    func editStoreDetailsData(storeId: String, storeName: String, storeImage: UIImage, storeCityId: String, storeAreaId: String, description: String, completion: @escaping((Bool) -> Void)) {
        repo.editStoreDetailsAPI(storeId: storeId, storeName: storeName, storeImage: storeImage, storeCityId: storeCityId, storeAreaId: storeAreaId, description: description) { status, data, error  in
            if status, let _ = data {
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
    
    
    func checkMyStoreData(companyName: String, city: String, state: String, description: String, storeImage: UIImage?, completion: (Bool) -> Void) {
        if companyName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterCompanyName)
            completion(false)
        } else if city.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectCity)
            completion(false)
        } else if state.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectArea)
            completion(false)
        } else if description.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterDescription)
            completion(false)
        } else if storeImage == nil || storeImage == .product {
            notifier.showToast(message: Labels.pleaseUploadStoreImage)
            completion(false)
        } else {
            completion(true)
        }
    }
}

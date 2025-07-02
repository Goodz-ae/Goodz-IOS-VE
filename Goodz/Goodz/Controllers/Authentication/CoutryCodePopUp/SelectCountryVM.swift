//
//  SelectCountryVM.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
class SelectCountryVM {
    
    var arrCoutryList : [CountryListModel]?
    var arrAllCountryCode : [CountryListModel]?
    func fetchCoutryList(completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.coutryListApi { status, data, error in
            self.arrCoutryList = data
            self.arrAllCountryCode = data
            completion(status)
           
        }
    }
    
    func setNumberOfCountry() -> Int {
        self.arrCoutryList?.count ?? 0
    }
     
    func setCoutryData(row: Int) -> CountryListModel {
        self.arrCoutryList?[row] ?? CountryListModel(id: "", countryCode: "", countryName: "", phoneNumberLength: "")
    }
    
}

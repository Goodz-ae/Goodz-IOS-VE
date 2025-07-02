//
//  SplashVM.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import Foundation
var kCurrency : String = ""
var kMakeAnOfferDiscount = ""
var kLengthMobile : CountryListModel = CountryListModel(id: "1", countryCode: "+971", countryName: "UAE", phoneNumberLength: "7")
class SplashVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = SplashRepo()
    var arrCoutryList : [CountryListModel]?
    var arrAllCountryCode : [CountryListModel]?
    
    // --------------------------------------------
    // MARK: - Init method
    // --------------------------------------------
    init(fail: BindFail? = nil, repo: SplashRepo = SplashRepo()) {
        self.fail = fail
        self.repo = repo
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setAppBase() {
        self.repo.generalApi { status, data, error in
            if status {
                appUserDefaults.setValue(.currency, to: data?.first?.currency ?? "AED")
                appUserDefaults.setValue(.appUpdateVersion, to: data?.first?.iosAppVersion ?? "")
                appUserDefaults.setValue(.forceUpdate, to: data?.first?.iosVersionUpdate ?? "")
                kCurrency = (appUserDefaults.getValue(.currency) ?? "") + " "
                appDelegate.generalModel = data?.first
                kMakeAnOfferDiscount = data?.first?.makeAnOfferDiscount ?? ""
                print(data as Any)
            } else {
                print(error ?? "")
            }
        }
       
        self.repo.labelApi(updateDate: appUserDefaults.getValue(.updatedDate) ?? "") { status, data, error, updateDate  in
            if status {
                appUserDefaults.setValue(.updatedDate, to: updateDate)
                let arrLabel = data ?? []
                print("DEBUG Arr LB :-",arrLabel)
                appLANG.manageLabelList(list: arrLabel)
            } else {
                print(appLANG.retrive(label: error ?? ""))
            }
        }
        
        GlobalRepo.shared.getIPAddressAPI { status, data, error in
            appDelegate.ipInfo = data
        }
    }
    
    // --------------------------------------------
    

    func fetchCoutryList(completion: @escaping((Bool) -> Void)) {
        GlobalRepo.shared.coutryListApi { status, data, error in
            self.arrCoutryList = data
            self.arrAllCountryCode = data
            completion(status)
           
        }
    }
    
    
}

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        return dateFormatter.string(from: Date())

    }
}

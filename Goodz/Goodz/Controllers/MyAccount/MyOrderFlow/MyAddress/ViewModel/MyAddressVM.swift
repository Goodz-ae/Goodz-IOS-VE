//
//  MyAddressVM.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit
class MyAddressVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    var fail: BindFail?
    var repo = MyAddressRepo()
    var totalRecords = Int()
    var arrmyAddress : [MyAddressModel] = [MyAddressModel]()
    init(fail: BindFail? = nil, repo: MyAddressRepo = MyAddressRepo(), totalRecords: Int = Int()) {
        self.fail = fail
        self.repo = repo
        self.totalRecords = totalRecords
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func fetchData(pageNo : Int, completion: @escaping((Bool) -> Void)) {
        repo.myAddressAPI(pageNo: pageNo) { status, data, error, totalRecords  in
            if status, let addressList = data {
                self.totalRecords = totalRecords
                if pageNo == 1 {
                    self.arrmyAddress = addressList
                } else {
                    self.arrmyAddress.append(contentsOf: addressList)
                }
                completion(true)
                return
            } else {
                self.arrmyAddress = []
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func deleteAddress(addressId: String, completion: @escaping((Bool) -> Void)) {
        repo.deleteAddressAPI(addressId: addressId) { status, error in
            if status {
                print("delete \(addressId)")
            } else {
                print(error)
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func setDefaultAddress(addressId: String,completion: @escaping((Bool) -> Void)) {
        self.repo.setDefaultAddress(addressId: addressId) { status, error in
            if status {
                completion(true)
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
                completion(false)
            }
        }
    }
    
    // --------------------------------------------
    
    func numberOfAddress() -> Int {
        self.arrmyAddress.count
    }
    
    // --------------------------------------------
    
    func setAddressData(row: Int) -> MyAddressModel {
        self.arrmyAddress[row]
    }
    
    // -----------------------------
    
    func getAddressIndex(addressId: String) -> Int {
        if let index = self.arrmyAddress.firstIndex(where: {$0.addressId == addressId}) {
            return index
        }else{
            return 0
        }
    }
    
}

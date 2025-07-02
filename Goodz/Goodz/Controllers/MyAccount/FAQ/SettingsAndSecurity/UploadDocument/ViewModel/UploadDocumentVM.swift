//
//  UploadDocumentVM.swift
//  Goodz
//
//  Created by Akruti on 08/02/24.
//

import Foundation
class UploadDocumentVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = UploadDocumentRepo()
    var bankLetterRepo = UploadBankLetterRepo()
    var tradeLicenceRepo = UploadTradeLicenceRepo()
    var uplodaedData: UploadDocumentModel?
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func getUploadedDocumentsAPI(completion : @escaping((_ status: Bool)-> Void)) {
        self.repo.getUploadedDocumentsAPI { status, data, error in
            if let docs = data, let doc = docs.first {
                self.uplodaedData = doc
            }
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func uploadDocumentsAPI(frontSideDocUrl: URL?, backSideDocUrl:  URL?, tradeLicense:  URL?, companyLetterHead :  URL?, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.repo.uploadDocumentsAPI(frontSideDocUrl: frontSideDocUrl, backSideDocUrl: backSideDocUrl, tradeLicense: tradeLicense, companyLetterHead: companyLetterHead) { status, error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func uploadBankLetterAPI(bankLetterUrl: URL?, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.bankLetterRepo.uploadDocumentsAPI(bankLetterUrl: bankLetterUrl) { status, error in
            completion(status)
        }
    }
    
    // --------------------------------------------
    
    func uploadTradeLicenceAPI(tradeLicenceUrl: URL?, _ completion: @escaping((_ status: Bool) -> Void)) {
        self.tradeLicenceRepo.uploadDocumentsAPI(tradeLicenceUrl: tradeLicenceUrl) { status, error in
            completion(status)
        }
    }
}

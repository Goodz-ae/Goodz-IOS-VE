//
//  FAQVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation

class FAQVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrHelpCenter : [FAQModel] = []
    var arrCMS : [String] = []
    
    var fail: BindFail?
    var repo = FAQRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData(completion: @escaping((Bool) -> Void)) {
        self.arrCMS = [Labels.privacyPolicy,
                       Labels.termsAndCondition,
                       Labels.proTermsAndConditions]
//                       Labels.termOfUse]
        repo.faqAPI { status, data, error in
            if status, let faqData = data {
                self.arrHelpCenter = faqData
                completion(true)
            } else {
                completion(false)
            }
        }
    
    }
    
    func setNumberOfHelpCenter() -> Int {
        self.arrHelpCenter.count
    }
    
    func setRowData(row: Int) -> FAQModel {
        self.arrHelpCenter[row]
    }
    
    func setNumberOfCMS() -> Int {
        self.arrCMS.count
    }
    
    func setRowDataOfCMS(row: Int) -> String {
        self.arrCMS[row]
    }
    
    func openFaqPage(id: Int) -> [SubFAQModel] {
        self.arrHelpCenter[id].data ?? [SubFAQModel]()
    }
    
    func openCMS(title : String) -> Int {
        switch title {
        case Labels.privacyPolicy :
            return 2
        case Labels.termsAndCondition :
            return 5
        case Labels.proTermsAndConditions :
            return 36
//        case Labels.termOfUse :
//            return 37
        default:
            return 0
        }
    }
    
    func setCmsData(id : Int, completion: @escaping(([CMSModel]) -> Void)) {
        self.repo.cmsAPI(cmsId: String(id)) { status, data, error in
            if status {
                completion(data ?? [CMSModel]())
            } else {
                completion([CMSModel]())
            }
        }
    }
}

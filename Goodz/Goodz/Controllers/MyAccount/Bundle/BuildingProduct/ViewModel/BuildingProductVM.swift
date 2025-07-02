//
//  BuildingProductVM.swift
//  Goodz
//
//  Created by Akruti on 07/02/24.
//

import Foundation
class BuildingProductVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var fail: BindFail?
    var repo = BuildingProductRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    func fetch(firstStageAmount: String, firstStageDiscount : String, secondStageAmount : String,
               secondStageDiscount : String, thirdStageAmount : String, thirdStageDiscount : String, _ completion: @escaping((_ status: Bool) -> Void)) {
        if firstStageAmount.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterFirstStageAmount)
            return
        } else if firstStageDiscount.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectFirstStageDiscount)
            return
        }
        
        if secondStageAmount.isEmpty == false {
            if (firstStageAmount.toDouble() > 0) &&  (secondStageAmount.toDouble() > 0)  && ((Double(firstStageAmount) ?? 0) >= (Double(secondStageAmount) ?? 0)) {
                notifier.showToast(message: Labels.secondStageAmountShouldBeHigherThanFirstStageAmount)
                return
            } else if secondStageDiscount.isEmpty {
                notifier.showToast(message: Labels.pleaseSelectSecondStageDiscount)
                return
            }
        }
        
        if thirdStageAmount.isEmpty == false {
            if secondStageAmount.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterSecondStageAmount)
                return
            } else if (secondStageAmount.toDouble() > 0) &&  (thirdStageAmount.toDouble() > 0)  && ((Double(secondStageAmount) ?? 0) >= (Double(thirdStageAmount) ?? 0)) {
                notifier.showToast(message: Labels.thirdStageAmountShouldBeHigherThanSecondStageAmount)
                return
            } else if thirdStageDiscount.isEmpty {
                notifier.showToast(message: Labels.pleaseSelectThirdStageDiscount)
                return
            }
        }
        
        self.repo.bundlingProductsAPI(firstStageAmount: firstStageAmount, firstStageDiscount: firstStageDiscount, secondStageAmount: secondStageAmount, secondStageDiscount: secondStageDiscount, thirdStageAmount: thirdStageAmount, thirdStageDiscount: thirdStageDiscount) { status, error in
            completion(status)
        }
    }
}

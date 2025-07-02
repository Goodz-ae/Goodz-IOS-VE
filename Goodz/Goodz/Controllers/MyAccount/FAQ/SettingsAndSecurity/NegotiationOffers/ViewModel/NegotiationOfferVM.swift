//
//  NegotiationOfferVM.swift
//  Goodz
//
//  Created by on 10/04/25.
//

import Foundation

class NegotiationOfferVM {
    
    var arrNegotiation : [NegotiationOfferModel] = []
    var fail: BindFail?
    var repo = NegotiationOfferRepo()
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func getNegotiationOffers(NegotiationStatus: Bool,completion: @escaping((Bool) -> Void)) {
        self.repo.getNegotiationOffer(negotiationStatus: NegotiationStatus) { status, data, error in
            if status, let res = data {
                print("response is:", res)
                self.arrNegotiation = res
            } else {
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                }
            }
            completion(status)
        }
    }
    
}

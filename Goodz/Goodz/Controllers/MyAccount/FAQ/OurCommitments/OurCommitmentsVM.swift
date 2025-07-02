//
//  OurCommitmentsVM.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit
class CommitmentModel {
    var title : String
    var description : String
    var image : UIImage
    internal init(title: String, description: String, image: UIImage) {
        self.title = title
        self.description = description
        self.image = image
    }
}
class OurCommitmentsVM {
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrCommitment : [CommitmentModel] = []
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData() {
        self.arrCommitment = [CommitmentModel(title: Labels.commitmentTitleOne, description: Labels.commitmentDesOne, image: .groupOne),
                              CommitmentModel(title: Labels.commitmentTitleTwo, description: Labels.commitmentDesTwo, image: .groupTwo),
                              CommitmentModel(title: Labels.commitmentTitleThree, description: Labels.commitmentDesThree, image: .groupThree),
                              CommitmentModel(title: Labels.commitmentTitleFour, description: Labels.commitmentDesFour, image: .groupFour)]
    }
    
    // --------------------------------------------
    
    func setNumberOfCommitment() -> Int {
        self.arrCommitment.count
    }
    
    // --------------------------------------------
    
    func setRowDataOfCommitment(row: Int) -> CommitmentModel {
        self.arrCommitment[row]
    }
    
    // --------------------------------------------
    
}

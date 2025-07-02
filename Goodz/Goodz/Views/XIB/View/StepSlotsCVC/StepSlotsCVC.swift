//
//  StepSlotsCVC.swift
//  Goodz
//
//  Created by shobhitdhuria on 14/05/25.
//

import UIKit

class StepSlotsCVC: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var selectedSlotCell: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.cornerRadius = 5
        self.dateLbl.font(font: .semibold, size: .size14)
        self.timeLbl.font(font: .regular, size: .size14)
    }
    
    func setSelected() {
        if selectedSlotCell {
            self.backView.borderWidth = 1
            self.backView.borderColor = .themeGreen
            self.backView.backgroundColor = .themeLightGreen
        } else {
            self.backView.borderWidth = 0
            self.backView.backgroundColor = .themeGray2
        }
    }
    
}

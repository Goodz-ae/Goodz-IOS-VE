//
//  SingleSelectionCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class SingleSelectionCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.lblTitle.font(font: .medium, size: .size16)
        self.lblDescription.font(font: .regular, size: .size12)
    }
    
    // --------------------------------------------
    
    func setData(data: BrandModel) {
        self.lblTitle.text = data.brandTitle
        self.lblDescription.isHidden = true
        
    }
    
    // --------------------------------------------
    
    func setConditionData(data: ConditionModel) {
        self.lblTitle.text = data.conditionTitle
        self.lblDescription.text = data.description
        
    }
    
    // --------------------------------------------
  
//    func setMultiSelectionData(data: SelectionDataModel) {
//        self.lblTitle.text = data.title
//        self.lblDescription.isHidden = data.description.isEmpty
//                
//        if data.isSelected {
//            self.ivCheck.image = .icCheckboxSqr
//        } else {
//            self.ivCheck.image = .iconUncheckBox
//        }
//    }
    
    // --------------------------------------------
    
    func setColors(data: ColorModel) {
        self.lblTitle.text = data.title
        self.lblDescription.isHidden = true
    }
    
    // --------------------------------------------
    
}

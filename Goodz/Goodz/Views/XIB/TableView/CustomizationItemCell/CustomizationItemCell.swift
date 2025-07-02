//
//  CustomizationItemCell.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import UIKit

class CustomizationItemCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    // --------------------------------------------
    // MARK: - Intial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.btnSelect.setImage(.iconUncheckBox, for: .normal)
        self.btnSelect.setImage(.iconCheckSquare, for: .selected)
        
        self.lblTitle.font(font: .medium, size: .size16)
        self.lblTitle.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setDataCustomization(data: CategorySubModel,lastRow: Int, currentRow: Int) {
        self.lblTitle.text = data.categoriesSubTitle
       // self.btnSelect.isSelected = data.isSelect
        self.vwSeperator.isHidden = lastRow == currentRow
    }
    
    // --------------------------------------------
    
    func setSubCollectionCategory(data: CategoryCollectionModel, lastRow : Int, currentRow : Int) {
        self.lblTitle.text = data.categoryCollectionTitle
        self.vwSeperator.isHidden = lastRow == currentRow
    }
}

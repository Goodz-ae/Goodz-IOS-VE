//
//  DashBoardCell.swift
//  Goodz
//
//  Created by Akruti on 20/12/23.
//

import UIKit

class DashBoardCell: UICollectionViewCell {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblAmount.font(font: .semibold, size: .size16)
        self.lblAmount.color(color: .themeBlack)
        
        self.lblTitle.font(font: .regular, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        
        self.vwMain.cornerRadius(cornerRadius: 4.0)
    }
    
    func setData(data: DashboardSortModel) {
        self.lblTitle.text = data.title
        self.lblAmount.text = data.amount
    }
}

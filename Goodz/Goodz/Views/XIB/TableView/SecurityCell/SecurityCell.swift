//
//  SecurityCell.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import UIKit

class SecurityCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgRight: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.lblTitle.font(font: .medium, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        
        self.lblDescription.font(font: .regular, size: .size12)
        self.lblDescription.color(color: .themeGray)
    }
    
    func setData(data: AccounteModel) {
        self.lblTitle.text = data.title
        self.lblDescription.text = data.description
    }
}

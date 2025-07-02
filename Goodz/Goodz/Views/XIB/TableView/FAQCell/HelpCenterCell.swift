//
//  HelpCenterCell.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import UIKit

class HelpCenterCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwSeperator: UIView!
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
    
    private func applyStyle() {
        self.lblTitle.font(font: .regular, size: .size16)
        self.lblTitle.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: String, lastRow: Int, currentRow: Int) {
        self.lblTitle.text = data
        self.vwSeperator.isHidden = lastRow == currentRow
    }
    
}

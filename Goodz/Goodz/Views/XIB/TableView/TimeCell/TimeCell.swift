//
//  TimeCell.swift
//  Goodz
//
//  Created by vtadmin on 21/12/23.
//

import UIKit

class TimeCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.font(font: .semibold, size: .size16)
        self.mainView.cornerRadius(cornerRadius: 4.0)
        self.mainView.setRoundBorderWithColor(borderWidth: 1, borderColor: .themeBorder, cornerRadius: 4.0)
    }

    // --------------------------------------------
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // --------------------------------------------
    
}

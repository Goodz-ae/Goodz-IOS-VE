//
//  SuggetionCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

class SuggetionCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwSuggetion: UIView!
    @IBOutlet weak var lblSuggetion: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.applyStyle()
    }
    
    // --------------------------------------------
    
    func applyStyle() {
        self.vwSuggetion.cornerRadius(cornerRadius: self.vwSuggetion.frame.size.height / 2.0)
        self.vwSuggetion.border(borderWidth: 1.0, borderColor: .themeGreen)
    }
    
    // --------------------------------------------
    
}

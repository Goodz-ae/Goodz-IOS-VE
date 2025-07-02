//
//  SlotBookingCollViewCell.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 20/05/25.
//

import UIKit

class SlotBookingCollViewCell: UICollectionViewCell, Reusable {
    
    
    @IBOutlet weak var timeLab : UILabel!
    @IBOutlet weak var selectedTimeView  : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeLab.font(font: .regular, size: .size14)
        // Initialization code
    }
    
     

}

//
//  SlotCollectionViewCell.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 28/05/25.
//

import UIKit

class SlotCollectionViewCell: UICollectionViewCell  , Reusable {

    
    @IBOutlet weak var weakDayLab : UILabel!
    @IBOutlet weak var dateLab : UILabel!
   
    @IBOutlet weak var selectedView  : UIView! 

    override func awakeFromNib() {
        super.awakeFromNib()
        self.weakDayLab.font(font: .bold, size: .size16)
        self.dateLab.font(font: .regular, size: .size14)
        
        
      
        // Initialization code
    }

}

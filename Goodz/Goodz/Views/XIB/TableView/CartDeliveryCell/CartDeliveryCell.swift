//
//  CartDeliveryCell.swift
//  Goodz
//
//  Created by shobhitdhuria on 16/01/25.
//

import UIKit

class CartDeliveryCell: UITableViewCell {

    @IBOutlet weak var vwDelivery: UIStackView!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var btnCollectionSeller: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnAssembly: UIButton!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblDeliveryHome: UILabel!
    @IBOutlet weak var lblAssembly: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

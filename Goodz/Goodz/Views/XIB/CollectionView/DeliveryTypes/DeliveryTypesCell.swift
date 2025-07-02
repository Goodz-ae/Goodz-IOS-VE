//
//  DeliveryTypesCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class DeliveryTypesCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivDeliveryType: UIImageView!
    @IBOutlet weak var ivCheck: UIImageView!
    @IBOutlet weak var lblDeliveryType: UILabel!
   
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData(data: DeliveryTypeModel) {
        self.lblDeliveryType.text = data.deliveryTypeName
        if let img = data.image, let url = URL(string: img) {
            self.ivDeliveryType.sd_setImage(with: url, placeholderImage: .product)
        } else {
            self.ivDeliveryType.image = .product
        }
        self.ivCheck.image = .iconCheck
        
    }
    
    // --------------------------------------------
    
}

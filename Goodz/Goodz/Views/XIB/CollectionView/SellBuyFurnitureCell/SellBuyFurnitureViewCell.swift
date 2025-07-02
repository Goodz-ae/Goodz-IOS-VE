//
//  SellBuyFurnitureViewCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

class SellBuyFurnitureViewCell: UICollectionViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var lblBuySell: UILabel!
    
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
    
    func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size14)
        self.lblBuySell.font(font: .bold, size: .size16)
    }
    
    // --------------------------------------------
    
    func setData(data: BuySellFurnitureData) {
        if let url = URL(string: data.background) {
            self.ivBackground.sd_setImage(with: url, placeholderImage: .product)
            self.ivBackground.contentMode = .scaleAspectFill
        } else {
            self.ivBackground.image = .product
        }
        switch data.goodsType {
        case .buy:
            self.lblBuySell.text = Labels.buy.uppercased()
        case .sell:
            self.lblBuySell.text = Labels.sell.uppercased()
        }
        self.lblTitle.text = data.title
    }
    
    // --------------------------------------------
    
}

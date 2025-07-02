//
//  NewHomeProductCVC.swift
//  Goodz
//
//  Created by on 28/03/25.
//

import UIKit

class NewHomeProductCVC: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var goodzAmount: UILabel!
    @IBOutlet weak var originalAmount: UILabel!
    @IBOutlet weak var imgBG:  UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productName.font(font: .regular, size: .size14)
        self.sellerName.font(font: .regular, size: .size12)
        self.goodzAmount.font(font: .regular, size: .size12)
        self.originalAmount.font(font: .regular, size: .size8)
        self.originalAmount.attributedText = (kCurrency + "300").strikeThrough()
    }
}

//
//  CartItemCell.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import UIKit

class CartItemCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var btnCollectionSeller: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnAssembly: UIButton!
    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblDeliveryHome: UILabel!
    @IBOutlet weak var lblAssembly: UILabel!
    
    @IBOutlet weak var vwDelivery: UIStackView!
    @IBOutlet weak var vwProduct: UIStackView!
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.imgProduct.image = .avatarStore
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.imgProduct.cornerRadius(cornerRadius: 2.0)
        
        self.lblBrand.font(font: .regular, size: .size12)
        self.lblBrand.color(color: .themeGray)
        
        self.lblProductName.font(font: .semibold, size: .size14)
        self.lblProductName.color(color: .themeBlack)
        
        self.lblPrice.font(font: .medium, size: .size14)
        self.lblPrice.color(color: .themeBlack)
        
        self.lblOriginalPrice.font(font: .medium, size: .size14)
        self.lblOriginalPrice.color(color: .themeGray)
        // self.lblOriginalPrice.attributedText = "AED 333".strikeThrough()
        
    }
    
    // --------------------------------------------
    
    func setData(data: CartProductModel) {
        self.lblProductName.text = data.productName
        self.lblPrice.text = kCurrency + (data.price ?? "0")
        self.lblOriginalPrice.attributedText = (kCurrency + (data.originalPrice ?? "0")).strikeThrough()
        self.lblBrand.text = data.brand
        
        if let img = data.productImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
    }
    
    // --------------------------------------------
    
    func setBundleProductCart(data: BundleProductModel) {
        if let img = data.storeImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .avatarStore
        }
        self.lblProductName.text = data.pruductName
        self.lblPrice.text = kCurrency + (data.discountPrice ?? "0")
        self.lblOriginalPrice.attributedText = (kCurrency + (data.price ?? "0")).strikeThrough()
        self.lblBrand.text = data.brandName
    }
}

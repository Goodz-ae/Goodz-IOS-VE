//
//  OrderDetailCell.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import UIKit

class OrderDetailCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductname: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom mathods
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblProductname.font(font: .medium, size: .size14)
        self.lblProductname.color(color: .themeBlack)
        
        self.lblBrandName.font(font: .regular, size: .size12)
        self.lblBrandName.color(color: .themeGray)
        
        self.lblPrice.font(font: .medium, size: .size14)
        self.lblPrice.color(color: .themeBlack)
        
        self.lblOriginalPrice.font(font: .regular, size: .size12)
        self.lblOriginalPrice.color(color: .themeGray)
        self.imgProduct.cornerRadius(cornerRadius: 4.0)
    }
    
    // --------------------------------------------
    
    func configData(model: OrderItem) {
        self.lblProductname.text = model.productName
        self.lblBrandName.text = model.brandTitle
        
        let originalPrice = model.originalPrice ?? "0"
        let discountedPrice = model.discountPrice ?? "0"
        
        if discountedPrice.toDouble() > 0 {
            self.lblPrice.text = kCurrency + (model.discountPrice ?? "")
            self.lblOriginalPrice.attributedText = (kCurrency + (model.originalPrice ?? "")).strikeThrough()
        } else {
            self.lblPrice.text = kCurrency + (model.originalPrice ?? "")
            self.lblOriginalPrice.text = ""
        }
        
        if let url = URL(string: model.productImage ?? "") {
            if url.containsVideo {
                model.productImage?.createVideoThumbnail(completion: { image in
                    self.imgProduct.image = image
                })
            } else {
                self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            }
            
            self.imgProduct.contentMode = .scaleAspectFill
            
        } else {
            self.imgProduct.image = .product
            self.imgProduct.contentMode = .scaleAspectFit
        }
        
        self.imgProduct.border(borderWidth: 1.5, borderColor: .themeGreen)
    }
    
    func configChartBundle(model: ChatProductModel) {
        self.lblProductname.text = model.productName
        self.lblBrandName.text = model.brand
        
        let originalPrice = (model.orignialPrice?.description ?? "")
        let discountedPrice = (model.discountedPrice?.description ?? "")
        
        if discountedPrice.toDouble() > 0 {
            self.lblPrice.text = kCurrency + discountedPrice
            self.lblOriginalPrice.attributedText = (kCurrency + originalPrice).strikeThrough()
        } else {
            self.lblPrice.text = kCurrency + originalPrice
            self.lblOriginalPrice.text = ""
        }
        
        if let url = URL(string: model.productImg ?? "") {
            if url.containsVideo {
                model.productImg?.createVideoThumbnail(completion: { image in
                    self.imgProduct.image = image
                })
            } else {
                self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            }
            
            self.imgProduct.contentMode = .scaleAspectFill
            
        } else {
            self.imgProduct.image = .product
            self.imgProduct.contentMode = .scaleAspectFit
        }
        
        self.imgProduct.border(borderWidth: 1.5, borderColor: .themeGreen)
    }
}

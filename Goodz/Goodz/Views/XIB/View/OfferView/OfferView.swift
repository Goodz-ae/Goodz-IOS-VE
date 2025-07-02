//
//  OfferView.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

class OfferView: UIView {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    /// Offer Title
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblOfferTitle: UILabel!
    
    /// Product Data
    @IBOutlet weak var viewProductData: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    
    /// Price Data
    @IBOutlet weak var viewPrice: UIView!
    
    @IBOutlet weak var lblOriginalPrice: UILabel!
    /// Action Buttons
    @IBOutlet weak var lblProceedCheckout: UILabel!
    @IBOutlet weak var lblAcceptOffer: UILabel!
    @IBOutlet weak var lblDecline: UILabel!
    @IBOutlet weak var lblProposedPrice: UILabel!
    @IBOutlet weak var lblSellingFee: UILabel!
    @IBOutlet weak var lblForYouPrice: UILabel!
    
    @IBOutlet weak var viewBundle: UIView!
    @IBOutlet weak var lblBundleCount: UILabel!
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------

    func setUp() {
        self.lblBundleCount.font(font: .medium, size: .size16)
        self.lblProductName.font(font: .medium, size: .size16)
        self.lblMrp.font(font: .semibold, size: .size16)
        self.lblProceedCheckout.font(font: .semibold, size: .size16)
    }
    
    // --------------------------------------------
    
    func setUserType(userType: UserType) {
        self.lblOfferTitle.isHidden = userType == .buyer
        self.viewPrice.isHidden = userType == .buyer
        self.lblAcceptOffer.isHidden = userType == .buyer
        self.lblDecline.isHidden = userType == .buyer
        self.lblProceedCheckout.isHidden = userType == .seller
    }
    
    // --------------------------------------------
    
    func setProductDetails(chatMainResponse : ChatMainResponse?, data: ChatProductModel, userType: UserType, name : String = "", productCount: Int) {
        if chatMainResponse?.isBundleChat == "2" {
            self.viewBundle.isHidden = true
            self.lblBundleCount.text = "+\(productCount - 1)"
        } else {
            self.viewBundle.isHidden = true
        }
        
        self.lblProductName.text =  chatMainResponse?.isBundleChat == "2" ? Labels.bundleProducts : data.productName
        self.lblMrp.text = (kCurrency + (chatMainResponse?.bundleSellingPrice ?? "0"))
        self.lblOriginalPrice.text = kCurrency + (data.newOfferPrice?.description ?? "0")
        if let img = data.productImg, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.lblOfferTitle.text = name + " " + Labels.haveSendAnewOffer
        self.lblProposedPrice.text = kCurrency + (data.newOfferPrice?.description ?? "")
        self.lblSellingFee.text = kCurrency + (data.sellingFee ?? "")
        self.lblForYouPrice.text = kCurrency + (data.forYouPrice?.description ?? "")
        self.lblOfferTitle.isHidden = userType == .buyer
        self.viewPrice.isHidden = userType == .buyer
        self.lblAcceptOffer.isHidden = userType == .buyer
        self.lblDecline.isHidden = userType == .buyer
        self.lblProceedCheckout.isHidden = userType == .seller
    }
    
    // --------------------------------------------
    
}

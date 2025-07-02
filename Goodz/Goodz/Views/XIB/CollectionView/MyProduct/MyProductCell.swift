//
//  MyProductCell.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import UIKit

class MyProductCell: UICollectionViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var originalPrice : UILabel!
    @IBOutlet weak var btnBoost: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var vwpin: UIView!
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var vwLike: UIView!
    @IBOutlet weak var btnPending: UIButton!
    
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
        self.viewImg.cornerRadius(cornerRadius: 3)
        self.imgProduct.image = .avatarStore
        self.btnAdd.isHidden = true
        self.vwpin.isHidden = true
        self.btnPending.isHidden = true
        
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        
        [self.lblProductName, self.lblPrice].forEach {
            $0?.font(font: .medium, size: .size14)
            $0?.color(color: .themeBlack)
        }
        self.btnPending.font(font: .medium, size: .size14)
        //self.btnPending.color(color: .themeBlack)
        
        self.lblStoreName.font(font: .regular, size: .size12)
        self.lblStoreName.color(color: .themeGray)
        
        self.originalPrice.font(font: .regular, size: .size14)
        self.originalPrice.color(color: .themeGray)
        
        self.lblLikes.font(font: .regular, size: .size12)
        
        self.btnBoost.cornerRadius(cornerRadius: 4.0)
        self.btnAdd.cornerRadius(cornerRadius: 4.0)
        
        [self.btnBoost, self.btnAdd].forEach {
            $0?.font(font: .medium, size: .size12)
            $0?.color(color: .themeBlack)
        }
    }
    
    // --------------------------------------------
    

    //    func setData(data: ProductsModel) {
    //        self.btnAdd.isHidden = true
    //        self.lblStoreName.text = data.store
    //        self.lblProductName.text = data.productName
    //        self.lblPrice.text = data.price.isEmpty
    //        self.imgProduct.image = data.productImage
    //        self.originalPrice.attributedText = data.originalPrice.strikeThrough()
    //        if data.isBoosted {
    //            self.btnBoost.setTitle(Labels.boosted, for: .normal)
    //            self.btnBoost.setImage(UIImage(), for: .normal)
    //            self.btnBoost.border(borderWidth: 1.5, borderColor: .themeGreen)
    //            self.btnBoost.backgroundColor = .white
    //        } else if data.isHidden {
    //            self.btnBoost.setTitle(Labels.hidden, for: .normal)
    //            self.btnBoost.backgroundColor = .themeGrayOne
    //        } else {
    //            self.btnBoost.setTitle(Labels.boost, for: .normal)
    //            self.btnBoost.setImage(.iconLight, for: .normal)
    //            self.btnBoost.backgroundColor = .themeGreen
    //        }
    //    }
    
    // --------------------------------------------
    
    func setOtherUserStoreDetailsData(data: ProductListModel, type : OrderDetials) {
        
        self.ivHeart.image = data.isFav == Status.one.rawValue ? .icHeartFill : .icHeart
        self.btnAdd.isHidden = true
        self.lblStoreName.text = data.brand
        self.lblProductName.text = (data.productName ?? "") + (data.pruductName ?? "")
        if let np = Double(data.discountedPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.discountedPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.originalPrice ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.originalPrice ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.discountedPrice ?? Status.zero.rawValue) == Double(data.originalPrice ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }

        self.lblLikes.text = data.totalLike
        
        if let img = data.productImg , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        
        if data.isHidden == Status.one.rawValue {
            self.btnBoost.setTitle(Labels.hidden, for: .normal)
            self.btnBoost.setImage(UIImage(), for: .normal)
            self.btnBoost.border(borderWidth: 1.5, borderColor: .themeGrayOne)
            self.btnBoost.backgroundColor = .themeGrayOne
        } else if data.isBoost == Status.one.rawValue {
            self.btnBoost.setTitle(Labels.boosted, for: .normal)
            self.btnBoost.setImage(UIImage(), for: .normal)
            self.btnBoost.border(borderWidth: 1.5, borderColor: .themeGreen)
            self.btnBoost.backgroundColor = .white
        } else {
            self.btnBoost.setTitle(Labels.boost, for: .normal)
            self.btnBoost.setImage(.iconLight, for: .normal)
            self.btnBoost.backgroundColor = .themeGreen
            self.btnBoost.setTitleColor(.themeWhite, for: .normal)
        }
        self.vwLike.isHidden = type == .myOrderList
        self.vwpin.isHidden = type == .sellerBuyList
        let proUser = (appUserDefaults.getValue(.isProUser) ?? false)
        if proUser {
            if type == .myOrderList {
                self.vwpin.isHidden = data.isPin != Status.one.rawValue
            } else {
                self.vwpin.isHidden = true
            }
        } else {
            self.vwpin.isHidden = true
        }
        if type == .myOrderList {
            if data.isProductVerified == Status.zero.rawValue {
                self.btnPending.setTitle(Labels.pending, for: .normal)
                self.btnPending.isHidden = false
                self.btnBoost.isHidden = true
                self.btnPending.backgroundColor = .themeGrayOne
                self.btnPending.setTitleColor(.themeBlack, for: .normal)
            } else if data.isProductVerified == Status.two.rawValue {
                self.btnPending.isHidden = false
                self.btnPending.setTitle(Labels.rejected, for: .normal)
                self.btnBoost.isHidden = true
                self.btnPending.backgroundColor = .themeRed
                self.btnPending.setTitleColor(.themeWhite, for: .normal)
            } else if data.isProductVerified == Status.one.rawValue {
                self.btnPending.isHidden = true
                self.btnPending.setTitle(Labels.approved, for: .normal)
                self.btnPending.backgroundColor = .themeGreen
                self.btnPending.setTitleColor(.themeWhite, for: .normal)
                self.btnBoost.isHidden = false
            }
        }
    }
    

    
    // --------------------------------------------
    
    func setProductData(data: ProductModel) {
        self.vwLike.isHidden = data.isOwner == Status.one.rawValue
        self.ivHeart.image = data.isFav == Status.one.rawValue ? .icHeartFill : .icHeart
        self.btnBoost.isHidden = true
        if let img = data.productImg , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.lblLikes.text = data.totalLike
        self.lblProductName.text = data.productName
        self.lblStoreName.text = data.brand
        let np = (data.newPrice ?? Status.zero.rawValue).isEmpty ? ( Status.zero.rawValue) : (data.newPrice ?? Status.zero.rawValue)
        self.lblPrice.text = kCurrency + (np)
        let p = (data.price ?? Status.zero.rawValue).isEmpty ? "0" : (data.price ?? Status.zero.rawValue)
        self.originalPrice.attributedText = (kCurrency + (p)).strikeThrough()
        self.btnAdd.isHidden = true

        if let np = Double(data.newPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.newPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.price ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.price ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.newPrice ?? Status.zero.rawValue) == Double(data.price ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }
        
    }
    
    // --------------------------------------------
    
    func setFavProductData(data: MyFavouriteModel) {
        self.lblStoreName.text = data.brand
        self.lblProductName.text = kCurrency + (data.productName ?? Status.zero.rawValue)
        self.lblPrice.text = kCurrency + (data.newPrice ?? Status.zero.rawValue)
        if let img = data.productImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.originalPrice.attributedText = (kCurrency +  (data.price ?? Status.zero.rawValue)).strikeThrough()
        self.btnBoost.isHidden = true
        self.btnAdd.isHidden = true
        self.lblLikes.text = data.likecount
        self.ivHeart.image = .icHeartFill
        if let np = Double(data.newPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.newPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.price ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.price ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.newPrice ?? Status.zero.rawValue) == Double(data.price ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }
        
    }
    
    // --------------------------------------------
    
    func setBundleProducts(data : BundleProductModel) {
        self.ivHeart.image = data.isFav == Status.one.rawValue ? .icHeartFill : .icHeart
        self.lblLikes.text = data.likecount
        self.lblStoreName.text = data.brandName
        self.lblProductName.text = data.pruductName
        self.lblPrice.text = kCurrency +  (data.discountPrice ?? "0")
        if let img = data.storeImage , let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .avatarStore)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .avatarStore
        }
        self.originalPrice.attributedText = (kCurrency +  (data.price ?? "0")).strikeThrough()
        self.btnBoost.isHidden = true
        self.btnAdd.isHidden = false
        if data.isAdded == "0" {
            self.btnAdd.setTitle(Labels.add, for: .normal)
            self.btnAdd.backgroundColor = .themeGreen
            self.btnAdd.setTitleColor(.themeBlack, for: .normal)
        } else {
            self.btnAdd.setTitle(Labels.kRemove, for: .normal)
            self.btnAdd.backgroundColor = .themeRedBG
            self.btnAdd.setTitleColor(.themeRed, for: .normal)
        }

        if let np = Double(data.discountPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.discountPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.price ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.price ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.discountPrice ?? Status.zero.rawValue) == Double(data.price ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }

    }
    
    // --------------------------------------------
    
    func setHomeData(data: ProductList) {
        if let img = data.imgProduct, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.ivHeart.image = data.isLike == "0" ? .icHeart : .icHeartFill
        self.lblLikes.text = data.totalLike
        self.lblStoreName.text = data.brandName
        self.lblPrice.text = kCurrency +  (data.discountedPrice ?? "0")
        self.originalPrice.attributedText = (kCurrency +  (data.price ?? "0")).strikeThrough()
        self.lblProductName.text = data.name
        self.btnAdd.isHidden = true
        self.btnBoost.isHidden = true
        self.vwLike.isHidden = data.isOwner == Status.one.rawValue

        if let np = Double(data.discountedPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.discountedPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.price ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.price ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.discountedPrice ?? Status.zero.rawValue) == Double(data.price ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }
    }
    
    // --------------------------------------------
    
    func setSimilarProduct(data: SimilarProductModel) {
        if let img = data.productImg, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
//            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.ivHeart.image = data.isFav == "0" ? .icHeart : .icHeartFill
        self.lblLikes.text = data.totalLike
        self.lblStoreName.text = data.brand
        self.lblPrice.text = kCurrency + (data.newPrice ?? "0")
        self.originalPrice.attributedText = (kCurrency + (data.price ?? "0")).strikeThrough()
        self.lblProductName.text = data.productName
        self.btnAdd.isHidden = true
        self.btnBoost.isHidden = true
        
        self.vwLike.isHidden = data.isOwner == Status.one.rawValue
        if let np = Double(data.newPrice ?? Status.zero.rawValue) , np > 0 {
            self.lblPrice.text = kCurrency + (data.newPrice ?? Status.zero.rawValue)
        } else {
            self.lblPrice.text = ""
        }
        if let price = Double(data.price ?? Status.zero.rawValue), price > 0 {
            self.originalPrice.attributedText = (kCurrency + (data.price ?? Status.zero.rawValue)).strikeThrough()
            self.originalPrice.isHidden = false
        } else {
            self.originalPrice.isHidden = true
        }
        
        if Double(data.newPrice ?? Status.zero.rawValue) == Double(data.price ?? Status.zero.rawValue) {
            self.originalPrice.isHidden = true
        }
    }
    
    // --------------------------------------------
}

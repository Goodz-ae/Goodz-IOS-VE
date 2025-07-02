//
//  OrderCell.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import UIKit


class OrderCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblBundle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnOrderDetails: SmallGreenButton!
    
    @IBOutlet weak var btnBoost: UIButton!
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.imgProduct.cornerRadius(cornerRadius: 2.0)
        self.imgProduct.border(borderWidth: 1.5, borderColor: .themeGreen)
        
        self.productName.font(font: .regular, size: .size14)
        self.productName.color(color: .themeBlack)
        
        self.lblDeliveryDate.font(font: .regular, size: .size12)
        self.lblDeliveryDate.color(color: .themeGray)
        
        self.lblBundle.font(font: .regular, size: .size12)
        self.lblBundle.color(color: .themeBlack)
        
        self.lblPrice.font(font: .medium, size: .size14)
        self.lblPrice.color(color: .themeBlack)
        
        self.lblStatus.font(font: .regular, size: .size12)
        self.lblStatus.color(color: .themeBlack)
        
        self.btnOrderDetails.title(title: Labels.orderDetails)
        
        self.btnBoost.font(font: .medium, size: .size12)
        self.btnBoost.color(color: .themeBlack)
        self.btnBoost.cornerRadius(cornerRadius: 4.0)
        
        self.lblBundle.text = Labels.bundle
        
    }
    
    // --------------------------------------------
    
    func setOrderData(data: OrderListResult, lastRow: Int, currentRow: Int) {
        self.btnBoost.isHidden = true
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        self.lblPrice.text = kCurrency + " " + (data.price ?? "")
        self.lblStatus.text = data.status
        
        let deliveryDate = data.deliveryDate?.UTCToLocal(inputFormat: DateFormat.apiDateFormate_ymd_Hms, outputFormat: DateFormat.appDateFormateMMddYYY) ?? ""
        self.lblDeliveryDate.text = deliveryDate == "" ? "" : (Labels.deliveredOn + " : " + deliveryDate)
        
        if data.orderType == Status.one.rawValue {
            lblBundle.isHidden = false
        }else{
            lblBundle.isHidden = true
        }
        
        self.productName.text = data.productName
        
        if let url = URL(string: data.productImage ?? "") {
            if url.containsVideo {
                data.productImage?.createVideoThumbnail(completion: { image in
                    self.imgProduct.image = image
                })
            } else {
                self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            } 
        } else {
            self.imgProduct.image = .product
        }
        
        if data.paymentStatus == "1" && data.status == "Delivered" {
            self.lblDeliveryDate.isHidden = false
        }else{
            self.lblDeliveryDate.isHidden = true
        }
        
        self.imgProduct.contentMode = .scaleAspectFill
        self.imgProduct.border(borderWidth: 1.5, borderColor: .themeGreen)
        self.imgCheck.isHidden = data.status != Labels.completed
    }
    
    // --------------------------------------------
    
    func setSellData(data: SellListResult, lastRow: Int, currentRow: Int) {
        self.btnBoost.isHidden = true
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        self.lblPrice.text = kCurrency + " " + (data.price ?? "")
        self.lblStatus.text = data.status
        self.lblDeliveryDate.text = data.deliveryDate?.UTCToLocal(inputFormat: DateFormat.apiDateFormate_ymd_Hms, outputFormat: DateFormat.appDateFormateMMddYYY)
        self.productName.text = data.productName
        
        if data.orderType == Status.one.rawValue {
            lblBundle.isHidden = false
        }else{
            lblBundle.isHidden = true
        }
        
        if let url = URL(string: data.productImage ?? "") {
            if url.containsVideo {
                data.productImage?.createVideoThumbnail(completion: { image in
                    self.imgProduct.image = image
                })
            } else {
                self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            }
        } else {
            self.imgProduct.image = .product
        }
        
        if data.paymentStatus == "1" && data.status == "Delivered" {
            self.lblDeliveryDate.isHidden = false
        }else{
            self.lblDeliveryDate.isHidden = true
        }
        
        self.imgCheck.isHidden = data.status != "Completed"
    }
    
    // --------------------------------------------
    
    func setAdsItems(data: MyAdsModel, lastRow: Int, currentRow: Int) {
        self.lblBundle.isHidden = true
        self.lblStatus.isHidden = true
        self.imgCheck.isHidden = true
        self.btnOrderDetails.isHidden = true
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        self.lblPrice.text =  kCurrency + " " + (data.discountedPrice ?? "")
        if let remainingDays = data.remainingDaysOfBoost, remainingDays != "0" {
            self.lblDeliveryDate.text = Labels.active + " - " + remainingDays + Labels.daysRemaining
        } else {
            self.lblDeliveryDate.text = Labels.notActive
        }
        
        lblDeliveryDate.textColor = .themeDarkGray
        
        self.productName.text = data.productName
        
        if let url = URL(string: data.productImage ?? "") {
            if url.containsVideo {
                data.productImage?.createVideoThumbnail(completion: { image in
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

        
        if data.isBoosted == Status.one.rawValue {
            self.btnBoost.setTitle(Labels.boosted, for: .normal)
            self.btnBoost.setImage(UIImage(), for: .normal)
            self.btnBoost.cornerRadius(cornerRadius: 4.0)
            self.btnBoost.backgroundColor = .themeWhite
            self.btnBoost.border(borderWidth: 1, borderColor: .themeGreen)
        } else {
            self.btnBoost.setTitle(Labels.boost, for: .normal)
            self.btnBoost.setImage(.iconLight, for: .normal)
            self.btnBoost.backgroundColor = .themeGreen
            self.btnBoost.border(borderWidth: 1, borderColor: .themeGreen)
        }
    }
    
    func setInvoicesData(data: MyInvoiceModel, lastRow: Int, currentRow: Int) {
        self.lblBundle.isHidden = true
        self.lblStatus.isHidden = true
        self.imgCheck.isHidden = true
        self.btnBoost.isHidden = true
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        self.lblPrice.setStrikethrough(normalText: kCurrency + (data.discountedPrice ?? "0"), text: kCurrency + (data.originalPrice ?? "0"))
        //        self.lblStatus.text = data.status
        //        self.lblDeliveryDate.text = data.date
        self.productName.text = data.productName
        self.lblDeliveryDate.isHidden = true
        if let img = data.productImage, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        self.btnOrderDetails.setTitle(Labels.downloadInvoice, for: .normal)
    }
    
}

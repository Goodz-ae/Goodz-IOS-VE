//
//  MyAccountCell.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import UIKit

class MyAccountCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    // MARK: - Initial Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // MARK: - Custom variables
    private func applyStyle() {
        self.selectionStyle = .none
        self.lblTitle.font(font: .medium, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        self.btnRight.isUserInteractionEnabled = false
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblNotificationCount.font(font: .medium, size: .size16)
        self.lblNotificationCount.color(color: .themeWhite)
        self.lblNotificationCount.backgroundColor = .themeRed
        self.lblNotificationCount.cornerRadius(cornerRadius: 10)
        self.lblNotificationCount.isHidden = true
    }
    
    func setMyaccountData(rightIcon : Bool = true, data: AccountMenuOptions, lastRow : Int, currentRow : Int) {
        self.imgTitle.image = data.icon
        self.lblTitle.text = data.title
        if rightIcon {
            self.btnRight.setImage(data.rightIcon, for: .normal)
            
        } else {
            self.btnRight.setImage(UIImage(), for: .normal)
        }
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        if data.title == Labels.notifications {
                let n = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.unreadNotification ?? ""
            if !n.isEmpty  {
                if n.toDouble() > 0 ||  n != "0" {
                    self.lblNotificationCount.text = n
                    self.lblNotificationCount.isHidden = false
                    self.lblNotificationCount.round()
                } else {
                    self.lblNotificationCount.isHidden = true
                }
            }
        } else {
            self.lblNotificationCount.isHidden = true
           
        }
    }
    
    func setMyaccountData(data: SettingMenuOptions, lastRow : Int, currentRow : Int) {
        self.imgTitle.image = data.icon
        self.lblTitle.text = data.title
        self.btnRight.setImage(data.rightIcon, for: .normal)
        
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        
        if data == .logout || data == .deleteAccount {
            self.btnRight.isHidden = true
        } else {
            self.btnRight.isHidden = false
        }
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        
    }
    
    func setProductTypeData(data: SellVCProductInfoType, lastRow : Int, currentRow : Int) {
        self.imgTitle.image = data.image
        self.lblTitle.text = data.title
        self.imgTitle.tintColor = .themeBlack
        self.lblDescription.isHidden = false
        self.btnRight.isHidden = !data.forwardArrow
        self.imgTitle.isHidden = data.image == nil
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        
    }
    
    /// Filter list setup
    func setFilterData(data: FilterDataModel, lastRow : Int, currentRow : Int) {
        self.imgTitle.isHidden = true
        self.lblTitle.text = data.title
        self.imgTitle.tintColor = .themeBlack
        
        if !(data.description?.isEmpty ?? false) {
            self.lblDescription.text = data.description
            self.lblDescription.isHidden = false
        } else {
            self.lblDescription.isHidden = true
        }
        
        self.btnRight.isHidden = false
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        
    }
    
    /// api calling
    
    func setViews(lastRow : Int, currentRow : Int) {
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
    }
    func setCategory(data: CategoryMainModel, lastRow : Int, currentRow : Int) {
        if data.categoriesMainId == "-1" {
            self.imgTitle.image = UIImage(named: "ic_all")
        } else if let img = data.categoriesMainImage, let url = URL(string: img) {
            self.imgTitle.sd_setImage(with: url, placeholderImage: .product)
            self.imgTitle.contentMode = .scaleAspectFill
        } else {
            self.imgTitle.image = .product
        }
        
        self.lblTitle.text = data.categoriesMainTitle
        self.imgTitle.tintColor = .themeBlack
        self.lblDescription.isHidden = true
        self.btnRight.isHidden = false
        self.setViews(lastRow: lastRow, currentRow: currentRow)
    }
    
    func setSubCategory(data: CategorySubModel, lastRow : Int, currentRow : Int) {
        if let img = data.categoriesSubImage , let url = URL(string: img) {
            self.imgTitle.sd_setImage(with: url, placeholderImage: .product)
            self.imgTitle.contentMode = .scaleAspectFill
        } else {
            self.imgTitle.image = .product
        }
        
        self.lblTitle.text = data.categoriesSubTitle
        self.imgTitle.tintColor = .themeBlack
        self.lblDescription.isHidden = true
        self.btnRight.isHidden = false
        self.setViews(lastRow: lastRow, currentRow: currentRow)
    }
    
    func setSubCollectionCategory(data: CategoryCollectionModel, lastRow : Int, currentRow : Int) {
        self.imgTitle.isHidden = true
        self.lblTitle.text = data.categoryCollectionTitle
        self.imgTitle.tintColor = .themeBlack
        self.lblDescription.isHidden = true
        self.btnRight.isHidden = true
        self.setViews(lastRow: lastRow, currentRow: currentRow)
    }
}

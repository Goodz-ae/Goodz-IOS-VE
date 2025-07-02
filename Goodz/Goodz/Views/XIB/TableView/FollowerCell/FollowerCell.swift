//
//  FollowerCell.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import UIKit

class FollowerCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivForward: UIImageView!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnFollowing: SmallGreenBorderButton!
    @IBOutlet weak var lblTotalItems: UILabel!
    @IBOutlet weak var imgPro : UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
        self.lblTotalItems.isHidden = true
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.imgProfile.image = .avatarStore
        self.imgPro.isHidden = true
        self.btnRate.cornerRadius(cornerRadius: 2)
        self.btnRate.font(font: .medium, size: .size12)
        self.btnRate.color(color: .themeBlack)
        
        self.imgProfile.cornerRadius(cornerRadius: self.imgProfile.frame.height / 2)
        self.imgProfile.border(borderWidth: 2, borderColor: .themeGreen)
        
        self.lblName.font(font: .regular, size: .size16)
        self.lblName.color(color: .themeBlack)
        
        self.lblTotalItems.font(font: .medium, size: .size12)
        self.lblTotalItems.color(color: .themeGray)
        
        self.btnFollowing.cornerRadius(cornerRadius: 4.0)
        self.btnFollowing.border(borderWidth: 1, borderColor: .themeGreen)
        
    }
    
    // --------------------------------------------
    
    func setData(data: StoreFollowerModel, lastRow: Int, currentRow: Int) {
        let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
        self.btnFollowing.isHidden = data.storeID == currentUser?.storeID
        self.lblName.text = data.userName
        self.btnRate.setTitle((data.rating ?? "").isEmpty ? "5" : data.rating, for: .normal)
        if let img = data.userProfile, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.imgProfile.contentMode = .scaleAspectFill
        } else {
            self.imgProfile.image = .avatarUser
        }
        
        self.btnFollowing.backgroundColor = data.followStatus == Status.one.rawValue ?  .themeWhite : .themeGreen
        self.btnFollowing.setTitle(data.followStatus == Status.one.rawValue ? Labels.following : Labels.follow, for: .normal)
        
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
    }
    
    // --------------------------------------------
    
    func setStoreData(data: StoreModel, lastRow: Int, currentRow: Int) {
        self.lblName.text = data.storeOwnerName
        self.btnRate.setTitle((data.storeRating ?? "").isEmpty ? "5" : data.storeRating, for: .normal)
        self.btnFollowing.isHidden = true
        self.ivForward.isHidden = false
        if let img = data.storeImage, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgProfile.contentMode = .scaleAspectFill
        } else {
            self.imgProfile.image = .avatarStore
        }
        self.lblTotalItems.isHidden = false
        if (data.numberOfReviews ?? "").isEmpty || (data.numberOfReviews ?? "") == "0" {
            self.lblTotalItems.text = ""
        } else {
            let rev = Int(data.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.lblTotalItems.text = "(" + (data.numberOfReviews ?? "0") + " " + rev + ")"
        }
        self.imgPro.isHidden = data.isGoodzPro != "2"
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
    }
    
    // --------------------------------------------
    
}

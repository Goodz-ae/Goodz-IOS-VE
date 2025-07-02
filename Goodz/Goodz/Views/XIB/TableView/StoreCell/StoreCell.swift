//
//  StoreCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class StoreCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblTotalItems: UILabel!
    @IBOutlet weak var imgPro: UIImageView!
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
        // Initialization code
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.imgStore.image = .avatarStore
        self.lblStoreName.font(font: .medium, size: .size14)
        self.btnRate.cornerRadius(cornerRadius: 2.0)
        self.lblTotalItems.font(font: .regular, size: .size12)
        self.lblTotalItems.color(color: .themeGray)
        self.imgStore.round()
        self.imgStore.border(borderWidth: 1.0, borderColor: .themeGreen)
        self.imgPro.isHidden = true
    }
    
    // --------------------------------------------
    
    func setData(data: StoreModel) {
        
        self.lblStoreName.text = (data.storeOwnerName ?? "") // + (data.storeID == UserDefaults.userID ? " (You)" : "")
        if (data.numberOfReviews ?? "").isEmpty || (data.numberOfReviews ?? "") == "0" {
            self.lblTotalItems.text = ""
        } else {
            let rev = Int(data.numberOfReviews ?? "0") ?? 0 < 2 ? Labels.review : Labels.reviews
            self.lblTotalItems.text = "( " + (data.numberOfReviews ?? "0") + " " + rev + ")"
        }
        self.imgPro.isHidden = data.isGoodzPro != "2"
        self.btnRate.setTitle((data.storeRating ?? "").isEmpty ? "5" : data.storeRating, for: .normal)
        if let img = data.storeImage, let url = URL(string: img) {
            self.imgStore.sd_setImage(with: url, placeholderImage: .avatarStore)
            self.imgStore.contentMode = .scaleAspectFill
        } else {
            self.imgStore.image = .avatarStore
        }
    }
}

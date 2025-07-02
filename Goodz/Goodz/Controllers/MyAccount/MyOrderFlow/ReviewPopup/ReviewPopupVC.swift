//
//  ReviewPopupVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class ReviewPopupVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgUser: ThemeGreenBorderImage!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblReviewDes: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var data : StoreReviewModel?
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.imgUser.image = .avatarUser
        self.vwMain.cornerRadius(cornerRadius: 16.0)
        self.lblReview.font(font: .semibold, size: .size16)
        self.lblReview.color(color: .themeBlack)
        self.lblUserName.font(font: .regular, size: .size16)
        self.lblUserName.color(color: .themeBlack)
        self.lblReviewDes.font(font: .regular, size: .size14)
        self.lblReviewDes.color(color: .themeBlack)
        self.btnRate.font(font: .medium, size: .size12)
        self.btnRate.color(color: .themeBlack)
        self.btnRate.cornerRadius(cornerRadius: 2.0)
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblReview.text = Labels.reviews
        self.lblUserName.text = data?.userName ?? ""
        self.lblReviewDes.text = data?.reviewDescription ?? ""
        self.btnRate.setTitle((data?.rating ?? "").isEmpty ? Status.five.rawValue : data?.rating ?? "", for: .normal)
        if let img = data?.userProfile, let url = URL(string: img) {
            self.imgUser.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.imgUser.contentMode = .scaleAspectFill
        } else {
            self.imgUser.image = .avatarUser
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnStoreDetailsClicked(_ sender: UIButton) {
        if let storeID = data?.storeID {
            self.coordinator?.navigateToPopularStore(storeId: storeID)
        }
        self.dismiss()
    }
}

//
//  ReviewCell.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import UIKit

class ReviewCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: ThemeGreenBorderImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblDescription: ExpandableLabel!
    @IBOutlet weak var btnReply: SmallGreenBorderButton!
    
    // --------------------------------------------
    // MARK: - Intial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.imgProfile.image = .avatarUser
        self.lblName.font(font: .regular, size: .size16)
        self.lblName.color(color: .themeBlack)
        
        self.lblDate.font(font: .regular, size: .size14)
        self.lblDate.color(color: .themeGray)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeGray)
        
        self.btnRate.cornerRadius(cornerRadius: 4.0)
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.lblDescription.collapsed = true
        self.lblDescription.text = nil
        self.btnReply.isHidden = true

    }
    
    // --------------------------------------------
    
    func setData(data: StoreReviewModel, lastRow: Int, currentRow: Int) {
        self.lblDate.setConvertDateString(data.dateOfReview ?? "")
        self.lblName.text = (data.userName ?? "")
        self.btnRate.setTitle((data.rating ?? "").isEmpty ? "5" : data.rating, for: .normal)
        if let img = data.userProfile, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.imgProfile.contentMode = .scaleAspectFill
        } else {
            self.imgProfile.image = .avatarUser
        }
        self.vwSeperator.isHidden = (currentRow == (lastRow - 1))
        
    }
    
    // --------------------------------------------
    
}

extension ReviewCell : ExpandableLabelDelegate {
    func willExpandLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
}

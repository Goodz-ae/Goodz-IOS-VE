//
//  BoostPlanCell.swift
//  Goodz
//
//  Created by Akruti on 13/12/23.
//

import UIKit

class BoostPlanCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var vwClick: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnBestOffer: SmallGreenButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblClick: UILabel!
    
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
    
    private func applyStyle() {
        self.btnSelect.font(font: .regular, size: .size14)
        self.btnSelect.color(color: .themeBlack)
       
        DispatchQueue.main.async {
            self.btnBestOffer.cornerRadius(cornerRadius: self.btnBestOffer.frame.height / 2)
            self.btnBestOffer.backgroundColor = .themeGoodz
        }
        
        self.lblPrice.font(font: .medium, size: .size16)
        self.lblPrice.color(color: .themeBlack)
        self.lblClick.font(font: .medium, size: .size12)
        self.lblClick.color(color: .themeBlack)
        
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.vwMain.border(borderWidth: 1.0, borderColor: .themeBorder)
        self.btnSelect.setImage(.iconCircle, for: .normal)
        self.btnSelect.setImage(.iconCircleFill, for: .selected)
    }
    
    // --------------------------------------------
    
    func setBoostPlanData(data: BoostPlan) {
        self.lblClick.text = Labels.reach_Estimation + " " +  (data.clicks ?? Status.zero.rawValue) + " " + Labels.clicksOnYourApplication
        self.lblPrice.text = kCurrency + (data.price ?? Status.zero.rawValue)
        self.btnSelect.setTitle(data.boostPlan, for: .normal)
        self.btnBestOffer.isHidden = (data.isBestOffer == Status.one.rawValue ? false : true)
    }
    
}

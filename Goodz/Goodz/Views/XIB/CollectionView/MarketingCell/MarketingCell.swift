//
//  MarketingCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class MarketingCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lnlOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var lblThree: UILabel!
    @IBOutlet weak var lblTFour: UILabel!
    @IBOutlet weak var lblFive: UILabel!
    @IBOutlet weak var lblSix: UILabel!
    @IBOutlet weak var lblKg: UILabel!
    @IBOutlet weak var btnLearnMore: UIButton!
    
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
        self.lblTitle.font(font: .semibold, size: .size22)
        self.lblTitle.color(color: .themeWhite)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeWhite)
        
        self.lblTwo.font(font: .semibold, size: .size20)
        self.lblTwo.color(color: .themeBlack)
        
        self.lnlOne.font(font: .semibold, size: .size20)
        self.lnlOne.color(color: .themeBlack)
        
        self.lblThree.font(font: .semibold, size: .size20)
        self.lblThree.color(color: .themeBlack)
        
        self.lblTFour.font(font: .semibold, size: .size20)
        self.lblTFour.color(color: .themeBlack)
        
        self.lblFive.font(font: .semibold, size: .size20)
        self.lblFive.color(color: .themeBlack)
        
        self.lblSix.font(font: .semibold, size: .size20)
        self.lblSix.color(color: .themeBlack)
        
        self.lblKg.font(font: .semibold, size: .size14)
        self.lblKg.color(color: .themeBlack)
         
      //  lblDescription.textColor = .themeWhite
        lblTwo.textColor = .themeGreen
        lnlOne.textColor = .themeGreen
        lblThree.textColor = .themeGreen
        lblTFour.textColor = .themeGreen
        lblFive.textColor = .themeGreen
        self.lblSix.textColor = .themeGreen
        self.lblKg.textColor = .themeWhite
        
        self.btnLearnMore.color(color: .themeBlack)
        self.btnLearnMore.font(font: .bold, size: .size12)
        self.btnLearnMore.cornerRadius(cornerRadius: 4.0)
        self.lnlOne.cornerRadius(cornerRadius: 20.0)
        self.lblTwo.cornerRadius(cornerRadius: 4.0)
        self.lblThree.cornerRadius(cornerRadius: 4.0)
        self.lblTFour.cornerRadius(cornerRadius: 4.0)
        self.lblFive.cornerRadius(cornerRadius: 4.0)
        self.lblSix.cornerRadius(cornerRadius: 4.0)
        
        self.lblTitle.text = Labels.buyYourFurnitureResponsively
        self.lblDescription.text = Labels.aLittleGestureForThePlanetMakesBigDifferences
        self.lblKg.text = Labels.kgOfWoodSavedToday
    }
    
}

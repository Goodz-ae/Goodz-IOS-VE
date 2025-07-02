//
//  ProBenefitCell.swift
//  Goodz
//
//  Created by vtadmin on 19/12/23.
//

import UIKit

class ProBenefitCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
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
        self.mainView.cornerRadius(cornerRadius: 4.0)
        self.lblTitle.font(font: .medium, size: .size14)
        self.lblDescription.font(font: .regular, size: .size12)
    }
}

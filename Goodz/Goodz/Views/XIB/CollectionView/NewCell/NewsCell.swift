//
//  NewsCell.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import UIKit

class NewsCell: UICollectionViewCell {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial Mwthods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblTitle.font(font: .medium, size: .size14)
        self.lblTitle.color(color: .themeBlack)
        self.lblDescription.font(font: .regular, size: .size12)
        self.lblDescription.color(color: .themeGray)
        self.imgProduct.cornerRadius(cornerRadius: 2.0)
        self.vwMain.cornerRadius(cornerRadius: 4.0)
    }
}

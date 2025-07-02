//
//  CustomizationCell.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import UIKit

class CustomizationCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgRight: UIImageView!
    
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
        self.lblTitle.font(font: .medium, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeGray)
    }
    
    func setDataCustomization(data: CategoryMainModel,lastRow: Int, currentRow: Int) {
        self.lblTitle.text = data.categoriesMainTitle
        // self.lblDescription.text = data.description
        if let img = data.categoriesMainImage, let url = URL(string: img) {
            if let url = URL(string: img) {
                self.imgTitle.sd_setImage(with: url, placeholderImage: .product)
            } else {
                self.imgTitle.image = .product
            }
        }
        self.vwSeperator.isHidden = lastRow == currentRow
    }
    
}

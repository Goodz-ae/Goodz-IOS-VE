//
//  CommitmentsCell.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import UIKit

class CommitmentsCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    
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
        self.lblTitle.font(font: .semibold, size: .size14)
        self.lblTitle.color(color: .themeBlack)
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: CommitmentModel) {
        self.lblTitle.text = data.title
        self.lblDescription.text = data.description
        self.imgNews.image = data.image
    }
}

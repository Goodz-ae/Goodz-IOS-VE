//
//  SortCell.swift
//  Goodz
//
//  Created by vtadmin on 13/12/23.
//

import UIKit

class SortCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom mathods
    // --------------------------------------------
    
    private func applyStyle() {
        lblTitle.font(font: .medium, size: .size12)
       
    }
    
}

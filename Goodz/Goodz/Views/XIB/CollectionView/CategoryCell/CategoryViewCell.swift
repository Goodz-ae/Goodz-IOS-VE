//
//  CategoryViewCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 11/12/23.
//

import UIKit

class CategoryViewCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivCategory: UIImageView!
    @IBOutlet weak var ivDropDown: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

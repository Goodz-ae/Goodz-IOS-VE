//
//  ProductImagesCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 14/12/23.
//

import UIKit

class ProductImagesCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgPlay.isHidden = true
    }

}

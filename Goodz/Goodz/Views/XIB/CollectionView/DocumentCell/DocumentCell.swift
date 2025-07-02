//
//  DocumentCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 15/12/23.
//

import UIKit

class DocumentCell: UICollectionViewCell, Reusable {
   
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivDocument: UIImageView!
    @IBOutlet weak var ivCross: UIImageView!
    @IBOutlet weak var btnDeleteImage: UIButton!
    
    @IBOutlet weak var labelCover : UILabel!
    @IBOutlet weak var viewCover : UIView!
    
    @IBOutlet weak var imgFirst: UIImageView!
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelCover.font(font: .bold, size: .size14)
        self.ivCross.isHidden = true
    }
    
    func setMedia(data: SellItemUploadMediaModel) {
        self.ivCross.isHidden = false
        self.ivDocument.isHidden = false
        self.imgFirst.isHidden = true
        print(data)
        print("Jigz ---- : ", data)
        self.ivDocument.image = UIImage()
        if data.mediaType == "2" {
            
            if let url = data.productMediaURL {
                url.createVideoThumbnail(completion: { image in
                    self.ivDocument.image = image
                })
            }
            
        } else {
        
            if let img = data.productMediaURL, let url = URL(string: img) {
                self.ivDocument.sd_setImage(with: url, placeholderImage: .product)
                self.ivDocument.contentMode = .scaleToFill
            } else {
                self.ivDocument.image = .product
            }
            
        }
        
        self.ivDocument.border(borderWidth: 1, borderColor: .themeGreen)
    }
}

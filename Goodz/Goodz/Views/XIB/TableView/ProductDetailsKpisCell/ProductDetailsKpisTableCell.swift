//
//  ProductDetailsKpisTableCell.swift
//  Goodz
//
//  Created by vtadmin on 20/02/24.
//

import UIKit
import SDWebImage

class ProductDetailsKpisTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static let nib = UINib(nibName: "ProductDetailsKpisTableCell", bundle: nil)
    static let identifier = "ProductDetailsKpisTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(model: ProductKpis) {
        lblTitle.setAttributeString(model.value ?? "", model.description ?? "")
        imageVw.sd_setImage(with: URL(string: model.icon ?? ""))
    }
}

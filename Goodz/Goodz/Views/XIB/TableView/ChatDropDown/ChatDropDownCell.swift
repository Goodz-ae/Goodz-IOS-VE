//
//  ChatDropDownCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

class ChatDropDownCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------

    @IBOutlet weak var lblOptionTitle: UILabel!
    @IBOutlet weak var ivOptionImage: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setUpData(data: ChatDropDownModel) {
        self.lblOptionTitle.text = data.title
        self.ivOptionImage.image = data.image
    }
    
}

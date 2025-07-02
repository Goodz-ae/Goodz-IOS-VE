//
//  RecentSearchCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 27/12/23.
//

import UIKit

class RecentSearchCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivRecentSearch: UIImageView!
    @IBOutlet weak var lblRecentSearch: UILabel!
    @IBOutlet weak var ivCross: UIImageView!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setUp() {
        self.selectionStyle = .none
        self.lblRecentSearch.font(font: .regular, size: .size14)
    }
    
    // --------------------------------------------
    
    func setData(data: String) {
        self.lblRecentSearch.text = data
    }
    
    // --------------------------------------------
    
}

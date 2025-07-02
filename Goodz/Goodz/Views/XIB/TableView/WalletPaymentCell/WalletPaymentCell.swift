//
//  WalletPaymentCell.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import UIKit

class WalletPaymentCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblcardNumber: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    
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
        self.lblcardNumber.font(font: .regular, size: .size16)
        self.lblcardNumber.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: BankCardModel, cuurentRow: Int, lastRow : Int) {
        self.imgCard.image = data.imgCard
        self.lblcardNumber.text = data.cardNumber
        self.vwSeperator.isHidden = cuurentRow == lastRow
    }
    
}

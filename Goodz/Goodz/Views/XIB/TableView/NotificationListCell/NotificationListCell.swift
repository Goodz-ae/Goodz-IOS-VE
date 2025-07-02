//
//  NotificationListCell.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import UIKit

class NotificationListCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var vwSeperator: UIView!
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
 
    private func applyStyle() {
        self.lblTitle.font(font: .regular, size: .size16)
        self.lblTitle.color(color: .themeBlack)
        self.btnSelect.setImage(.switchGray, for: .normal)
        self.btnSelect.setImage(.switchGreen, for: .selected)
        self.btnSelect.isUserInteractionEnabled = false
    }
    
    func setDataNotificationList(data: NotificationListModel, lastRow: Int, currentRow: Int) {
        self.vwSeperator.isHidden = lastRow == currentRow
        self.lblTitle.text = data.title
        self.btnSelect.isSelected = data.status == "0" ? false : true
    }
}

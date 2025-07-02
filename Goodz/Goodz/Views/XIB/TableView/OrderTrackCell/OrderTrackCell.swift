//
//  OrderTrackCell.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import UIKit

class OrderTrackCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwLineUpper: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var vwLineLower: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwLabels: UIStackView!
    
    // --------------------------------------------
    // MARK: - Initial methods -
    // --------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblDate.font(font: .regular, size: .size12)
        self.lblDate.color(color: .themeGray)
        
        self.lblStatus.font(font: .medium, size: .size14)
        self.lblStatus.color(color: .themeBlack)
    }
    
    func setData(data: OrderStatusModel,lastRow: Int, currentRow: Int) {
        if data.isActive == "1" {
            self.lblStatus.color(color: .themeBlack)
            self.vwLineUpper.backgroundColor = .themeGreen
            self.vwLineLower.backgroundColor = .themeGreen
            self.lblDate.isHidden = false
            self.imgStatus.image = .placedSelect
        } else {
            self.lblStatus.color(color: .themeGray)
            self.vwLineUpper.backgroundColor = .themeGray
            self.vwLineLower.backgroundColor = .themeGray
            self.lblDate.isHidden = true
           self.imgStatus.image = .placedDeselect
        }
        self.vwLineLower.isHidden = lastRow == currentRow
        self.lblDate.text = data.date
        self.lblStatus.text = Labels.orderPlaced
    }
}

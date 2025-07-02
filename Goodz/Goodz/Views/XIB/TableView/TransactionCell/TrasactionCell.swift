//
//  TrasactionCell.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import UIKit

class TrasactionCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    
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
    
    func applyStyle() {
        self.lblProductName.font(font: .medium, size: .size14)
        self.lblProductName.color(color: .themeBlack)
        
        self.lblDate.font(font: .regular, size: .size12)
        self.lblDate.color(color: .themeDarkGray)
        
        self.lblAmount.font(font: .medium, size: .size16)
        self.lblAmount.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: WalletTransactionModel) {
        let date = convertDateFormat(dateString: (data.transactionDate ?? "")) ?? (data.transactionDate ?? "")
        self.lblDate.text = "Date:" + " " +  date
        self.lblAmount.text = (data.isCredit == "1" ? "+" : "-") + " " + kCurrency +  (data.walletTransactionAmount ?? "")
        self.lblAmount.color(color: data.isCredit == "1" ? UIColor.themeBlack : UIColor.themeRed)
        self.lblProductName.text = Labels.orderId + ": #" +  (data.orderUniqueID ?? "")
    }
    
    func convertDateFormat(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil // Return nil if the input date string is not in the expected format
        }
    }
}

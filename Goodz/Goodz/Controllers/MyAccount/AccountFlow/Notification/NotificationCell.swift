//
//  NotificationCell.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit
class NotificationCell : UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var vwMain: UIView!
    
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
        self.lblTime.font(font: .regular, size: .size12)
        self.lblTime.color(color: .themeBlack)
        
        self.lblTitle.font(font: .semibold, size: .size14)
        self.lblTitle.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setData(data: NotificationListResult, lastRow: Int, currentRow: Int) {
        self.vwSeperator.isHidden = (lastRow == currentRow)
        self.lblTime.text = data.dateTime?.UTCToLocal(inputFormat: DateFormat.apiDateFormate_ymd_Hms, outputFormat: DateFormat.appDateFormate_hma_MM_dd_YY)
        self.lblTitle.text = data.pushNotificationMessage
        if currentRow == 0 {
            self.vwMain.roundTopCorners(radius: 4)
        } else if currentRow == (lastRow - 1) {
            self.vwMain.roundBottomCorners(radius: 4)
        }
        
        self.vwMain.backgroundColor = data.isRead == Status.one.rawValue ? .themeWhite : .themeGrayOne
    }
    
    // --------------------------------------------
    
}

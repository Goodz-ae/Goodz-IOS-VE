//
//  ConnectionCell.swift
//  Goodz
//
//  Created by Akruti on 18/12/23.
//

import UIKit

class ConnectionCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }

    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.lblPlace.font(font: .medium, size: .size16)
        self.lblPlace.color(color: .themeBlack)
        self.lblDevice.font(font: .medium, size: .size12)
    }
    
    func setData(data: ConnectionsModel) {
        if data.currentLogin == "1" {
            self.lblDevice.color(color: .themeGreen)
            self.lblDevice.text = Labels.currentDevice + " " + (data.device ?? "").setComma() + Labels.now
        } else {
            self.lblDevice.color(color: .themeGray)
            let dateTime = (data.dateTime ?? "").dateFormateChange(currDateFormate: DateFormat.apiDateFormate_ymd_Hms, needStringDateFormate: DateFormat.appDateFormate_MM_dd_YY_hma)
            self.lblDevice.text = dateTime.setComma() + (data.device ?? "")
        }
        
        self.lblPlace.text = data.place
    }
}

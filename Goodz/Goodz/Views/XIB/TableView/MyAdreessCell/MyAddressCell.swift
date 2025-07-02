//
//  MyAddressCell.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import UIKit

class MyAddressCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var vwSelect: UIStackView!
    @IBOutlet weak var lblDefault: UILabel!
    
    
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
        
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        
        self.lblUsername.font(font: .medium, size: .size14)
        self.lblUsername.color(color: .themeBlack)
        self.lblDefault.font(font: .medium, size: .size14)
        self.lblDefault.color(color: .themeBlack)
        
        self.lblAddress.font(font: .regular, size: .size14)
        self.lblAddress.color(color: .themeGray)
        
        self.lblMobile.font(font: .regular, size: .size14)
        self.lblMobile.color(color: .themeGray)
        
        self.btnSelect.setImage(.iconCircle, for: .normal)
        self.btnSelect.setImage(.iconCircleFill, for: .selected)
        
    }
    
    // --------------------------------------------
    
    func setData(data: MyAddressModel , isSelectType : Bool) {
        self.btnSelect.isHidden = !isSelectType
        let add1 = setString(str:(data.floor ?? "")) + ", " + setString(str:(data.streetAddress ?? "")) + ", "
        let add2 = (data.area ?? "") + ", " + (data.city ?? "")
        self.lblAddress.text = add1 + add2
        self.lblMobile.text = (data.countryCode ?? "") + (data.mobile ?? "")
        self.lblUsername.text = setString(str:data.fullName ?? "")
        self.lblDefault.isHidden = data.isDefault != "1"
        self.btnDelete.isHidden = data.isDefault == "1"
    }
    
    // --------------------------------------------
    func setString(str: String) -> String {
        return String(str.prefix(1)).uppercased() + String(str.dropFirst())
    }
}

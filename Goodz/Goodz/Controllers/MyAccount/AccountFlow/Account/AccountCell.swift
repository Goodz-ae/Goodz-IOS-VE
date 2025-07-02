//
//  AccountCell.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

class UserCell : UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    // --------------------------------------------
    // MARK: - Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.imgUser.image = .avatarUser
        self.vwMain.cornerRadius(cornerRadius: 4.0)
        self.lblUserName.font(font: .medium, size: .size16)
        self.lblUserName.color(color: .themeBlack)
        
        self.lblEmail.font(font: .regular, size: .size14)
        self.lblEmail.color(color: .themeBlack)
        
        self.btnLogin.font(font: .semibold, size: .size16)
        self.btnLogin.title(title: Labels.login)
        
        DispatchQueue.main.async {
            self.imgUser.cornerRadius(cornerRadius: self.imgUser.frame.height / 2)
            self.imgUser.border(borderWidth: 2, borderColor: .themeGreen)
        }
    }
    
    // --------------------------------------------
    
    func setMyaccountData(data: CurrentUserModel) {
        if let img = data.userProfile, let url = URL(string: img) {
            self.imgUser.sd_setImage(with: url, placeholderImage: .avatarUser) // avatar
            self.imgUser.contentMode = .scaleAspectFill
        } else {
            self.imgUser.image = .avatarUser
        }
        self.lblEmail.text = data.email
        if (data.fullName ?? "").isEmpty {
            self.lblUserName.text = data.username
        } else {
            self.lblUserName.text = data.fullName
        }
        
    }
    
    // --------------------------------------------
    
}

class AppVersionCell : UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblVersion : UILabel!
    
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
        
        self.lblVersion.font(font: .regular, size: .size12)
        self.lblVersion.color(color: .themeGray)
        self.lblVersion.text = Labels.appVersion + " " + appDelegate.appVersion + " (" + appDelegate.buildVersion + ")"
        self.lblVersion.textAlignment = .center
    }
    
    // --------------------------------------------
    
}

//
//  ChatListCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class ChatListCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblChatCount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivProfile.image = .avatarUser
        self.lblProductName.color(color: .themeBlack)
        self.lblUserName.font(font: .regular, size: .size16)
        self.lblUserName.color(color: .themeBlack)
        self.lblProductName.font(font: .medium, size: .size13)
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setData(data: ChatListModel) {
        if let img = data.profileImage, let url = URL(string: img) {
            self.ivProfile.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.ivProfile.contentMode = .scaleAspectFill
        } else {
            self.ivProfile.image = .avatarUser
        }
        self.lblUserName.text = data.name
        self.lblText.text = data.lastMessage
        if let date = data.lastMessageDateTime {
            self.lblTime.text = date.formatAndCompareDate()
        } else {
            self.lblTime.text = ""
        }
        if (data.unreadMessageCount ?? "").isEmpty || data.unreadMessageCount == "0" {
            self.lblChatCount.isHidden = true
        } else {
            self.lblChatCount.isHidden = false
            self.lblChatCount.text = data.unreadMessageCount
        }
        self.lblProductName.text = data.productName
    }
    
    // --------------------------------------------
    
}

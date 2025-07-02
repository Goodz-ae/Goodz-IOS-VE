//
//  SuggestionChatView.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

class SuggestionChatView: UIView {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var tbvSuggetionChat: UITableView!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    // --------------------------------------------
    // MARK: - Custom Variables
    // --------------------------------------------
    
    lazy var arrSuggetion = [
        Labels.chatMsgOne, Labels.chatMsgTwo, Labels.chatMsgThree
    ]
    var msg = ""
    var completion: (String?) -> Void = {_ in}
    var didSelect : Bool = false
    
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
    
    private func applyStyle()  {
        self.tbvSuggetionChat.delegate = self
        self.tbvSuggetionChat.dataSource = self
        self.msg = ""
        self.tbvSuggetionChat.registerReusableCell(SuggetionCell.self)
    }
    
    // --------------------------------------------
    
}


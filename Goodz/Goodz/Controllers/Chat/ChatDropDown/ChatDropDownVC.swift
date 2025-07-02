//
//  ChatDropDownVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 20/12/23.
//

import UIKit

class ChatDropDownVC: BaseVC {
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var tbvDropDown: UITableView!
    
    lazy var arrDropDown: [ChatDropDownModel] = []
    var userId : String = ""
    var chatId : String = ""
    var viewModel : ChatDropDownVM = ChatDropDownVM()
    var userName : String = ""
    var isBlock : String = ""
    var isSelf : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    func setUp() {
        tableRegister()
    }
    
    /// Table Register
    func tableRegister() {
        let block = (isSelf && self.isBlock == "1") ? Labels.unblock : Labels.block
        self.arrDropDown = [
            ChatDropDownModel(image: .icBlockUser, title: block + " " + self.userName),
            ChatDropDownModel(image: .icReportUser, title: Labels.report + " " + self.userName),
            ChatDropDownModel(image: .icDelete, title: Labels.delete)
        ]
        tbvDropDown.delegate = self
        tbvDropDown.dataSource = self
        tbvDropDown.registerReusableCell(ChatDropDownCell.self)
    }
    
    @IBAction func btnTapeed(_ sender: Any) {
        self.dismiss()
    }
}

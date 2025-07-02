//
//  ChatDetailSellerVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 21/12/23.
//

import UIKit

class ChatDetailSellerVC: BaseVC {
    /// Header View
    @IBOutlet weak var ivUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    /// Buy Product
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var btnMakeAnOffer: UIButton!
    
    @IBOutlet weak var tbvChats: UITableView!
    
    @IBOutlet weak var txtSendMessage: UITextField!
    
    
    lazy var arrChats: [ChatModel] = ChatModel.chatList()
    var viewModel : ChatDetailVM = ChatDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    private func setUp() {
        self.applyStyle()
        self.tableRegister()
    }
    
    func applyStyle() {
        /// Buy Product View
        lblProductName.font(font: .medium, size: .size16)
        lblOfferPrice.font(font: .semibold, size: .size16)
        lblMrp.font(font: .regular, size: .size14)
        lblMrp.setStrikethrough(text: "AED 400")
        btnMakeAnOffer.font(font: .medium, size: .size12)
    }
    
    func tableRegister() {
        tbvChats.delegate = self
        tbvChats.dataSource = self
        tbvChats.register(ChatViewCell.nib, forCellReuseIdentifier: ChatViewCell.reuseIdentifier)
        tbvChats.scrollToBottom(isAnimated: false)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        self.coordinator?.showChatDropDown(userId: "", chatId: "", userName: "", isBlock: "", isSelf: false)
    }
    
    @IBAction func actionMakeAnOffer(_ sender: Any) {
        self.coordinator?.showMakeOfferPopUp(data: MakeAnOfferModel(offerType: "1", productId: "1", bundleId: "", amount: "900"), price: 0) { status in
        }
    }
    
    @IBAction func actionImages(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            
            self.arrChats.append(ChatModel(chat: "", chatTime: "11:13 AM ", image: img, chatType: .sendAttachment))
            
            self.tbvChats.reloadData()
            self.tbvChats.restore()
            self.tbvChats.scrollToBottom(isAnimated: false)
        }
    }
    
    @IBAction func actionAttachment(_ sender: Any) {
        
    }
    
    @IBAction func actionSendMessage(_ sender: Any) {
        if let txt = self.txtSendMessage.text, !txt.trimmingCharacters(in: .whitespaces).isEmpty {
            self.txtSendMessage.text = ""
            self.arrChats.append(ChatModel(chat: txt, chatTime: "11:13 AM ", chatType: .sender))
            self.tbvChats.reloadData()
            self.tbvChats.restore()
            self.tbvChats.scrollToBottom(isAnimated: false)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Resign the keyboard when scrolling starts
        view.endEditing(true)
    }
}

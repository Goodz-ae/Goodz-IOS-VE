//
//  ChatDetailVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit
import IQKeyboardManagerSwift

class ChatDetailVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var viewSendMessage2: UIView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var htTextViewBottom: NSLayoutConstraint!
    @IBOutlet weak var viewProductzzdetails: UIView!
    /// Header View
    @IBOutlet weak var ivUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    /// Buy Product
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnMakeAnOffer: UIButton!
    
    @IBOutlet weak var txtSendMessage: GrowingTextView!
    @IBOutlet weak var tbvChats: UITableView!
    
    @IBOutlet weak var vwProduct: UIStackView!
  
    @IBOutlet weak var viewBundle: UIView!
    @IBOutlet weak var lblBundleCount: UILabel!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var arrChats: [ChatModel] = ChatModel.chatListBuyer()
    var page: Int = 1
    var viewModel : ChatDetailVM = ChatDetailVM()
    var chatId : String = ""
    var sellerID : String = ""
    var storeID : String = ""
    var messageType: MessageType = .message
    var userName : String = ""
    var isBlocked : Bool = false
    var mediaURL : URL?
    var isAPICalled : Bool = false
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ivUserProfile.image = .avatarUser
        self.imgProduct.image = .avatarUser
        self.refreshView() 
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    var isKeyboardShowing = false
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.isKeyboardShowing = (notification.name == UIResponder.keyboardWillShowNotification)
            
            UIView.animate(withDuration: 0.0, delay: 0, options: .curveLinear, animations: {
                
                var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
                if #available(iOS 11, *) {
                    if keyboardHeight > 0 {
                        keyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom
                    }
                    
                    self.htTextViewBottom.constant = ((keyboardHeight + 0))
                }
                self.view.layoutIfNeeded()
                
                if self.isKeyboardShowing {
                    self.scrollToBottom()
                }
                
            }, completion: { (completed) in })
        }
    }
    
    func scrollToBottom() {
        
        if self.viewModel.setChatMessage() > 0 {
            
            print("ScrollToBottom CALLED")
            
            let lastSection = 0
            let lastItem = self.viewModel.setChatMessage() - 1
            let indexPath = IndexPath(item: lastItem, section: lastSection)
            self.tbvChats.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.tableRegister()
    }
    
    func refreshView() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func applyStyle() {
        /// Buy Product View
        self.lblProductName.font(font: .medium, size: .size16)
        self.lblOfferPrice.font(font: .semibold, size: .size16)
        self.lblMrp.font(font: .regular, size: .size14)
        self.btnBuyNow.font(font: .medium, size: .size12)
        self.btnMakeAnOffer.font(font: .medium, size: .size12)
        self.btnBuyNow.isHidden = true
        self.btnMakeAnOffer.isHidden = true
        
        self.txtSendMessage.font(font: .regular, size: .size12)
        self.txtSendMessage.maxHeight = 80
        self.txtSendMessage.minHeight = 40
        self.txtSendMessage.placeholdeR = Labels.sendYourMessage
        self.txtSendMessage.autocorrectionType = .no
        self.txtSendMessage.inputAccessoryView = UIView()
    }
    
    // --------------------------------------------
    
    func tableRegister() {
        self.tbvChats.delegate = self
        self.tbvChats.dataSource = self
        self.tbvChats.register(ChatViewCell.nib, forCellReuseIdentifier: ChatViewCell.reuseIdentifier)
        
        self.tbvChats.register(SellStepView.nib, forCellReuseIdentifier: SellStepView.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    func apiCalling(isShowLoader : Bool = false) {
        self.isAPICalled = false
        self.viewModel.fetchChatDetails(isShowLoader : isShowLoader,page: self.page, chatId: self.chatId) { status in
            if status {
                if self.page == 1 {
                    self.tbvChats.scrollToBottom(isAnimated: false)
                }
                self.isAPICalled = true
                self.setAPIdata()
                self.tbvChats.reloadData()
                self.tbvChats.endRefreshing()
                
            } else {
                
                self.isAPICalled = false
                return
                
            }
            self.tbvChats.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func setAPIdata() {
        let product = self.viewModel.setProductRow(row: 0)
        let user = self.viewModel.chatDetails.first
        if let img = user?.profileImage, let url = URL(string: img) {
            self.ivUserProfile.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.ivUserProfile.contentMode = .scaleAspectFill
        } else {
            self.ivUserProfile.image = .avatarUser
        }
        self.lblUserName.text = user?.name
        self.userName = user?.name ?? ""
        if let img = product.productImg, let url = URL(string: img) {
            self.imgProduct.sd_setImage(with: url, placeholderImage: .product)
            self.imgProduct.contentMode = .scaleAspectFill
        } else {
            self.imgProduct.image = .product
        }
        
        let mainData = self.viewModel.dataChatMainResponse
        
        if mainData?.isBundleChat == "2" {
            self.viewBundle.isHidden = true
            self.lblBundleCount.text = "+\((self.viewModel.chatDetails.first?.products?.count ?? 0) - 1)"
        } else {
            self.viewBundle.isHidden = true
        }
        
        self.lblProductName.text = mainData?.isBundleChat == "2" ? Labels.bundleProducts : product.productName
        
        self.lblOfferPrice.text = kCurrency + (mainData?.bundleSellingPrice ?? "0")
        self.lblMrp.setStrikethrough(text: kCurrency + (mainData?.bundleOriginalPrice ?? "0"))
        if (Double(mainData?.bundleSellingPrice ?? "0") ?? 0) == (Double(mainData?.bundleOriginalPrice ?? "0") ?? 0) {
            self.lblMrp.isHidden = true
        }
        
        if self.isBlocked {
            self.btnBuyNow.isHidden = self.isBlocked
            self.btnMakeAnOffer.isHidden = self.isBlocked
        } else {
            if mainData?.isSeller == Status.one.rawValue {
                self.btnBuyNow.isHidden = true
            } else {
                if mainData?.isBundleChat == "2" {
                    self.btnBuyNow.isHidden = true
                }else {
                    self.btnBuyNow.isHidden = (mainData?.offerAccepted == Status.one.rawValue || mainData?.paymentDone == Status.one.rawValue)
                }
            }
            
            self.btnMakeAnOffer.isHidden = mainData?.offerAccepted == Status.one.rawValue || mainData?.paymentDone == Status.one.rawValue || mainData?.isOfferSend == Status.one.rawValue
        }
        
        self.viewProductzzdetails.isHidden = mainData?.paymentDone == Status.one.rawValue
        
        if (self.viewModel.chatDetails.first?.products?.count ?? 0) <= 0{
            viewProductzzdetails.isHidden = true
        }
        
        self.imgProduct.addTapGesture {
            if mainData?.isBundleChat == "2" {
                self.coordinator?.navigateToChatBundleList(isSeller: mainData?.isSeller == Status.one.rawValue, productList: self.viewModel.productList ?? [])
            } else {
                if mainData?.isSeller == Status.one.rawValue {
                    self.coordinator?.navigateToSellProductDetail(storeId: "", productId: String(format: "%d", product.productID ?? 0), type: .sell)
                } else {
                    self.coordinator?.navigateToProductDetail(productId: String(format: "%d", product.productID ?? 0), type: .goodsDefault)
                }
            }
        }
        self.viewBundle.addTapGesture {
            
        }
        self.vwProduct.addTapGesture {
            if mainData?.isBundleChat == "2" {
                self.coordinator?.navigateToChatBundleList(isSeller: mainData?.isSeller == Status.one.rawValue, productList: self.viewModel.productList ?? [])
            } else {
                if mainData?.isSeller == Status.one.rawValue {
                    self.coordinator?.navigateToSellProductDetail(storeId: "", productId: String(format: "%d", product.productID ?? 0), type: .sell)
                } else {
                    self.coordinator?.navigateToProductDetail(productId: String(format: "%d", product.productID ?? 0), type: .goodsDefault)
                }
            }
            
        }
        self.sellerID = self.viewModel.chatDetails.first?.userID ?? ""
        self.storeID = self.viewModel.chatDetails.first?.storeID ?? ""
        
        self.viewSendMessage.isHidden = self.viewModel.chatDetails.first?.isBlocked == Status.one.rawValue
        self.viewSendMessage2.isHidden = self.viewModel.chatDetails.first?.isBlocked == Status.one.rawValue
    }
    
    // --------------------------------------------
    // MARK: - Action methods
    // --------------------------------------------
    
    @IBAction func actionImages(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary, .video], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            self.messageType = .image
            self.mediaURL = imgUrl
            //self.txtSendMessage.text = self.mediaURL?.lastPathComponent
            self.viewModel.sendMessageAPI(messageData: SendMessage(chatId: self.chatId, toId: (self.viewModel.chatDetails.first?.userID ?? ""), messageType: self.messageType.rawValue, message: self.mediaURL?.lastPathComponent ?? "", url: self.mediaURL ?? nil, name: self.mediaURL?.lastPathComponent ?? "")) { status in
                if status {
                    self.afterSend()
                }
            }
        }
        
        AttachmentHandler.shared.videoPickedBlock = { [self] (video) in
            self.messageType = .video
            self.mediaURL = video as URL
            //self.txtSendMessage.text = self.mediaURL?.lastPathComponent
            self.viewModel.sendMessageAPI(messageData: SendMessage(chatId: self.chatId, toId: (self.viewModel.chatDetails.first?.userID ?? ""), messageType: self.messageType.rawValue, message: self.mediaURL?.lastPathComponent ?? "", url: self.mediaURL ?? nil, name: self.mediaURL?.lastPathComponent ?? "")) { status in
                if status {
                    self.afterSend()
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionAttachment(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.file], vc: self)
        AttachmentHandler.shared.filePickedBlock = { [self] (fileType, url, img) in
            self.messageType = .doc
            self.mediaURL = url
           // self.txtSendMessage.text = self.mediaURL?.lastPathComponent
            self.viewModel.sendMessageAPI(messageData: SendMessage(chatId: self.chatId, toId: (self.viewModel.chatDetails.first?.userID ?? ""), messageType: self.messageType.rawValue, message: self.mediaURL?.lastPathComponent ?? "", url: self.mediaURL ?? nil, name: self.mediaURL?.lastPathComponent ?? "")) { status in
                if status {
                    self.afterSend()
                }
            }
        }
    }
    
    // --------------------------------------------
    @IBAction func btnStoreClicked(_ sender: UIButton) {
        self.coordinator?.navigateToPopularStore(storeId: self.storeID)
    }
    
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        let text = self.txtSendMessage.text ?? ""
        let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        let mobileRegex = try! NSRegularExpression(pattern: "\\d{6,12}")
        if text.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterMessage)
        } else if emailRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) != nil && self.messageType == .message {
            notifier.showToast(message: Labels.sharingPhoneNumbersOrEmailIDsIsNotAllowed)
        } else if mobileRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) != nil  && self.messageType == .message {
            notifier.showToast(message: Labels.sharingPhoneNumbersOrEmailIDsIsNotAllowed)
        } else {
            if let txt = self.txtSendMessage.text, !txt.trimmingCharacters(in: .whitespaces).isEmpty {
                sender.isUserInteractionEnabled = false
                self.viewModel.sendMessageAPI(messageData: SendMessage(chatId: self.chatId, toId: (self.viewModel.chatDetails.first?.userID ?? ""), messageType: self.messageType.rawValue, message: txt, url: self.mediaURL ?? nil, name: txt)) { status in
                    self.afterSend(sender)
                    
                }
            }
        }
    }
    
    func afterSend(_ sender: UIButton? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.txtSendMessage.text = ""
            self.messageType = .message
            self.mediaURL = nil
            self.viewModel.chatDetails = []
            self.page = 1
            self.apiCalling(isShowLoader: true)
            self.tbvChats.reloadData()
            self.tbvChats.scrollToBottom(isAnimated: false)
            sender?.isUserInteractionEnabled = true
        }
    }
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionMore(_ sender: Any) {
        let isBlock = self.viewModel.chatDetails.first?.isBlocked ?? "0"
        let isSelf = self.viewModel.chatDetails.first?.blockedUserID == UserDefaults.userID
        self.coordinator?.showChatDropDown(userId: self.sellerID, chatId: self.chatId, userName: self.userName, isBlock: isBlock, isSelf: isSelf)
    }
    
    // --------------------------------------------
    
    @IBAction func actionBuyNow(_ sender: Any) {
        GlobalRepo.shared.addtoCartAPI(self.viewModel.setProductRow(row: 0).productID?.description ?? "") { status, error in
           
                if let errorMsg = error {
                    notifier.showToast(message: appLANG.retrive(label: errorMsg))
                } else {
                    self.coordinator?.navigateToCart()
                }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func actionMakeAnOffer(_ sender: Any) {
        let bundleID = self.viewModel.dataChatMainResponse?.bundleId ?? ""
        self.coordinator?.showMakeOfferPopUp(data: MakeAnOfferModel(offerType: (self.viewModel.dataChatMainResponse?.isBundleChat ?? "") == "2" ? "2" : "1", productId: bundleID == "" ? (self.viewModel.setProductRow(row: 0).productID?.description ?? "") : "", bundleId: bundleID, amount: ""), price: Int(self.viewModel.chatDetails.first?.products?.first?.discountedPrice ?? 0.0)) { status in
            if status {
                self.apiCalling()
            }
        }
    }
    
    // --------------------------------------------
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Resign the keyboard when scrolling starts
        if scrollView == tbvChats {
            view.endEditing(true)
        }
    }
    
    // --------------------------------------------
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView == self.tbvChats) {
            if (scrollView .contentOffset.y <= 50) /*&& !isAPICalled */{
                if self.viewModel.totalRecords > self.viewModel.setChatMessage() {
                    self.page += 1
                    self.apiCalling()
                }
            }
        }
    }
    
    // --------------------------------------------
    
}



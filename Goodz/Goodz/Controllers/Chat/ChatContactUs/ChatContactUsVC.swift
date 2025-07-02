//
//  ContactUsVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 21/12/23.
//

import UIKit

class ChatContactUsVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : ChatContactUsVM = ChatContactUsVM()
    var chatId : String = ""
    var bundleId : String = ""
    var productId : String = ""
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setUp() {
        self.lblContactUs.font(font: .semibold, size: .size16)
        self.lblDescription.font(font: .regular, size: .size16)
        self.lblMessage.font(font: .medium, size: .size14)
        self.txtView.font(font: .regular, size: .size14)
        
        self.txtView.delegate = self
        self.txtView.font(font: .regular, size: .size14)
        self.txtView.setPlaceholder(text: Labels.enterMessageHere, color: UIColor.lightGray)
        self.txtView.setAutocapitalization()
    }
    
    // --------------------------------------------
    // MARK: - Action
    // --------------------------------------------
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        let message = self.txtView.text ?? ""
        if message.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterMessage)
        } else {
            self.viewModel.contactUsChatAPI(chatId: self.chatId, message: self.txtView.text, bundleId: self.bundleId, productId: self.productId) { status in
                if status {
                    self.dismiss()
                }
            }
        }
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension ChatContactUsVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.txtView.superview?.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtView.superview?.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

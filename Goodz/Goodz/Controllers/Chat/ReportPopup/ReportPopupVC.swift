//
//  ReportPopupVC.swift
//  Goodz
//
//  Created by Akruti on 06/05/24.
//

import Foundation
import UIKit

class ReportPopupVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblIssue: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var txtIssue: UITextView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var chatViewModel : ChatDropDownVM = ChatDropDownVM()
    var chatId : String = ""
    var toID : String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ReportPopupVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblIssue.font(font: .medium, size: .size14)
        self.btnSend.font(font: .semibold, size: .size16)
        self.btnSend.setTitle(Labels.submit, for: .normal)
        self.lblIssue.text = Labels.comment
        self.txtIssue.border(borderWidth: 1, borderColor: .themeBorder)
        
        self.txtIssue.delegate = self
        self.txtIssue.font(font: .regular, size: .size14)
        self.txtIssue.setPlaceholder(text: Labels.reason, color: UIColor.lightGray,x: 6)
        self.txtIssue.setAutocapitalization()
    }
    
    private func setUp() {
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnSendTapped(_ sender: Any) {
        if ((self.txtIssue.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)).isEmpty {
            notifier.showToast(message: Labels.pleaseEnterReason)
        } else {
            self.chatViewModel.reportUserAPI(message: ((self.txtIssue.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)), toId: self.toID, chatId: self.chatId) { status in
                if status {
                    self.dismiss()
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        self.dismiss()
    }
    
    // --------------------------------------------
    
}

extension ReportPopupVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.txtIssue.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.txtIssue.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

//
//  ReplyVC.swift
//  Goodz
//
//  Created by Akruti on 05/12/23.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class ReplyVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var imgProfile: ThemeGreenBorderImage!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var lblDescription: ExpandableLabel!
    @IBOutlet weak var vwReply: UIView!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var tvReply: UITextView!
    @IBOutlet weak var btnReply: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var replyData : StoreReviewModel?
    private var viewModel : ReplyVM = ReplyVM()
    var storeId : String = ""
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imgProfile.image = .avatarUser
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblName.font(font: .regular, size: .size16)
        self.lblName.color(color: .themeBlack)
        
        self.lblDate.font(font: .regular, size: .size14)
        self.lblDate.color(color: .themeGray)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeGray )
        
        self.lblReply.font(font: .medium, size: .size16)
        self.lblReply.color(color: .themeBlack)
        
        self.btnRate.cornerRadius(cornerRadius: 4.0)
        self.vwReply.cornerRadius(cornerRadius: 4.0)
        self.vwProfile.cornerRadius(cornerRadius: 4.0)
        self.vwReply.border(borderWidth: 1, borderColor: .clear)
        self.tvReply.delegate = self
        self.tvReply.font(font: .regular, size: .size14)
        self.tvReply.setPlaceholder(text: "*" + Labels.enterMessageHere, color: UIColor.lightGray,x:6)
        self.tvReply.setAutocapitalization()
        self.tvReply.border(borderWidth: 1, borderColor: .themeBorder)
        
        
        // expand label
        DispatchQueue.main.async {
            
            self.lblDescription.isUserInteractionEnabled = true
            self.lblDescription.delegate = self
            self.lblDescription.numberOfLines = 2
            self.lblDescription.shouldCollapse = true
            self.lblDescription.setMoreLinkWith(moreLink: Labels.readMore, attributes: [.foregroundColor:UIColor.themeBlack], position: .left)
            self.lblDescription.setLessLinkWith(lessLink: Labels.readLess, attributes: [.foregroundColor:UIColor.themeBlack], position: .left)
            
            self.lblDescription.text = self.replyData?.reviewDescription ?? ""
            
        }
        
    }
    
    // --------------------------------------------
    
    func setData() {
        self.lblReply.text = Labels.reply.capitalizeFirstLetter()
        self.btnReply.setTitle(Labels.reply.capitalizeFirstLetter(), for: .normal)
        self.lblDescription.text = self.replyData?.reviewDescription ?? ""
        self.lblName.text = self.replyData?.userName ?? ""
        self.lblDate.setConvertDateString(self.replyData?.dateOfReview ?? "")
        if let img = self.replyData?.userProfile, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarUser)
            self.imgProfile.contentMode = .scaleAspectFill
        } else {
            self.imgProfile.image = .avatarUser
        }
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.reply.capitalizeFirstLetter()
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    @IBAction func btnReplyTapped(_ sender: Any) {
        
        if self.tvReply.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notifier.showToast(message: Labels.pleaseEnterMessage)
        } else {
            self.viewModel.fetchReviewsReplyData(reviewId: self.replyData?.reviewID ?? "", message: self.tvReply.text, storeId: self.storeId) { isDone in
                if isDone {
                    self.coordinator?.popVC()
                }
            }
        }
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension ReplyVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvReply.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.tvReply.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

// --------------------------------------------
// MARK: - ExpandableLabelDelegate
// --------------------------------------------

extension ReplyVC : ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    // --------------------------------------------
    
    func didExpandLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    // --------------------------------------------
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    // --------------------------------------------
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        print(self.lblDescription.shouldExpand, self.lblDescription.shouldCollapse)
    }
    
    // --------------------------------------------
    
}

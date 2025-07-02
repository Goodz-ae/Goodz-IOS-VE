//
//  ContactUsVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class ContactUsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: AppTextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var txtSubject: AppTextField!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var vwDoc: UIView!
    @IBOutlet weak var btnAttach: ThemeGreenBorderButton!
    @IBOutlet weak var lblDoc: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : ContactUsVM = ContactUsVM()
    var attachDocURL : URL?
    let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
    
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
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblName.font(font: .medium, size: .size14)
        self.lblName.color(color: .themeBlack)
        
        self.lblEmail.font(font: .medium, size: .size14)
        self.lblEmail.color(color: .themeBlack)
        
        self.lblSubject.font(font: .medium, size: .size14)
        self.lblSubject.color(color: .themeBlack)
        
        self.lblMessage.font(font: .medium, size: .size14)
        self.lblMessage.color(color: .themeBlack)
        
        self.txtName.txtType = .normalWithoutImage
        self.txtName.txt.setAutocapitalization(.words)
        
        self.txtEmail.txtType = .normalWithoutImage
        self.txtSubject.txtType = .normalWithoutImage
        
        self.txtSubject.txt.setAutocapitalization(.sentences)
        
        self.tvMessage.delegate = self
        self.tvMessage.setPlaceholder(text: Labels.enterMessageHere, color: UIColor.lightGray)
        self.tvMessage.font(font: .regular, size: .size14)
        self.tvMessage.setAutocapitalization()
        self.vwMessage.cornerRadius(cornerRadius: 4.0)
        self.vwMessage.border(borderWidth: 1, borderColor: .themeBorder)
        self.vwDoc.isHidden = true
        self.btnAttach.isHidden = false
        
        self.txtName.txt.delegate = self
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblName.text = Labels.name
        self.lblEmail.text = Labels.email
        self.lblMessage.text = Labels.message
        self.lblSubject.text = Labels.subject
        self.txtName.placeholder = Labels.enterName
        self.txtEmail.placeholder = Labels.enterEmail
        self.txtSubject.placeholder = Labels.enterSubject
        self.btnAttach.setTitle(Labels.attachFile, for: .normal)
        self.txtEmail.txt.keyboardType = .emailAddress
        self.txtName.txt.text = (currentUser?.fullName ?? "").isEmpty ? currentUser?.username : currentUser?.fullName
        self.txtEmail.txt.text = currentUser?.email
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.contactUs
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnAttachTapped(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary, .file], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            self.attachDocURL = imgUrl
            self.btnAttach.isHidden = true
            self.vwDoc.isHidden = false
            self.lblDoc.text = self.attachDocURL?.lastPathComponent
        }
        AttachmentHandler.shared.filePickedBlock = { [self] (fileType, url, img) in
            self.attachDocURL = url
            self.btnAttach.isHidden = true
            self.vwDoc.isHidden = false
            self.lblDoc.text = self.attachDocURL?.lastPathComponent
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        self.viewModel.checkUserData(docURL: self.attachDocURL, name: self.txtName.txt.text ?? "", email: self.txtEmail.txt.text ?? "", subject: self.txtSubject.txt.text ?? "", message: self.tvMessage.text ?? "") { isDone in
            if isDone {
                self.coordinator?.popVC()
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        self.attachDocURL = nil
        self.btnAttach.isHidden = false
        self.vwDoc.isHidden = true
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension ContactUsVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.vwMessage.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.vwMessage.border(borderWidth: 1, borderColor: .themeBorder)
    }
}


// --------------------------------------------
// MARK: - UITextField Delegate methods
// --------------------------------------------

extension ContactUsVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range, with: string)
            if textField == self.txtName.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                
                if finaltext.count > TextFieldMaxLenth.productTitleMaxLength.length {
                    return false
                }
                
            }
        }
        return true
    }
}

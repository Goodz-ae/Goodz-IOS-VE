//
//  PriorityContactVC.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import Foundation
import UIKit

class PriorityContactVC : BaseVC {
    
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
    @IBOutlet weak var btnAttachFile: ThemeGreenBorderButton!
    @IBOutlet weak var btnSubmit: ThemeGreenButton!
    @IBOutlet weak var vwDoc: UIView!
    @IBOutlet weak var lblDoc: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : PriorityContactVM = PriorityContactVM()
    var attachmentImage: UIImage?
    var fileUrl: URL?
    
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
        print("LoginVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.btnAttachFile.isHidden = false
        self.vwDoc.isHidden = true
        
        self.lblName.font(font: .medium, size: .size14)
        self.lblName.color(color: .themeBlack)
        
        self.lblEmail.font(font: .medium, size: .size14)
        self.lblEmail.color(color: .themeBlack)
        
        self.lblSubject.font(font: .medium, size: .size14)
        self.lblSubject.color(color: .themeBlack)
        
        self.lblMessage.font(font: .medium, size: .size14)
        self.lblMessage.color(color: .themeBlack)
        
        self.txtName.txtType = .normalWithoutImage
        self.txtEmail.txtType = .normalWithoutImage
        self.txtSubject.txtType = .normalWithoutImage
        
        self.txtName.txt.delegate = self
        self.txtName.txt.setAutocapitalization(.words)
        
        self.txtEmail.txt.delegate = self
        self.txtSubject.txt.delegate = self
        
        self.vwMessage.cornerRadius(cornerRadius: 4.0)
        self.vwDoc.cornerRadius(cornerRadius: 4.0)
        self.vwMessage.border(borderWidth: 1, borderColor: .themeBorder)
        self.tvMessage.delegate = self
        self.tvMessage.textColor = UIColor.themeBlack
        self.tvMessage.font(font: .regular, size: .size14)
        self.tvMessage.setPlaceholder(text: Labels.enterMessageHere, color: UIColor.lightGray)
        self.tvMessage.setAutocapitalization()
    }
    
    // --------------------------------------------
    
    private func setData() {
        
        self.btnSubmit.setTitle(Labels.submit, for: .normal)
        self.btnAttachFile.setTitle(Labels.attachFile, for: .normal)
        self.lblName.text = Labels.name
        self.lblEmail.text = Labels.email
        self.lblMessage.text = Labels.message
        self.lblSubject.text = Labels.subject
        self.txtName.placeholder = Labels.enterName
        self.txtEmail.placeholder = Labels.enterEmail
        self.txtSubject.placeholder = Labels.enterSubject
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.priorityContact
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnAttachFileTapped(_ sender: Any) {
        attachmentHandler()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
      
        self.viewModel.setPriorityContactData(name: self.txtName.txt.text ?? "", email: self.txtEmail.txt.text ?? "", subject: self.txtSubject.txt.text ?? "", message: tvMessage.text ?? "", isAttachment: attachmentImage != nil || fileUrl != nil) { isDone in
            if isDone {
                
                viewModel.priorityContactDetails(name: self.txtName.txt.text ?? "", email: self.txtEmail.txt.text ?? "", subject: self.txtSubject.txt.text ?? "", message: tvMessage.text ?? "", attachFile: attachmentImage, fileUrl: fileUrl) { [self] done in
                    if done {
                        showOKAlert(title: Labels.appname, message: Labels.priorityContactAddedSuccessfully, okAction: { [self] in
                            coordinator?.popVC()
                        })
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        self.btnAttachFile.isHidden = false
        self.vwDoc.isHidden = true
        self.lblDoc.text = nil
    }
    
    // --------------------------------------------
    
    func attachmentHandler() {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary,.file], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            print(img)
            
            btnAttachFile.isHidden = true
            vwDoc.isHidden = false
            lblDoc.text = imgUrl?.lastPathComponent
            attachmentImage = img
            fileUrl = nil
           
        }
        AttachmentHandler.shared.filePickedBlock = { [self] (fileType, url, img) in
           print(url)
            btnAttachFile.isHidden = true
            vwDoc.isHidden = false
            lblDoc.text = url.lastPathComponent
            attachmentImage = nil
            fileUrl = url
        }
    }
}

//MARK: - UITextFieldDelegate
extension PriorityContactVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range = Range(range, in: text) {
            
            let finaltext = text.replacingCharacters(in: range, with: string)
            
            if textField == txtName.txt {
                
                if textField.text == "" {
                    
                    if string == " " {
                        return false
                    }
                }
                
               if finaltext.count > TextFieldMaxLenth.priorityContactNameMaxLength.length {
                    return false
               }
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtName.txt {
            txtEmail.txt.becomeFirstResponder()
        }else if textField == txtEmail.txt {
            txtSubject.txt.becomeFirstResponder()
        }else if textField == txtSubject.txt {
            tvMessage.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension PriorityContactVC : UITextViewDelegate {
        
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

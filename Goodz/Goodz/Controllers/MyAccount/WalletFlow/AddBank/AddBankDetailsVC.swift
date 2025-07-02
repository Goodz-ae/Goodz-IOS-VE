//
//  AddBankDetailsVC.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import Foundation
import UIKit

class AddBankDetailsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var txtBankName: AppTextField!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var txtAccountHolderName: AppTextField!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var txtAccountNumber: AppTextField!
    @IBOutlet weak var lblIBANNumber: UILabel!
    @IBOutlet weak var txtIBANNumber: AppTextField!
    @IBOutlet weak var lblSWIFTCode: UILabel!
    @IBOutlet weak var txtSWIFTCode: AppTextField!
    @IBOutlet weak var btnAdd: ThemeGreenButton!
    @IBOutlet weak var vwDoc: UIView!
    @IBOutlet weak var btnAttach: ThemeGreenBorderButton!
    @IBOutlet weak var lblDoc: UILabel!
    
    @IBOutlet weak var lblBankLetterTitle: UILabel!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    var attachDocURL : URL?
    var viewModel : AddBankDetailsVM = AddBankDetailsVM()
    var isEdit : Bool = false
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.setBankDetails()
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
        self.lblBankName.font(font: .medium, size: .size14)
        self.lblBankName.color(color: .themeBlack)
        
        self.lblAccountHolderName.font(font: .medium, size: .size14)
        self.lblAccountHolderName.color(color: .themeBlack)
        
        self.lblAccountNumber.font(font: .medium, size: .size14)
        self.lblAccountNumber.color(color: .themeBlack)
        
        self.lblIBANNumber.font(font: .medium, size: .size14)
        self.lblIBANNumber.color(color: .themeBlack)
        
        self.lblSWIFTCode.font(font: .medium, size: .size14)
        self.lblSWIFTCode.color(color: .themeBlack)
        
        lblBankLetterTitle.font(font: .medium, size: .size14)
        lblBankLetterTitle.color(color: .themeBlack)
        
        self.txtBankName.txtType = .normalWithoutImage
        self.txtSWIFTCode.txtType = .normalWithoutImage
        self.txtIBANNumber.txtType = .normalWithoutImage
        self.txtAccountNumber.txtType = .normalWithoutImage
        self.txtAccountHolderName.txtType = .normalWithoutImage
        
        self.txtBankName.txt.setAutocapitalization(.words)
        self.txtAccountHolderName.txt.setAutocapitalization(.words)
        
        
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.addBankDetail
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func setBankDetails() {
        if let bankDetail = viewModel.bankDetail {
            isEdit = true
            txtBankName.txt.text = bankDetail.bankName
            txtAccountHolderName.txt.text = bankDetail.accountHolderName
            txtAccountNumber.txt.text = bankDetail.accountNumber
            txtIBANNumber.txt.text = bankDetail.ibanNumber
            txtSWIFTCode.txt.text = bankDetail.swiftCode
            self.attachDocURL = URL(string: bankDetail.bankLetter ?? "")
            if attachDocURL == nil {
                self.vwDoc.isHidden = true
                self.btnAttach.isHidden = false
            } else {
                self.lblDoc.text = attachDocURL?.lastPathComponent
                self.vwDoc.isHidden = false
                self.btnAttach.isHidden = true
            }
        }else{
            isEdit = false
            self.vwDoc.isHidden = true
            self.btnAttach.isHidden = false
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblBankName.text = Labels.bankName
        self.txtBankName.placeholder = Labels.enterBankName
        self.lblAccountHolderName.text = Labels.accountHolderName
        self.txtAccountHolderName.placeholder = Labels.enterAccountHolderName
        self.lblAccountNumber.text = Labels.accountNumber
        self.txtAccountNumber.placeholder = Labels.enterAccountNumber
        self.lblIBANNumber.text = Labels.iBANNumber
        self.txtIBANNumber.placeholder = Labels.enterIBANNumber
        self.lblSWIFTCode.text = Labels.enterSWIFTCode
        self.lblBankLetterTitle.text = Labels.bankLetter
        self.txtSWIFTCode.placeholder = Labels.sWIFTCode
        self.btnAdd.setTitle(Labels.update, for: .normal)
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
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let bankName = self.txtBankName.txt.text ?? ""
        let AccountHolderName = self.txtAccountHolderName.txt.text ?? ""
        let AccountNumber = self.txtAccountNumber.txt.text ?? ""
        let IBANNumber = self.txtIBANNumber.txt.text ?? ""
        let SWIFTCode = self.txtSWIFTCode.txt.text ?? ""
        
        
        
        self.viewModel.checkUserData(bankName: bankName,
                                     accountHolder: AccountHolderName,
                                     accountNumber: AccountNumber,
                                     iBANNumber: IBANNumber,
                                     sWIFTCode: SWIFTCode, bankLetter: self.attachDocURL) { isDone in
            
            self.viewModel.AddBankDetails(isEdit: isEdit , bankName: bankName, accountHolder: AccountHolderName, accountNumber: AccountNumber, iBANNumber: IBANNumber, sWIFTCode: SWIFTCode, imgUrl: self.attachDocURL) { isDone in
                    self.coordinator?.popVC()
                }
            
        }
    }

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
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        self.attachDocURL = nil
        self.btnAttach.isHidden = false
        self.vwDoc.isHidden = true
    }
}

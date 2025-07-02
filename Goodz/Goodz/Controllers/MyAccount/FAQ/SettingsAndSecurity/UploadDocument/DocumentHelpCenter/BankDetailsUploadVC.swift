//
//  BankDetailsUploadVC.swift
//  Goodz
//
//  Created by Dipesh on 04/02/25.
//

import UIKit

class BankDetailsUploadVC: BaseVC {
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var bankNameStackView: UIStackView!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var txtBankName: AppTextField!
    @IBOutlet weak var accHolderStackView: UIStackView!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var txtAccountHolderName: AppTextField!
    @IBOutlet weak var accNumberStackView: UIStackView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var txtAccountNumber: AppTextField!
    @IBOutlet weak var iBANStackView: UIStackView!
    @IBOutlet weak var lblIBANNumber: UILabel!
    @IBOutlet weak var txtIBANNumber: AppTextField!
    @IBOutlet weak var swiftCodeStackView: UIStackView!
    @IBOutlet weak var lblSWIFTCode: UILabel!
    @IBOutlet weak var txtSWIFTCode: AppTextField!
    @IBOutlet weak var bankAddedBackView: UIView!
    @IBOutlet weak var bankAddedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bankInfoBackView: UIView!
    @IBOutlet weak var withdrawlLbl: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var iBANNameLbl: UILabel!
    @IBOutlet weak var accNumberValueLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var btnAdd: ThemeGreenButton!
    @IBOutlet weak var disclaimerLbl: UILabel!
    
    private var viewModel : WalletVM = WalletVM()
    var docModel : UploadDocumentVM = UploadDocumentVM()
    var isEdit : Bool = false
    var attachDocURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
        self.getWalletSetup()
        self.bankAddedViewHeightConstraint.constant = 0
    }
    
    //----------------------------
    private func applyStyle() {
        self.lblBankName.font(font: .medium, size: .size14)
        self.lblBankName.color(color: .themeBlack)
        
        self.lblAccountHolderName.font(font: .medium, size: .size14)
        self.lblAccountHolderName.color(color: .themeBlack)
        
        self.lblAccountNumber.font(font: .medium, size: .size14)
        self.lblAccountNumber.color(color: .themeBlack)
        self.txtAccountNumber.txt.enforceCharacterLimit(max: 12)
        self.txtAccountNumber.txtType = .phoneNumber
        
        self.lblIBANNumber.font(font: .medium, size: .size14)
        self.lblIBANNumber.color(color: .themeBlack)
        self.txtIBANNumber.txt.enforceCharacterLimit(max: 22)
        
        self.lblSWIFTCode.font(font: .medium, size: .size14)
        self.lblSWIFTCode.color(color: .themeBlack)
        self.txtSWIFTCode.txt.enforceCharacterLimit(max: 8)
        
        self.withdrawlLbl.font(font: .semibold, size: .size16)
        self.withdrawlLbl.color(color: .themeBlack)
        
        self.changeLbl.font(font: .medium, size: .size16)
        self.changeLbl.color(color: .themeBlack)
        
        self.iBANNameLbl.font(font: .medium, size: .size14)
        self.iBANNameLbl.color(color: .themeBlack)
        
        self.accNumberValueLbl.font(font: .regular, size: .size16)
        self.accNumberValueLbl.color(color: .themeBlack)
        
        self.txtBankName.txtType = .normalWithoutImage
        self.txtSWIFTCode.txtType = .normalWithoutImage
        self.txtIBANNumber.txtType = .normalWithoutImage
        self.txtAccountNumber.txtType = .normalWithoutImage
        self.txtAccountHolderName.txtType = .normalWithoutImage
        
        self.txtBankName.txt.setAutocapitalization(.words)
        self.txtAccountHolderName.txt.setAutocapitalization(.words)
        
        self.bankInfoBackView.cornerRadius = 5
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = "Add Bank Detail"
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblBankName.text = Labels.bankName
        self.txtBankName.placeholder = Labels.enterName
        self.lblAccountHolderName.text = Labels.accountHolderName
        self.txtAccountHolderName.placeholder = Labels.enterHolderName
        self.lblAccountNumber.text = Labels.accountNumber
        self.txtAccountNumber.placeholder = Labels.enterNumber
        self.lblIBANNumber.text = Labels.iBANNumber
        self.txtIBANNumber.placeholder = Labels.enterNumber
        self.lblSWIFTCode.text = Labels.sWIFTCode
        self.txtSWIFTCode.placeholder = Labels.enterNumber
        self.disclaimerLbl.text = "By adding your bank details, you agreed to Goodz Terms & Conditions"
        self.disclaimerLbl.setAttributeText(fulltext: "By adding your bank details, you agreed to Goodz Terms & Conditions", range1: "By adding your bank details, you agreed to Goodz", range2: "Terms & Conditions", range3: "")
        self.disclaimerLbl.font(font: .regular, size: .size10)
        self.btnAdd.setTitle(Labels.add, for: .normal)
    }
    
    // --------------------------------------------
    
    func setBankDetails() {
        if let bankDetail = viewModel.bankDetail {
            self.iBANNameLbl.text = "IBAN \(bankDetail.accountHolderName ?? "")"
            self.accNumberValueLbl.text = "\(bankDetail.secureAccountNumber ?? "")"
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
        self.adjustBankDetails(isShow: false)
    }
    
    @IBAction func btnAddAction(_ sender: Any) {
        
        let bankName = self.txtBankName.txt.text ?? ""
        let AccountHolderName = self.txtAccountHolderName.txt.text ?? ""
        let AccountNumber = self.txtAccountNumber.txt.text ?? ""
        let accNo = self.txtAccountNumber.txt.getCharacterCount()
        let IBANNumber = self.txtIBANNumber.txt.text ?? ""
        let ibanNo = self.txtIBANNumber.txt.getCharacterCount()
        let SWIFTCode = self.txtSWIFTCode.txt.text ?? ""
        let swiftCo = self.txtSWIFTCode.txt.getCharacterCount()
        
        
        self.viewModel.checkUserData(bankName: bankName,
                                     accountHolder: AccountHolderName,
                                     accountNumber: AccountNumber,
                                     accNoCount: accNo,
                                     iBANNumber: IBANNumber,
                                     iBanNoCount: ibanNo,
                                     sWIFTCode: SWIFTCode,
                                     swiftCodeCount: swiftCo,
                                     bankLetter: self.attachDocURL) { isDone in
            
            if isDone {
                self.viewModel.AddBankDetails(isEdit: isEdit , bankName: bankName, accountHolder: AccountHolderName, accountNumber: AccountNumber, iBANNumber: IBANNumber, sWIFTCode: SWIFTCode, imgUrl: self.attachDocURL) { isDone in
                    self.isEdit = false
                    self.getWalletSetup()
                    self.docModel.getUploadedDocumentsAPI { status in
                        let bankLetter = self.docModel.uplodaedData?.bankLetter
                        let frontSide = self.docModel.uplodaedData?.frontSideDocURL
                        let backSide = self.docModel.uplodaedData?.backSideDocURL
                        let tradeLicence = self.docModel.uplodaedData?.tradeLicense
                        let bankAdded = self.docModel.uplodaedData?.bankAdded
                        
                        print("Documents are", bankLetter ?? "", tradeLicence ?? "", frontSide ?? "", backSide ?? "")
                        let docsSubmitted = ![bankLetter, frontSide, backSide, tradeLicence].contains { $0?.isEmpty ?? true }
                        if docsSubmitted {
                            if bankAdded == 1 {
                                UserDefaults.isDocumentsSubmitted = true
                            } else {
                                UserDefaults.isDocumentsSubmitted = false
                            }
                        } else {
                            UserDefaults.isDocumentsSubmitted = false
                        }
                    }
                }
            }
        }
    }
    
    func getWalletSetup() {
        viewModel.fetchWalletSetup { isDone in
            self.clearTxt()
            if isDone {
                self.adjustBankDetails(isShow: true)
                self.setBankDetails()
            }
        }
    }
    
    func clearTxt() {
        self.txtBankName.txt.text = ""
        self.txtAccountHolderName.txt.text = ""
        self.txtAccountNumber.txt.text = ""
        self.txtIBANNumber.txt.text = ""
        self.txtSWIFTCode.txt.text = ""
    }
    
    func adjustBankDetails(isShow: Bool) {
        if isShow {
            self.bankNameStackView.isHidden = true
            self.accNumberStackView.isHidden = true
            self.iBANStackView.isHidden = true
            self.accHolderStackView.isHidden = true
            self.swiftCodeStackView.isHidden = true
            self.bankAddedBackView.isHidden = false
            self.bankAddedViewHeightConstraint.constant = self.view.frame.size.height - 350
            self.btnAdd.alpha = 0.6
            self.btnAdd.isUserInteractionEnabled = false
        } else {
            self.bankNameStackView.isHidden = false
            self.accNumberStackView.isHidden = false
            self.iBANStackView.isHidden = false
            self.accHolderStackView.isHidden = false
            self.swiftCodeStackView.isHidden = false
            self.bankAddedBackView.isHidden = true
            self.bankAddedViewHeightConstraint.constant = 0
            self.btnAdd.alpha = 1
            self.btnAdd.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        self.isEdit = false
        self.viewModel.deleteBankDetails { isDone in
            if isDone {
                self.adjustBankDetails(isShow: false)
            }
        }
    }
    
    @IBAction func changeBtnAction(_ sender: Any) {
        self.isEdit = true
        self.adjustBankDetails(isShow: false)
        if let bankDetail = viewModel.bankDetail {
            self.txtAccountHolderName.strText = bankDetail.accountHolderName ?? ""
            self.txtBankName.strText = bankDetail.bankName ?? ""
            self.txtIBANNumber.strText = bankDetail.ibanNumber ?? ""
            self.txtSWIFTCode.strText = bankDetail.swiftCode ?? ""
            self.txtAccountNumber.strText = bankDetail.accountNumber ?? ""
        }
    }
}

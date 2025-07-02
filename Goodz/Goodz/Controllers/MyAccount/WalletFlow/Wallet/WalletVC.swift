//
//  WalletVC.swift
//  Goodz
//
//  Created by Akruti on 11/12/23.
//

import Foundation
import UIKit

class WalletVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    // transaction
    @IBOutlet weak var vwTransaction: UIStackView!
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblAvailableBalance: UILabel!
    @IBOutlet weak var lblBalanceAmount: UILabel!

    @IBOutlet weak var lblEarning: UILabel!
    @IBOutlet weak var lblEarningAmount: UILabel!
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var tblTransaction: UITableView!
    @IBOutlet weak var constHeightTable: NSLayoutConstraint!
    @IBOutlet weak var btnTrasaction: ThemeBlackGrayButton!
    @IBOutlet weak var btnSort: SmallGreenButton!
    @IBOutlet weak var btnWalletSetup: ThemeBlackGrayButton!
    // wallet setup
    @IBOutlet weak var vwWalletSetup: UIStackView!
    
    @IBOutlet weak var btnChangeWithdraw: UIButton!
    @IBOutlet weak var vwWithdraw: UIView!
    @IBOutlet weak var lblWithdrawOption: UILabel!
    @IBOutlet weak var btnChnage: UIButton!
    
    @IBOutlet weak var lblSecure: UILabel!
    
    @IBOutlet weak var lblRemainingDaysTitle: UILabel!
    @IBOutlet weak var lblRemainingDays: UILabel!
    
    @IBOutlet weak var vwScroll: UIScrollView!
    
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblAccountNameValue: UILabel!
    
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblBankNameValue: UILabel!
    
    @IBOutlet weak var lblIBNNumberName: UILabel!
    @IBOutlet weak var lblIBNNumberNameValue: UILabel!
    
    @IBOutlet weak var lblSwiftCodeName: UILabel!
    @IBOutlet weak var lblSwiftCodeNameValue: UILabel!
    
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAccountNumberValue: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var vwBankDetails: UIStackView!
    @IBOutlet weak var lblBankNameTitle: UILabel!
    @IBOutlet weak var txtBankName: AppTextField!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var txtAccountHolderName: AppTextField!
    @IBOutlet weak var lblAccountNumberTitle: UILabel!
    @IBOutlet weak var txtAccountNumber: AppTextField!
    @IBOutlet weak var lblIBANNumber: UILabel!
    @IBOutlet weak var txtIBANNumber: AppTextField!
    @IBOutlet weak var lblSWIFTCode: UILabel!
    @IBOutlet weak var txtSWIFTCode: AppTextField!
    @IBOutlet weak var btnAdd: ThemeGreenButton!
    
    @IBOutlet weak var lblBankLetter: UILabel!
    
    @IBOutlet weak var vwDoc: UIView!
    @IBOutlet weak var btnAttach: ThemeGreenBorderButton!
    @IBOutlet weak var lblDoc: UILabel!
    var attachDocURL : URL?
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : WalletVM = WalletVM()
    var arrSort : [SortModel] = []
   
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnTrasaction.isSelected = true
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblTransaction.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        if self.btnWalletSetup.isSelected {
            
        }
        super.viewWillAppear(animated)
        print(self)
        self.applyStyle()
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.btnWalletSetup.isSelected {
            
        }
        self.tblTransaction.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.setTopButtons()
        self.btnSort.round()
        self.btnChangeWithdraw.underline()
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    func setTopButtons() {
        DispatchQueue.main.async {
            self.btnTrasaction.isSelected = true
            self.btnTrasaction.isHidden = true
            self.btnWalletSetup.isHidden = true
            self.btnTrasaction.addBottomBorderWithColor(color: self.btnTrasaction.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnWalletSetup.addBottomBorderWithColor(color: self.btnWalletSetup.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.tblTransaction.reloadData()
        }
        
        if self.btnTrasaction.isSelected {
            self.setTransactionView()
            self.vwTransaction.isHidden = true
            self.btnSort.isHidden = true
            self.vwWalletSetup.isHidden = true
            self.vwBankDetails.isHidden = true
            self.getWalletDetails()
        } else {
            self.setWalletSetupView()
            self.vwTransaction.isHidden = true
            self.btnSort.isHidden = true
            self.vwWalletSetup.isHidden = true
            self.vwBankDetails.isHidden = true
            self.getWalletSetup()
        }
        
    }
    
    func getWalletDetails() {
        viewModel.fetchMyWalletDetails { isDone in
            if isDone {
                self.vwTransaction.isHidden = false
                self.setWalletDetails()
                self.vwScroll.endRefreshing()
            }else{
                self.vwTransaction.isHidden = true

            }
        }
    }
    
    func getWalletSetup() {
        viewModel.fetchWalletSetup { isDone in
            self.clearTxt()
            self.vwScroll.endRefreshing()
            if isDone {
                self.vwWalletSetup.isHidden = false
                self.vwBankDetails.isHidden = true
                self.setBankDetails()
                
            }else{
                self.vwWalletSetup.isHidden = true
                self.vwBankDetails.isHidden = false
                self.attachDocURL = nil
                self.vwDoc.isHidden = true
                self.btnAttach.isHidden = false
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
    
    func setWalletDetails() {
        if let walletDetail = viewModel.walletDetail {
            lblUsername.text = walletDetail.username
            
            lblBalanceAmount.text = kCurrency + (walletDetail.availableBalance ?? "")
            lblEarningAmount.text = kCurrency + (walletDetail.goodzEarnings ?? "")
            
            if (Int(walletDetail.totalRecords ?? "0") ?? 0) > 5 {
                btnViewAll.isHidden = false
            } else {
                btnViewAll.isHidden = true
            }
            
            self.lblRemainingDays.text = (appDelegate.generalModel?.cashbackDays ?? "") + " Days"
            
            
            
            if self.viewModel.setNumberOfTrasaction() == 0 {
                self.constHeightTable.constant = 300
                self.setNoData(scrollView: self.tblTransaction, noDataType: .nothingHere)
            }
            self.tblTransaction.reloadData()
        }
    }
    
    func setBankDetails() {
        if let bankDetail = viewModel.bankDetail {
            lblAccountNameValue.text = bankDetail.accountHolderName
            lblBankNameValue.text = bankDetail.bankName
            lblIBNNumberNameValue.text = bankDetail.secure_ibanNumber
            lblSwiftCodeNameValue.text = bankDetail.swiftCode
            lblAccountNumberValue.text = bankDetail.secureAccountNumber
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblTransaction && keyPath == "contentSize" {
            if self.viewModel.setNumberOfTrasaction() != 0 {
                self.constHeightTable.constant = self.tblTransaction.contentSize.height
            }
        }
    }
    
    // --------------------------------------------
  
    private func setTransactionView() {
        self.lblUsername.font(font: .semibold, size: .size18)
        self.lblUsername.color(color: .themeBlack)
        
        self.lblAvailableBalance.font(font: .regular, size: .size14)
        self.lblAvailableBalance.color(color: .themeBlack)
        
        self.lblBalanceAmount.font(font: .semibold, size: .size24)
        self.lblBalanceAmount.color(color: .themeBlack)
        
        self.lblEarning.font(font: .medium, size: .size16)
        self.lblEarning.color(color: .themeBlack)
        self.lblEarningAmount.font(font: .semibold, size: .size16)
        self.lblEarningAmount.color(color: .themeBlack)
        
        self.lblTransactions.font(font: .semibold, size: .size18)
        self.lblTransactions.color(color: .themeBlack)
        
        self.btnViewAll.font(font: .medium, size: .size16)
        self.btnViewAll.color(color: .themeBlack)
        
        let nib = UINib(nibName: "TrasactionCell", bundle: nil)
        self.tblTransaction.register(nib, forCellReuseIdentifier: "TrasactionCell")
        self.tblTransaction.dataSource = self
        self.tblTransaction.delegate = self
        self.tblTransaction.reloadData()
        
        self.lblRemainingDaysTitle.font(font: .regular, size: .size16)
        self.lblRemainingDaysTitle.color(color: .themeBlack)
        
        self.lblRemainingDays.font(font: .regular, size: .size14)
        self.lblRemainingDays.color(color: .lightRed)
    }
    
    // --------------------------------------------
    
    private func setWalletSetupView() {
        // user details view
        lblAccountName.font(font: .regular, size: .size14)
        lblAccountName.color(color: .themeGray)
       
        lblBankName.font(font: .regular, size: .size14)
        lblBankName.color(color: .themeGray)
        
        lblIBNNumberName.font(font: .regular, size: .size14)
        lblIBNNumberName.color(color: .themeGray)
        
        lblSwiftCodeName.font(font: .regular, size: .size14)
        lblSwiftCodeName.color(color: .themeGray)
        
        lblAccountNumber.font(font: .regular, size: .size14)
        lblAccountNumber.color(color: .themeGray)
        
        lblAccountNameValue.font(font: .medium, size: .size16)
        lblAccountNameValue.color(color: .themeBlack)
        
        lblBankNameTitle.font(font: .medium, size: .size16)
        lblBankNameValue.color(color: .themeBlack)
        
        lblIBNNumberNameValue.font(font: .medium, size: .size16)
        lblIBNNumberNameValue.color(color: .themeBlack)
        
        lblSwiftCodeNameValue.font(font: .medium, size: .size16)
        lblSwiftCodeNameValue.color(color: .themeBlack)
        
        lblAccountNumberValue.font(font: .medium, size: .size16)
        lblAccountNumberValue.color(color: .themeBlack)
    
        self.lblWithdrawOption.font(font: .semibold, size: .size16)
        self.lblWithdrawOption.color(color: .themeBlack)
        
        self.btnChnage.font(font: .medium, size: .size16)
        self.btnChnage.color(color: .themeBlack)
        
        self.vwWithdraw.cornerRadius(cornerRadius: 4.0)

        self.btnDelete.addTapGesture {
            self.viewModel.deleteBankDetails { isDone in
                if isDone {
                    self.vwWalletSetup.isHidden = true
                    self.vwBankDetails.isHidden = false
                    self.attachDocURL = nil
                    self.vwDoc.isHidden = true
                    self.btnAttach.isHidden = false
                }else{
                    self.vwWalletSetup.isHidden = false
                    self.vwBankDetails.isHidden = true
                }
            }
        }
        
        
        self.btnChangeWithdraw.addTapGesture {
            self.coordinator?.navigateToAddBankDetails(bankDetail: self.viewModel.bankDetail)
        }
        
        self.lblSecure.font(font: .regular, size: .size14)
        self.lblSecure.color(color: .themeDarkGray)
        
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.wallet
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private  func setData() {
        
        self.lblEarning.text = Labels.gOODZEarnings
        self.lblAvailableBalance.text = Labels.availableBalance
        
        self.lblRemainingDaysTitle.text = Labels.remaining_days_to_use_your_cashback
        
        self.lblTransactions.text = Labels.transactions
        self.btnViewAll.setTitle(Labels.viewAll, for: .normal)
        self.btnViewAll.setImage(.iconRight, for: .normal)
        self.btnTrasaction.setTitle(Labels.transactions, for: .normal)
        self.btnWalletSetup.setTitle(Labels.walletSetup, for: .normal)
        self.lblWithdrawOption.text = Labels.bankDetail
        self.lblSecure.text = Labels.yourAccountIsVerifiedAndYourPaymentInfOIsStoredSecurely
        
        self.btnChangeWithdraw.setTitle(Labels.Change, for: .normal)
        self.btnSort.setTitle(self.arrSort.first?.sortTitle ?? "", for: .normal)
        
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
        
        self.lblBankLetter.font(font: .medium, size: .size14)
        self.lblBankLetter.color(color: .themeBlack)
        
        self.txtBankName.txtType = .normalWithoutImage
        self.txtSWIFTCode.txtType = .normalWithoutImage
        self.txtIBANNumber.txtType = .normalWithoutImage
        self.txtAccountNumber.txtType = .normalWithoutImage
        self.txtAccountHolderName.txtType = .normalWithoutImage
        
        self.txtBankName.txt.setAutocapitalization(.words)
        self.txtAccountHolderName.txt.setAutocapitalization(.words)
        
        self.lblBankNameTitle.text = Labels.bankName
        self.txtBankName.placeholder = Labels.enterBankName
        self.lblAccountHolderName.text = Labels.accountHolderName
        self.txtAccountHolderName.placeholder = Labels.enterAccountHolderName
        self.lblAccountNumberTitle.text = Labels.accountNumber
        self.txtAccountNumber.placeholder = Labels.enterAccountNumber
        self.lblIBANNumber.text = Labels.iBANNumber
        self.txtIBANNumber.placeholder = Labels.enterIBANNumber
        self.lblSWIFTCode.text = Labels.enterSWIFTCode
        self.lblBankLetter.text = Labels.bankLetter
        self.txtSWIFTCode.placeholder = Labels.sWIFTCode
        self.btnAdd.setTitle(Labels.add, for: .normal)
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        GlobalRepo.shared.sortListAPI(.sales) { status, data, error in
            if status, let sortList = data {
                self.arrSort = sortList
                self.btnSort.setTitle(self.arrSort.first?.sortTitle ?? "", for: .normal)
            }
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
//        self.apiCalling()
        
        self.setTopViewAction()
        self.setData()
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnTrasactionTapped(_ sender: Any) {
        self.btnTrasaction.isSelected = true
        self.btnWalletSetup.isSelected = false
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnWalletSetupTapped(_ sender: Any) {
        self.btnTrasaction.isSelected = false
        self.btnWalletSetup.isSelected = true
        self.setTopButtons()
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddFundTapped(_ sender: Any) {
    }
    
    // --------------------------------------------
    
    @IBAction func btnWithdrawTapped(_ sender: Any) {
        self.coordinator?.navigateToWithdrawPopup()
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnViewAllTapped(_ sender: Any) {
        self.coordinator?.navigateToTransaction()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSortTapped(_ sender: Any) {
        self.coordinator?.presentSort(data: self.arrSort) { data in
            self.btnSort.setTitle(data.sortTitle, for: .normal)
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddPaymentTapped(_ sender: Any) {
        self.coordinator?.navigateToPaymentOption()
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddTapped(_ sender: Any) {
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
                self.viewModel.AddBankDetails(isEdit: false , bankName: bankName, accountHolder: AccountHolderName, accountNumber: AccountNumber, iBANNumber: IBANNumber, sWIFTCode: SWIFTCode, imgUrl: self.attachDocURL) { isDone in
                    self.getWalletSetup()
                }
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

// --------------------------------------------
// MARK: - UITableView Delegate and DataSource
// --------------------------------------------

extension WalletVC  : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.viewModel.setNumberOfTrasaction()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTransaction = tableView.dequeueReusableCell(indexPath: indexPath) as TrasactionCell
        let data = self.viewModel.setRowData(row: indexPath.row)
        cellTransaction.setData(data: data)
        return cellTransaction
    }
    
    // --------------------------------------------
    
}

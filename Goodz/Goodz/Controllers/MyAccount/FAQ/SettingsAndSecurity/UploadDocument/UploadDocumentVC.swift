//
//  UploadDocumentVC.swift
//  Goodz
//
//  Created by Akruti on 15/12/23.
//

import Foundation
import UIKit

class UploadDocumentVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var btnRequest: ThemeBlackGrayButton!
    @IBOutlet weak var btnUpload: ThemeBlackGrayButton!
    @IBOutlet weak var vwTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwDocument: UIStackView!
    @IBOutlet weak var lblFront: UILabel!
    @IBOutlet weak var btnFrountUpload: SmallGreenBorderButton!
    @IBOutlet weak var btnFirstDoc: SmallGreenButton!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var btnBackUpload: SmallGreenBorderButton!
    @IBOutlet weak var btnDocBack: SmallGreenButton!
    @IBOutlet weak var vwPrivacyPolicy: UIView!
    @IBOutlet weak var lblSecurity: UILabel!
    @IBOutlet weak var lblSecurityDes: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblPrivacyPolicyDes: UILabel!
    @IBOutlet weak var vwDate: UIView!
    @IBOutlet weak var lblReceived: UILabel!
    @IBOutlet weak var lblValidate: UILabel!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var btnUploadValidate: ThemeGreenButton!
    
    // pro user views
    @IBOutlet weak var vwProUser: UIStackView!
    @IBOutlet weak var vwtradeLabel: UIView!
    @IBOutlet weak var lblTrad: UILabel!
    @IBOutlet weak var vwLicense: UIStackView!
    @IBOutlet weak var lblTradeLicense: UILabel!
    @IBOutlet weak var btnUploadLicense: SmallGreenBorderButton!
    @IBOutlet weak var btnDocLicense: SmallGreenButton!
    @IBOutlet weak var lblComplatter: UILabel!
    @IBOutlet weak var btnUploadComplatter: SmallGreenBorderButton!
    @IBOutlet weak var btnDocComplatter: SmallGreenButton!
    @IBOutlet weak var vwTradeDate: UIView!
    @IBOutlet weak var lblTradeReceive: UILabel!
    @IBOutlet weak var lblTradeValidated: UILabel!
    
    @IBOutlet weak var vwComplatter: UIView!
    @IBOutlet weak var lblComplatterReceive: UILabel!
    @IBOutlet weak var lblComplatterValidated: UILabel!
    
    @IBOutlet weak var btnCrossFront: UIButton!
    @IBOutlet weak var btnCrossBack: UIButton!
    @IBOutlet weak var btnCrossTrade: UIButton!
    @IBOutlet weak var btnCrossComLetter: UIButton!
    
    @IBOutlet weak var viewFrontRemove: UIView!
    @IBOutlet weak var viewBackRemove: UIView!
    
    @IBOutlet weak var viewTradeRemove: UIView!
    @IBOutlet weak var viewCompletterRemove: UIView!
    
    @IBOutlet weak var vwMain: UIView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isProUser : Bool = false
    var viewModel : UploadDocumentVM = UploadDocumentVM()
    var frontURL : URL?
    var backURL : URL?
    var comLetterURL : URL?
    var tradeURL : URL?
    var comeFromSignup : Bool = false
    
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
        if appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.documentsSubmitted == "0" {
            self.btnRequest.isSelected = true
        } else {
            self.vwMain.isHidden = true
            self.btnUpload.isSelected = true
            self.apiCalling(isUploadDocument: true)
        }
        self.lblFront.font(font: .medium, size: .size16)
        self.lblFront.color(color: .themeBlack)
        self.lblBack.font(font: .medium, size: .size16)
        self.lblBack.color(color: .themeBlack)
        
        self.lblTradeLicense.font(font: .medium, size: .size16)
        self.lblTradeLicense.color(color: .themeBlack)
        self.lblComplatter.font(font: .medium, size: .size16)
        self.lblComplatter.color(color: .themeBlack)
        
        self.lblSecurity.font(font: .medium, size: .size14)
        self.lblSecurity.color(color: .themeBlack)
        self.lblSecurityDes.font(font: .regular, size: .size14)
        self.lblSecurityDes.color(color: .themeGray)
        
        self.lblPrivacyPolicy.font(font: .medium, size: .size14)
        self.lblPrivacyPolicy.color(color: .themeBlack)
        self.lblPrivacyPolicyDes.font(font: .regular, size: .size14)
        self.lblPrivacyPolicyDes.color(color: .themeGray)
        
        self.lblReceived.font(font: .medium, size: .size14)
        self.lblReceived.color(color: .themeBlack)
        
        self.lblValidate.font(font: .medium, size: .size14)
        self.lblValidate.color(color: .themeBlack)
        
        self.lblTradeReceive.font(font: .medium, size: .size14)
        self.lblTradeReceive.color(color: .themeBlack)
        self.lblTradeValidated.font(font: .medium, size: .size14)
        self.lblTradeValidated.color(color: .themeBlack)
        
        self.lblComplatterReceive.font(font: .medium, size: .size14)
        self.lblComplatterReceive.color(color: .themeBlack)
        self.lblComplatterValidated.font(font: .medium, size: .size14)
        self.lblComplatterValidated.color(color: .themeBlack)
        
        self.lblAgree.font(font: .regular, size: .size14)
        self.lblAgree.color(color: .themeGray)
        
        self.vwDate.cornerRadius(cornerRadius: 4.0)
        self.vwDocument.cornerRadius(cornerRadius: 0)
        self.vwTitle.cornerRadius(cornerRadius: 4.0)
        
        self.vwProUser.isHidden = true
        
        self.btnRequest.setTitle(Labels.requested, for: .normal)
        self.btnUpload.setTitle(Labels.uploaded, for: .normal)
        
    }
    
    // --------------------------------------------
    
    func apiCalling(isUploadDocument: Bool = false) {
        self.viewModel.getUploadedDocumentsAPI { status in
            if status {
                self.setAPICalling()
                self.vwMain.isHidden = false
                if isUploadDocument {
                   // notifier.showToast(message: Labels.uploadDocumentSuccessfully)
                }
            }
        }
    }
    
    // --------------------------------------------
    
    func setAPICalling() {
        self.vwDocument.isHidden = false
        
        let data = self.viewModel.uplodaedData
       
        self.frontURL = data?.frontSideDocURL?.toURL()
        self.backURL = data?.backSideDocURL?.toURL()
        self.comLetterURL = data?.companyLetterHead?.toURL()
        self.tradeURL = data?.tradeLicense?.toURL()
        
        self.btnDocBack.setTitle(backURL?.lastPathComponent, for: .normal)
        self.btnFirstDoc.setTitle(frontURL?.lastPathComponent, for: .normal)
        self.btnDocComplatter.setTitle(comLetterURL?.lastPathComponent, for: .normal)
        self.btnDocLicense.setTitle(tradeURL?.lastPathComponent, for: .normal)
        
        self.btnFirstDoc.setTitleColor(.themeWhite, for: .normal)
        self.btnDocBack.setTitleColor(.themeWhite, for: .normal)

        let emiratesReceivedDate = (data?.emiratesIdReceivedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        let emiratesValidatedDate = (data?.emiratesIdValidatedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        
        self.lblReceived.text = Labels.emiratesIDReceivedOn + " " + emiratesReceivedDate
        self.lblValidate.text = Labels.emiratesIDValidatedOn +  " " + emiratesValidatedDate
        
        let tradeLicenseReceivedDate = (data?.tradeLicenseReceivedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        let tradeLicenseValidatedDate = (data?.tradeLicenseValidatedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        
        self.lblTradeReceive.text = Labels.tradeLicenceReceivedOn + " " + tradeLicenseReceivedDate
        self.lblTradeValidated.text = Labels.tradeLicenceValidatedOn + " " + tradeLicenseValidatedDate
        
        let letterHeadReceivedDate = (data?.letterHeadReceivedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        let letterHeadValidatedDate = (data?.letterHeadValidatedDate ?? "").UTCToLocal(inputFormat: DateFormat.MMDDyyyy, outputFormat: DateFormat.appDateFormateMMddYYY)
        
        self.lblComplatterReceive.text = Labels.companyLetterheadReceivedOn + " " + letterHeadReceivedDate
        self.lblComplatterValidated.text = Labels.companyLetterheadValidatedOn + " " + letterHeadValidatedDate

        viewFrontRemove.isHidden = frontURL == nil
        viewBackRemove.isHidden = backURL == nil
        
        if isProUser {
            viewTradeRemove.isHidden = tradeURL == nil
            viewCompletterRemove.isHidden = comLetterURL == nil
        }
        
        btnFrountUpload.isHidden = frontURL != nil
        btnBackUpload.isHidden = backURL != nil
        
        if isProUser {
            btnUploadLicense.isHidden = tradeURL != nil
            btnUploadComplatter.isHidden = comLetterURL != nil
        }
    }
    
    // --------------------------------------------
    
    func setTopButton() {
        DispatchQueue.main.async {
            self.btnRequest.addBottomBorderWithColor(color: self.btnRequest.isSelected ? .themeBlack : .themeBorder, width: 2)
            self.btnUpload.addBottomBorderWithColor(color: self.btnUpload.isSelected ? .themeBlack : .themeBorder, width: 2)
        }
        
        if self.btnRequest.isSelected {
            self.setViewofRequest()
        } else {
            self.setViewofUpload()
        }
    }
    
    // --------------------------------------------
    
    func setViewofRequest() {
        if isProUser {
            self.vwtradeLabel.isHidden = true
            self.btnUploadLicense.isHidden = true
            self.btnDocLicense.superview?.isHidden = true
            self.btnUploadComplatter.isHidden = true
            self.btnDocComplatter.superview?.isHidden = true
            self.vwTradeDate.isHidden = true
            self.vwComplatter.isHidden = true
        }

        self.vwtradeLabel.isHidden = true

        self.btnUploadValidate.setTitle(Labels.uploadMyDocuments, for: .normal)
        self.vwTitle.isHidden = false
        self.btnFrountUpload.isHidden = false
        self.btnBackUpload.isHidden = false
        self.vwDate.isHidden = true
        self.vwPrivacyPolicy.isHidden = true
        self.btnDocBack.superview?.isHidden = true
        self.btnFirstDoc.superview?.isHidden = true
    }
    
    // --------------------------------------------
    
    func setViewofUpload() {
        if isProUser {
            self.vwtradeLabel.isHidden = true
            self.btnUploadLicense.isHidden = true
            self.btnDocLicense.superview?.isHidden = true
            self.btnUploadComplatter.isHidden = true
            self.btnDocComplatter.superview?.isHidden = true
            self.vwTradeDate.isHidden = true
            self.vwComplatter.isHidden = true
        }

        self.vwtradeLabel.isHidden = true

        self.btnUploadValidate.setTitle(Labels.validateChanges, for: .normal)
        self.vwTitle.isHidden = true
        self.btnFrountUpload.isHidden = true
        self.btnBackUpload.isHidden = true
        self.vwDate.isHidden = true
        self.vwPrivacyPolicy.isHidden = true
        self.btnDocBack.superview?.isHidden = false
        self.btnFirstDoc.superview?.isHidden = false

    }
    
    // --------------------------------------------
    
    private func setData() {
        
        self.lblTitle.text = Labels.pleaseUploadYourEmirates
        self.lblSecurity.text = Labels.yourSecurityIsOurPriority
        self.lblSecurityDes.text = Labels.weRequireYourEmirates
        self.lblPrivacyPolicy.text = Labels.privacyPolicy
        self.lblPrivacyPolicyDes.text = Labels.yourInformationIsUsedSolely
        self.lblAgree.text = "I hereby certified that all the information transmitted are accurate and accept GOODZ general T&C’s"
        
        self.lblTradeLicense.text = Labels.tradeLicense
        self.lblComplatter.text = Labels.companyLetterHead
        
        self.btnAgree.setImage(.iconUncheckBox, for: .normal)
        self.btnAgree.setImage(.iconCheckSquare, for: .selected)
        
        self.btnAgree.addTapGesture {
            self.btnAgree.isSelected.toggle()
        }
        
        self.lblFront.text = Labels.front
        self.lblBack.text = Labels.back
        self.btnFrountUpload.setTitle(Labels.upload, for: .normal)
        self.btnFrountUpload.setImage(.iconUpload, for: .normal)
        self.btnBackUpload.setTitle(Labels.upload, for: .normal)
        self.btnBackUpload.setImage(.iconUpload, for: .normal)
        self.btnFirstDoc.setImage(.iconCrossSmall, for: .normal)
        self.btnDocBack.setImage(.iconCrossSmall, for: .normal)
        
        self.lblTitle.setAttributeText(fulltext: Labels.pleaseUploadYourEmirates, range1: Labels.pleaseUploadYour, range2: Labels.emirates, range3: Labels.toBeginTheverificationProcess.lowercaseFirstLetter())
        self.lblTrad.setAttributeText(fulltext: Labels.submittingYourTradeLicense, range1: Labels.submittingYour, range2: Labels.tradeLicenseAndCompanyLetterhead, range3: Labels.establishesYourCompanyLegitimacy)
    
    }
    
    // --------------------------------------------
    
    func setFrontDoc() {
        self.btnFrountUpload.addTapGesture {
            self.setOpenLibrary() { url in
                self.btnFirstDoc.superview?.isHidden = false
                self.btnFirstDoc.setTitle(url?.lastPathComponent, for: .normal)
                self.frontURL = url
                self.btnFrountUpload.isHidden = true
                
                self.hideShowBtnUpload()
            }
        }
        self.btnCrossFront.addTapGesture {
            self.btnFirstDoc.superview?.isHidden = true
            self.frontURL = nil
            self.btnFrountUpload.isHidden = false
            
            self.hideShowBtnUpload()
        }
    }
    
    // --------------------------------------------
    
    func setBackDoc() {
        self.btnBackUpload.addTapGesture {
            self.setOpenLibrary() { url in
                self.btnDocBack.superview?.isHidden = false
                self.backURL = url
                self.btnDocBack.setTitle(url?.lastPathComponent, for: .normal)
                self.btnBackUpload.isHidden = true
                
                self.hideShowBtnUpload()
            }
        }
        
        self.btnCrossBack.addTapGesture {
            self.btnDocBack.superview?.isHidden = true
            self.backURL =  nil
            self.btnBackUpload.isHidden = false
            
            self.hideShowBtnUpload()
        }
        
    }
    
    // --------------------------------------------
    
    func setCompLetterDoc() {
        self.btnUploadComplatter.addTapGesture {
            self.setOpenLibrary() { url in
                self.btnDocComplatter.superview?.isHidden = false
                self.comLetterURL = url
                self.btnDocComplatter.setTitle(url?.lastPathComponent, for: .normal)
                self.btnUploadComplatter.isHidden = true
            }
        }
        
        self.btnCrossComLetter.addTapGesture {
            self.btnCrossComLetter.superview?.isHidden = true
            self.comLetterURL =  nil
            self.btnUploadComplatter.isHidden = false
        }
    }
    
    // --------------------------------------------
    
    func clearRequestedDocUI() {
        self.btnDocBack.superview?.isHidden = true
        self.backURL =  nil
        self.btnBackUpload.isHidden = false
        
        self.btnFirstDoc.superview?.isHidden = true
        self.frontURL = nil
        self.btnFrountUpload.isHidden = false
    }
    
    func hideShowBtnUpload() {
//        if frontURL != nil && backURL != nil {
//            btnUploadValidate.isHidden = false
//            btnAgree.superview?.isHidden = false
//        } else {
//            btnUploadValidate.isHidden = true
//            btnAgree.superview?.isHidden = true
//        }
    }
    
    func setTradeDoc() {
        self.btnUploadLicense.addTapGesture {
            self.setOpenLibrary() { url in
                self.btnDocLicense.superview?.isHidden = false
                self.tradeURL = url
                self.btnDocLicense.setTitle(url?.lastPathComponent, for: .normal)
                self.btnUploadLicense.isHidden = true
            }
        }
        
        self.btnCrossTrade.addTapGesture {
            self.btnCrossTrade.superview?.isHidden = true
            self.tradeURL =  nil
            self.btnUploadLicense.isHidden = false
        }
    }
    
    // --------------------------------------------
    
    func setOpenLibrary(completion: @escaping ((URL?) -> Void)) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary,.file], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (img,imgUrl) in
            print(img)
            completion(imgUrl)
        }
        AttachmentHandler.shared.filePickedBlock = { (fileType, url, img) in
           print(url)
            completion(url)
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = "Emirates ID"
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopButton()
        self.setTopViewAction()
        self.setFrontDoc()
        self.setBackDoc()
        self.setCompLetterDoc()
        self.setTradeDoc()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
 
    @IBAction func bntnRequestTapped(_ sender: Any) {
        self.btnRequest.isSelected = true
        self.btnUpload.isSelected = false
        self.vwDocument.isHidden = false
        self.setTopButton()
    }
    
    // --------------------------------------------
    
    @IBAction func btnUploadTapped(_ sender: Any) {
        self.apiCalling()
        self.btnRequest.isSelected = false
        self.btnUpload.isSelected = true
        self.vwDocument.isHidden = true
        self.setTopButton()
    }
    
    // --------------------------------------------
 
    private func validation(completion : (Bool) -> Void) {
        if isProUser {
//            if self.frontURL == nil || self.backURL == nil || self.tradeURL == nil || self.comLetterURL == nil {
           if self.frontURL == nil || self.backURL == nil {
                notifier.showToast(message: Labels.pleaseUploadAllDocument)
                completion(false)
            } else  {
                completion(true)
            }
        } else {
            if self.frontURL == nil || self.backURL == nil {
                notifier.showToast(message: Labels.pleaseUploadAllDocument)
                completion(false)
            } else  {
                completion(true)
            }
        }
    }
    @IBAction func btnUpdateTapped(_ sender: Any) {
        self.validation { Status in
            if Status {
                if self.btnRequest.isSelected {

                    if self.btnAgree.isSelected {
                        showAlert(title: "", message: Labels.areYouSureYouWantToUploadYourDocuments ) {
                            self.viewModel.uploadDocumentsAPI(frontSideDocUrl: self.frontURL, backSideDocUrl: self.backURL, tradeLicense: self.tradeURL, companyLetterHead: self.comLetterURL) { [self] status in
                                if status {
                                    self.viewModel.getUploadedDocumentsAPI { status in
                                        let bankLetter = self.viewModel.uplodaedData?.bankLetter
                                        let frontSide = self.viewModel.uplodaedData?.frontSideDocURL
                                        let backSide = self.viewModel.uplodaedData?.backSideDocURL
                                        let tradeLicence = self.viewModel.uplodaedData?.tradeLicense
                                        let bankAdded = self.viewModel.uplodaedData?.bankAdded
                                        
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
                                    clearRequestedDocUI()
                                    notifier.showToast(message: Labels.uploadDocumentSuccessfully)
                                    if self.comeFromSignup {
                                        self.coordinator?.navigateToProSplash(isComeFromSignup: true)
                                    } else {
                                        self.coordinator?.popVC()
                                    }
                                }
                            }
                        }
                    } else {
                        notifier.showToast(message: Labels.pleaseAgreeWithTearmsCondition)
                    }
                    
                } else {
                    
                    if self.btnAgree.isSelected {
                        showAlert(title: "", message: Labels.areYouSureYouWantToUpdateYourDocuments ) {
                            self.viewModel.uploadDocumentsAPI(frontSideDocUrl: self.frontURL, backSideDocUrl: self.backURL, tradeLicense: self.tradeURL, companyLetterHead: self.comLetterURL) { status in
                                if status {
                                    self.viewModel.getUploadedDocumentsAPI { status in
                                        let bankLetter = self.viewModel.uplodaedData?.bankLetter
                                        let frontSide = self.viewModel.uplodaedData?.frontSideDocURL
                                        let backSide = self.viewModel.uplodaedData?.backSideDocURL
                                        let tradeLicence = self.viewModel.uplodaedData?.tradeLicense
                                        
                                        print("Documents are", bankLetter ?? "", tradeLicence ?? "", frontSide ?? "", backSide ?? "")
                                        let docsSubmitted = ![bankLetter, frontSide, backSide, tradeLicence].contains { $0?.isEmpty ?? true }
                                        if docsSubmitted {
                                            UserDefaults.isDocumentsSubmitted = true
                                        } else {
                                            UserDefaults.isDocumentsSubmitted = false
                                        }
                                    }
                                    notifier.showToast(message: Labels.uploadDocumentSuccessfully)
                                    if self.comeFromSignup {
                                        self.coordinator?.navigateToProSplash(isComeFromSignup: true)
                                    } else {
                                        self.coordinator?.popVC()
                                    }
                                }
                            }
                        }
                    } else {
                        notifier.showToast(message: Labels.pleaseAgreeWithTearmsCondition)
                    }
                }
            }
        }
    }
}

//
//  TradeLicenceVC.swift
//  Goodz
//
//  Created by dipesh on 05/02/25.
//

import UIKit

class TradeLicenceVC: BaseVC {
    
    @IBOutlet weak var appTopView: AppStatusView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tradeLicenceLbl: UILabel!
    @IBOutlet weak var tradeLicenceUploadBtn: SmallGreenBorderButton!
    
    @IBOutlet weak var tradeLicenceRemoveView: UIView!
    @IBOutlet weak var tradeLicenceDocBtn: SmallGreenButton!
    @IBOutlet weak var tradeLicenceCrossBtn: UIButton!
    
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var agreeLbl: UILabel!
    
    @IBOutlet weak var uploadValidateBtn: ThemeGreenButton!
    
    var viewModel : UploadDocumentVM = UploadDocumentVM()
    var tradeLicenceURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalling()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopViewAction()
        self.setBankLetterDoc()
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
//        if appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.documentsSubmitted == "0" {
//            self.btnRequest.isSelected = true
//        } else {
//            self.vwMain.isHidden = true
//            self.btnUpload.isSelected = true
//            self.apiCalling(isUploadDocument: true)
//        }
        self.tradeLicenceLbl.font(font: .medium, size: .size14)
        self.tradeLicenceLbl.color(color: .themeBlack)
        
        
        self.agreeLbl.font(font: .regular, size: .size14)
        self.agreeLbl.color(color: .themeGray)
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        
        self.titleLbl.text = "Please upload your Trade Licence to begin the verification process and enjoy the full benefits of Goodz:"
        self.agreeLbl.text = "I hereby certified that all the information transmitted are accurate and accept GOODZ general T&C’s"
        
        self.agreeBtn.setImage(.iconUncheckBox, for: .normal)
        self.agreeBtn.setImage(.iconCheckSquare, for: .selected)
        
        self.agreeBtn.addTapGesture {
            self.agreeBtn.isSelected.toggle()
        }
        
        self.tradeLicenceLbl.text = "Trade License (mandatory)"
        self.tradeLicenceUploadBtn.setTitle(Labels.upload, for: .normal)
        self.tradeLicenceUploadBtn.setImage(.iconUpload, for: .normal)
        
        self.tradeLicenceDocBtn.setImage(.iconCrossSmall, for: .normal)
        
        self.titleLbl.setAttributeText(fulltext: "Please upload your Trade License to begin the verification process and enjoy the full benefits of Goodz:", range1: "Please upload your", range2: "Trade License", range3: "to begin the verification process and enjoy the full benefits of Goodz:")
        self.uploadValidateBtn.setTitle(Labels.uploadMyDocuments, for: .normal)
        self.tradeLicenceDocBtn.superview?.isHidden = true
        
        tradeLicenceDocBtn.setTitleColor(.themeWhite, for: .normal)
    
    }
    
    // --------------------------------------------
    
    func setBankLetterDoc() {
        self.tradeLicenceUploadBtn.addTapGesture {
            self.setOpenLibrary() { url in
                self.tradeLicenceDocBtn.superview?.isHidden = false
                self.tradeLicenceDocBtn.setTitle(url?.lastPathComponent, for: .normal)
                self.tradeLicenceURL = url
                self.tradeLicenceUploadBtn.isHidden = true
            }
        }
        self.tradeLicenceCrossBtn.addTapGesture {
            self.tradeLicenceDocBtn.superview?.isHidden = true
            self.tradeLicenceURL = nil
            self.tradeLicenceUploadBtn.isHidden = false
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
        self.appTopView.textTitle = "Trade License"
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.getUploadedDocumentsAPI { status in
            if status {
                self.setAPICalling()
            }
        }
    }
    
    //---------------------------------------------
    
    func setAPICalling() {
        let data = self.viewModel.uplodaedData
        if data?.tradeLicense != "" {
            self.tradeLicenceDocBtn.superview?.isHidden = false
            self.tradeLicenceURL = data?.tradeLicense?.toURL()
            self.tradeLicenceUploadBtn.isHidden = true
            self.tradeLicenceDocBtn.setTitle(tradeLicenceURL?.lastPathComponent, for: .normal)
            self.uploadValidateBtn.setTitle(Labels.validateChanges, for: .normal)
        } else {
            self.tradeLicenceDocBtn.superview?.isHidden = true
            self.tradeLicenceURL = nil
            self.tradeLicenceUploadBtn.isHidden = false
            self.uploadValidateBtn.setTitle(Labels.uploadDocuments, for: .normal)
        }
    }
    
    //---------------------------------------------
    // MARK: - Actions
    
    @IBAction func uploadValidateBtnAction(_ sender: Any) {
        print("Upload docs clicked")
        self.validation { Status in
            if Status {
                if self.agreeBtn.isSelected {
                    showAlert(title: "", message: Labels.areYouSureYouWantToUpdateYourDocuments ) {
                        self.viewModel.uploadTradeLicenceAPI(tradeLicenceUrl: self.tradeLicenceURL) { status in
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
                                notifier.showToast(message: Labels.uploadDocumentSuccessfully)
                                self.coordinator?.popVC()
                            }
                        }
                    }
                } else {
                    notifier.showToast(message: Labels.pleaseAgreeWithTearmsCondition)
                }
            }
        }
    }
    
    // --------------------------------------------
 
    private func validation(completion : (Bool) -> Void) {
        if self.tradeLicenceURL == nil {
            notifier.showToast(message: Labels.pleaseUploadtradeLicence)
            completion(false)
        } else  {
            completion(true)
        }
    }
    
}


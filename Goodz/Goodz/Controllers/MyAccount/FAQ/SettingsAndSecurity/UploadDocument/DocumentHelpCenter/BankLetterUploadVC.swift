//
//  BankLetterUploadVC.swift
//  Goodz
//
//  Created by Dipesh on 04/02/25.
//

import UIKit

class BankLetterUploadVC: BaseVC {

    @IBOutlet weak var appTopView: AppStatusView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var bankLetterLbl: UILabel!
    @IBOutlet weak var bankLetterUploadBtn: SmallGreenBorderButton!
    
    @IBOutlet weak var bankLetterRemoveView: UIView!
    @IBOutlet weak var bankLetterDocBtn: SmallGreenButton!
    @IBOutlet weak var bankLetterCrossBtn: UIButton!
    
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var agreeLbl: UILabel!
    
    @IBOutlet weak var uploadValidateBtn: ThemeGreenButton!
    
    var viewModel : UploadDocumentVM = UploadDocumentVM()
    var bankLetterUrl: URL?
    
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
        self.bankLetterLbl.font(font: .medium, size: .size14)
        self.bankLetterLbl.color(color: .themeBlack)
        
        self.agreeLbl.font(font: .regular, size: .size14)
        self.agreeLbl.color(color: .themeGray)
    }
    
    // --------------------------------------------
    
    private func setData() {
        
        self.titleLbl.text = "Please upload your Bank Letter to begin the verification process and enjoy the full benefits of Goodz:"
        self.agreeLbl.text = "I hereby certified that all the information transmitted are accurate and accept GOODZ general T&C’s"
        
        self.agreeBtn.setImage(.iconUncheckBox, for: .normal)
        self.agreeBtn.setImage(.iconCheckSquare, for: .selected)
        
        self.agreeBtn.addTapGesture {
            self.agreeBtn.isSelected.toggle()
        }
        
        self.bankLetterLbl.text = "Bank Letter (mandatory)"
        self.bankLetterUploadBtn.setTitle(Labels.upload, for: .normal)
        self.bankLetterUploadBtn.setImage(.iconUpload, for: .normal)
        
        self.bankLetterDocBtn.setImage(.iconCrossSmall, for: .normal)
        
        self.titleLbl.setAttributeText(fulltext: "Please upload your Bank Letter to begin the verification process and enjoy the full benefits of Goodz:", range1: "Please upload your", range2: "Bank Letter", range3: "to begin the verification process and enjoy the full benefits of Goodz:")
        self.uploadValidateBtn.setTitle(Labels.uploadMyDocuments, for: .normal)
        self.bankLetterDocBtn.superview?.isHidden = true
        
        bankLetterDocBtn.setTitleColor(.themeWhite, for: .normal)
    
    }
    
    // --------------------------------------------
    
    func setBankLetterDoc() {
        self.bankLetterUploadBtn.addTapGesture {
            self.setOpenLibrary() { url in
                self.bankLetterDocBtn.superview?.isHidden = false
                self.bankLetterDocBtn.setTitle(url?.lastPathComponent, for: .normal)
                self.bankLetterUrl = url
                self.bankLetterUploadBtn.isHidden = true
            }
        }
        self.bankLetterCrossBtn.addTapGesture {
            self.bankLetterDocBtn.superview?.isHidden = true
            self.bankLetterUrl = nil
            self.bankLetterUploadBtn.isHidden = false
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
        self.appTopView.textTitle = Labels.bankLetter
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
        if data?.bankLetter != "" {
            self.bankLetterDocBtn.superview?.isHidden = false
            self.bankLetterUrl = data?.bankLetter?.toURL()
            self.bankLetterUploadBtn.isHidden = true
            self.bankLetterDocBtn.setTitle(bankLetterUrl?.lastPathComponent, for: .normal)
            self.uploadValidateBtn.setTitle(Labels.validateChanges, for: .normal)
        } else {
            self.bankLetterDocBtn.superview?.isHidden = true
            self.bankLetterUrl = nil
            self.bankLetterUploadBtn.isHidden = false
            self.uploadValidateBtn.setTitle(Labels.uploadDocuments, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func uploadValidateBtnAction(_ sender: Any) {
        print("Upload docs clicked")
        self.validation { Status in
            if Status {
                if self.agreeBtn.isSelected {
                    showAlert(title: "", message: Labels.areYouSureYouWantToUpdateYourDocuments ) {
                        self.viewModel.uploadBankLetterAPI(bankLetterUrl: self.bankLetterUrl) { status in
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
        if self.bankLetterUrl == nil {
            notifier.showToast(message: Labels.pleaseUploadBankLetter)
            completion(false)
        } else  {
            completion(true)
        }
    }
}

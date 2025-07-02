//
//  DocHelpCenterViewCont.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 03/02/25.
//

import UIKit

class DocHelpCenterViewCont : BaseVC  {
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var docsTypeStackView: UIStackView!
    @IBOutlet weak var emiratesIDBGView: UIView!
    @IBOutlet weak var emiratesIDLbl: UILabel!
    @IBOutlet weak var emirateIDStatusBtn: UIButton!
    @IBOutlet weak var tradeLicenceBGView: UIView!
    @IBOutlet weak var tradeLicenceLbl: UILabel!
    @IBOutlet weak var tradeLicenceStatusBtn: UIButton!
    @IBOutlet weak var bankLetterBGView: UIView!
    @IBOutlet weak var bankLetterLbl: UILabel!
    @IBOutlet weak var bankLetterStatusBtn: UIButton!
    @IBOutlet weak var bankAccountBGView: UIView!
    @IBOutlet weak var bankAccountLbl: UILabel!
    @IBOutlet weak var bankAccStatusBtn: UIButton!
    @IBOutlet weak var descBGView: UIView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
    var isProUser: Bool = false
    var viewModel : UploadDocumentVM = UploadDocumentVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isProUser {
            self.scrollViewHeightConstraint.constant = 850
        } else {
            self.scrollViewHeightConstraint.constant = 750
        }
        self.getUploadDocsStatus()
    }
    
    func setUpUI() {
        
        self.setTopViewAction()
        
        self.docsTypeStackView.cornerRadius = 5
        
        self.emiratesIDLbl.font(font: .regular, size: .size16)
        self.emiratesIDLbl.color(color: .themeBlack)
        
        self.tradeLicenceLbl.font(font: .regular, size: .size16)
        self.tradeLicenceLbl.color(color: .themeBlack)
        
        self.bankLetterLbl.font(font: .regular, size: .size16)
        self.bankLetterLbl.color(color: .themeBlack)
        
        self.bankAccountLbl.font(font: .regular, size: .size16)
        self.bankAccountLbl.color(color: .themeBlack)
        
        self.descLbl.font(font: .regular, size: .size14)
        self.descLbl.lineBreakMode = .byWordWrapping
        
        self.emirateIDStatusBtn.cornerRadius = 5
        self.tradeLicenceStatusBtn.cornerRadius = 5
        self.bankLetterStatusBtn.cornerRadius = 5
        self.bankAccStatusBtn.cornerRadius = 5
        
        self.emirateIDStatusBtn.titleLabel?.font(font: .medium, size: .size13)
        self.tradeLicenceStatusBtn.titleLabel?.font(font: .medium, size: .size13)
        self.bankLetterStatusBtn.titleLabel?.font(font: .medium, size: .size13)
        self.bankAccStatusBtn.titleLabel?.font(font: .medium, size: .size13)
        
        
        var text = ""
        if self.isProUser {
            text = """
        Why do we need these Documents for every seller?
        These documents are required by the Payment providers and UAE laws to be able to pay you for every sale you are making in Goodz.
        
        Emirates ID:
        Your Emirates ID confirms your Identity and ensures a secure experience for the community.
        
        Trade License:
        Your Trade License confirm the existence of the company and your right to sell.
        
        Bank Letter:
        To verify that the bank account provided is valid and belongs to you ensuring smooth and secure payment.
        
        Bank Account:
        Allows us to transfer your earning directly to your bank account safely and fastly.
        
        Private Policy:
        Your information is used solely for verification and is never shared without your consent
        """
        } else {
            text = """
        Why do we need these Documents for every seller?
        These documents are required by the Payment providers and UAE laws to be able to pay you for every sale you are making in Goodz.
        
        Emirates ID:
        Your Emirates ID confirms your Identity and ensures a secure experience for the community.
        
        Bank Letter:
        To verify that the bank account provided is valid and belongs to you ensuring smooth and secure payment.
        
        Bank Account:
        Allows us to transfer your earning directly to your bank account safely and fastly.
        
        Private Policy:
        Your information is used solely for verification and is never shared without your consent
        """
        }

        let attributedText = NSMutableAttributedString(string: text)

        // Define attributes for bold text
        if let customBoldFont = UIFont(name: "Poppins-SemiBold", size: 16) {
            let boldAttributes: [NSAttributedString.Key: Any] = [.font: customBoldFont]
            
            // Apply bold formatting to specific words
            let boldTexts = ["Why do we need these Documents for every seller?",
                             "Emirates ID:",
                             "Trade License:",
                             "Bank Letter:",
                             "Bank Account:",
                             "Private Policy"]
            
            for boldText in boldTexts {
                if let range = text.range(of: boldText) {
                    let nsRange = NSRange(range, in: text)
                    attributedText.addAttributes(boldAttributes, range: nsRange)
                }
            }
        }
        // Assign the attributed text to your UILabel
        self.descLbl.attributedText = attributedText
        
        self.emiratesIDBGView.roundTopCorners(radius: 5)
        self.bankAccountBGView.roundBottomCorners(radius: 5)
        
        addTapGesture(to: emiratesIDBGView, action: #selector(emiratesIDBGViewTapped))
        addTapGesture(to: bankLetterBGView, action: #selector(bankLetterBGViewTapped))
        addTapGesture(to: bankAccountBGView, action: #selector(bankAccountBGTapped))
        addTapGesture(to: tradeLicenceBGView, action: #selector(tradeLicenceBGTapped))
        
        if self.isProUser {
            self.tradeLicenceBGView.isHidden = false
        } else {
            self.tradeLicenceBGView.isHidden = true
        }
            
    }
    
    func setTopViewAction() {
        self.appTopView.textTitle = "My Documents"
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    func getUploadDocsStatus() {
        self.viewModel.getUploadedDocumentsAPI { status in
            
            let bankLetterReceived = self.viewModel.uplodaedData?.bankLetterReceivedDate
            let bankLetterStatus = self.viewModel.uplodaedData?.bankLetterStatus
            let emiratesIdReceived = self.viewModel.uplodaedData?.emiratesIdReceivedDate
            let emiratesIdStatus = self.viewModel.uplodaedData?.emiratesStatus
            let tradeLicenceReceived = self.viewModel.uplodaedData?.tradeLicenseReceivedDate
            let tradeLicenceStatus = self.viewModel.uplodaedData?.tradeLicenseStatus
            let bankAdded = self.viewModel.uplodaedData?.bankAdded
            
            self.updateButton(self.bankLetterStatusBtn, received: bankLetterReceived, status: bankLetterStatus)
            self.updateButton(self.emirateIDStatusBtn, received: emiratesIdReceived, status: emiratesIdStatus)
            self.updateButton(self.tradeLicenceStatusBtn, received: tradeLicenceReceived, status: tradeLicenceStatus)
            
            if bankAdded == 0 {
                self.updateButton(self.bankAccStatusBtn, received: "", status: 0)
            } else if bankAdded == 1 {
                self.updateButton(self.bankAccStatusBtn, received: "2025-02-11", status: 1)
            }
        }
    }
    
    func updateButton(_ button: UIButton, received: String?, status: Int?) {
        if let receivedDate = received, !receivedDate.isEmpty {
            switch status {
            case 0:
                button.backgroundColor = .themeGreenProfile
                button.setTitle("Uploaded", for: .normal)
            case 1:
                button.backgroundColor = .themeDarkGreen
                button.setTitle("Approved", for: .normal)
            case 2:
                button.backgroundColor = .red
                button.setTitle("Rejected", for: .normal)
            default:
                button.backgroundColor = .themeYellow
                button.setTitle("Not Added", for: .normal)
            }
        } else {
            button.backgroundColor = .themeYellow
            button.setTitle("Not Added", for: .normal)
        }
        
        button.setTitleColor(.white, for: .normal)
    }
    
    // Function to add tap gesture to a view
    private func addTapGesture(to view: UIView, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        view.isUserInteractionEnabled = true // Ensure interaction is enabled
        view.addGestureRecognizer(tapGesture)
    }
    
    // Gesture Handlers
    @objc func emiratesIDBGViewTapped() {
        print("First view tapped!")
        self.coordinator?.navigateToUploadDocument(isPro: appUserDefaults.getValue(.isProUser) ?? false)
    }
    
    @objc func tradeLicenceBGTapped() {
        print("Second view tapped!")
        self.coordinator?.navigateToTradeLicence()
    }
    
    @objc func bankLetterBGViewTapped() {
        print("Second view tapped!")
        self.coordinator?.navigateToBankLetter()
    }
    
    @objc func bankAccountBGTapped() {
        print("Third view tapped!")
        self.coordinator?.navigateToBankDetailsVC()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

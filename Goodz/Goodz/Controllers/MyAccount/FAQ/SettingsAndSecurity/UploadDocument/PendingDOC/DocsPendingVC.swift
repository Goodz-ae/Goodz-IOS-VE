//
//  DocsPendingVC.swift
//  Goodz
//
//  Created by dipesh on 31/01/25.
//

import UIKit

class DocsPendingVC: BaseVC {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var appStatusView: AppStatusView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var uploadDocsLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var homeBtn: ThemeGreenBorder14Button!
    @IBOutlet weak var uploadDocsBtn: ThemeGreen14Button!
    
    var fromSellVc: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    //-------------------------------
    // MARK: - UI Setup
    
    func setUpUI() {
        
        if !self.fromSellVc {
            self.appStatusView.isHidden = true
            self.view.backgroundColor = .white.withAlphaComponent(0.6)
            self.homeBtn.isHidden = true
            self.uploadDocsBtn.setTitle(Labels.uploadMyDocumentsNow, for: .normal)
            self.uploadDocsBtn.setTitleColor(.themeWhite, for: .normal)
            self.uploadDocsLbl.text = "Complete your profile"
            self.descLbl.text = "To enjoy the full benefits of GOODZ and receive your money when you sell product"
            self.cancelBtn.isHidden = false
            self.backgroundView.backgroundColor = .white
            self.topView.isHidden = true
            self.backgroundView.dropShadow(ShadowColor: .black, radius: 2, Height: 0.5, Width: 0.5, Opacity: 0.4, CornerRadius: 10)
        } else {
            self.backgroundView.dropShadow(ShadowColor: .clear, radius: 0, Height: 0, Width: 0, Opacity: 0, CornerRadius: 0)
            self.appStatusView.isHidden = false
            self.view.backgroundColor = .themeBG
            self.setTopViewAction()
            self.homeBtn.isHidden = false
            self.homeBtn.setTitle("Add another product", for: .normal)
            homeBtn.setTitleColor(.themeWhite, for: .normal)
            self.uploadDocsBtn.setTitle("Upload my Documents", for: .normal)
            self.uploadDocsLbl.text = "Thank you"
            self.cancelBtn.isHidden = true
            self.backgroundView.backgroundColor = .clear
            self.topView.isHidden = false
            self.descLbl.numberOfLines = 0
            self.descLbl.lineBreakMode = .byWordWrapping
            uploadDocsBtn.setTitleColor(.themeWhite, for: .normal)
            homeBtn.setTitleColor(.themeGreen, for: .normal)

            let text = "Please make sure that your documents are properly uploaded and your profile is completed in order to be able to receive your money directly into your bank account once your product is sold."

            let attributedText = NSMutableAttributedString(string: text)

            // Define custom fonts
            let regularFont = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
            let semiBoldFont = UIFont(name: "Poppins-SemiBold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)

            // Define bold phrases
            let semiBoldPhrases = [
                "your documents are properly uploaded",
                "receive your money directly into your bank account"
            ]

            // Apply attributes
            for phrase in semiBoldPhrases {
                if let range = text.range(of: phrase) {
                    let nsRange = NSRange(range, in: text)
                    attributedText.addAttributes([.font: semiBoldFont], range: nsRange)
                }
            }

            // Set the attributed text to UILabel
            self.descLbl.attributedText = attributedText
        }
        
        self.backgroundView.cornerRadius = 10
        
        self.uploadDocsLbl.font(font: .semibold, size: .size24)
        self.uploadDocsLbl.color(color: .themeBlack)
        
        self.descLbl.color(color: .themeBlack)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appStatusView.textTitle = ""
        self.appStatusView.btnBack.setImage(UIImage(named: "icon_cross"), for: .normal)
        self.appStatusView.backButtonClicked = { [] in
            self.coordinator?.setTabbar(selectedIndex: 0)
        }
    }
    
    //-------------------------------
    // MARK: - Actions
    
    @IBAction func disBtnAction(_ sender: Any) {
        if !self.fromSellVc {
            self.dismiss(animated: true)
        } else {
            self.coordinator?.setTabbar(selectedIndex: 0)
        }
    }
    
    @IBAction func homeBtnAction(_ sender: Any) {
        if !self.fromSellVc {
            self.dismiss(animated: true)
        } else {
            self.coordinator?.setTabbar(selectedIndex: 2)
        }
    }
    
    @IBAction func uploadDocsBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.coordinator?.navigateToDocumentHelpCenter(isPro: appUserDefaults.getValue(.isProUser) ?? false)
            })
        })
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

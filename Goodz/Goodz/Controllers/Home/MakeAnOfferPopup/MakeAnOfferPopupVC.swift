//
//  MakeAnOfferPopupVC.swift
//  Goodz
//
//  Created by vtadmin on 18/12/23.
//

import UIKit

class MakeAnOfferPopupVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitleOffer: UILabel!
    @IBOutlet weak var txtOffer: AppTextField!
    @IBOutlet weak var btnSend: SmallGreenButton!
    @IBOutlet weak var lblError: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : MakeAnOfferVM = MakeAnOfferVM()
    var data : MakeAnOfferModel?
    var parentVC : BaseVC?
    var price : String = ""
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUi()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setUi() {
        self.mainView.cornerRadius(cornerRadius: 16.0)
        self.txtOffer.txtType = .normalWithoutImage
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblTitleOffer.font(font: .regular, size: .size14)
        self.lblError.font(font: .regular, size: .size12)
        self.lblError.color(color: .themeRed)
        self.txtOffer.txt.keyboardType = .decimalPad
        self.txtOffer.txt.delegate = self
        self.lblError.isHidden = true
        self.btnSend.isEnabled = false
        self.setLabels()
        self.btnSend.font(font: .semibold, size: .size16)
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.txtOffer.placeholder = Labels.enterPrice
        let min = (Double(kMakeAnOfferDiscount) ?? 0) 
        let a = min / 100
        
        let strPrice = String(format: "%@", ((Double(self.price) ?? 0) * a).customString)
        let strPriceMin = String(format: "%@", min.customString)
        
        self.lblError.text = min < 1 ? "" : Labels.yourOfferNeedsToBeAtLeast + " " + kCurrency + strPrice + "(\(strPriceMin)% off)"
    }
    
    // --------------------------------------------
    // MARK: - Action
    // --------------------------------------------
    
    @IBAction func actionBtnClose(_ sender: UIButton) {
        self.dismiss()
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnSend(_ sender: UIButton) {
        if (self.txtOffer.txt.text ?? "").isEmpty {
            notifier.showToast(message: Labels.pleaseEnterAmount)
        } /*else if let offerText = Double(self.txtOffer.txt.text ?? "") , offerText < ((Double(self.price) ?? 0) * 0.4) {
            notifier.showToast(message: Labels.makeOfferThatAreLowerThanOfTheSellingPrice)
        } */else if let offerText = Double(self.txtOffer.txt.text ?? ""), offerText > 0 {
            var amountData = self.data
            amountData?.amount = self.txtOffer.txt.text ?? ""
            self.data = amountData
            if let makeAnOfferData = data {
                self.viewModel.fetchMakeAnOfferAPI(offerType: makeAnOfferData.offerType, productId: makeAnOfferData.productId, bundleId: makeAnOfferData.bundleId, amount: makeAnOfferData.amount, storeId: "") { status,data,error   in
                    if status {
                        self.dismiss()
                        self.parentVC?.coordinator?.navigateToChatDetail(isBlock: false, chatId: data, userId: "")
                        
                    } else {
                        notifier.showToast(message: appLANG.retrive(label: error))
                    }
                }
            }
            
        } else {
            notifier.showToast(message: Labels.pleaseEnteValidrAmount)
        }
    }
}

// --------------------------------------------
// MARK: - UITextField Delegate methods
// --------------------------------------------

extension MakeAnOfferPopupVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range1 = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range1, with: string)
            if textField == self.txtOffer.txt {
                guard let oldText = textField.text,
                          let r = Range(range, in: oldText) else {
                        return true
                    }

                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1
                    let numberOfDecimalDigits: Int
                    
                    if let dotIndex = newText.firstIndex(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }
                
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && ((Double(self.price) ?? 0) >= (Double(newText) ?? 0))
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let txt = (textField.text ?? "")
        let min = (Double(kMakeAnOfferDiscount) ?? 0) / 100
        print(self.price)
        print(min)
        print(txt)
        print(((Double(self.price) ?? 0) * min))
        if ((Double(self.price) ?? 0) > (Double(txt) ?? 0)) {
            if min > 0 {
                if txt.toDouble() < ((Double(self.price) ?? 0) * min) {
                    self.lblError.isHidden = false
                    self.btnSend.isEnabled = false
                } else {
                    self.lblError.isHidden = true
                    self.btnSend.isEnabled = true
                }
            }  else {
                self.lblError.isHidden = true
                self.btnSend.isEnabled = true
            }
        } else {
            self.lblError.isHidden = true
            self.btnSend.isEnabled = true
        }
    }
}

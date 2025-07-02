//
//  MakeAnOfferVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

struct MakeAnOfferModel {
    var offerType  : String
    var productId : String
    var bundleId : String
    var amount : String
}
class MakeAnOfferVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblMyOffer: UILabel!
    @IBOutlet weak var txtOfferPrice: AppTextField!
    @IBOutlet weak var lblError: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : MakeAnOfferVM = MakeAnOfferVM()
    var data : MakeAnOfferModel?
    var parentVC : BaseVC?
    var price : Int = 0
    var completion : ((Bool) -> Void)?
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
    }
    
    // --------------------------------------------
    
    func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size16)
        self.lblMyOffer.font(font: .medium, size: .size14)
        self.btnSend.font(font: .semibold, size: .size16)
        self.txtOfferPrice.txt.keyboardType = .decimalPad
        self.txtOfferPrice.txt.delegate = self
        
        self.lblError.font(font: .regular, size: .size12)
        self.lblError.color(color: .themeRed)
        self.lblError.isHidden = true
        self.btnSend.isEnabled = false
        
        self.txtOfferPrice.placeholder = Labels.enterPrice
        let min = (Double(kMakeAnOfferDiscount) ?? 0) 
        let a = min / 100
        
        let strPrice = String(format: "%0.0f", ((Double(self.price)) * a))
        let strPriceMin = String(format: "%0.0f", min)
        
        self.lblError.text = min < 1 ? "" : Labels.yourOfferNeedsToBeAtLeast + " " + kCurrency + strPrice + "(\(strPriceMin)% off)"
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionCross(_ sender: Any) {
        self.dismiss()
    }
    
    // --------------------------------------------
    
    @IBAction func actionSend(_ sender: Any) {
        if (self.txtOfferPrice.txt.text ?? "").isEmpty  {
            notifier.showToast(message: Labels.pleaseEnterAmount)
            self.completion?(false)
        } /*else if let offerText = Double(self.txtOfferPrice.txt.text ?? "") , offerText < (Double(self.price) * 0.4){
            notifier.showToast(message: Labels.makeOfferThatAreLowerThanOfTheSellingPrice)
        } */else if let offerText = Double(self.txtOfferPrice.txt.text ?? ""), offerText > 0 {
            if let makeAnOfferData = data {
                self.viewModel.fetchMakeAnOfferAPI(offerType: makeAnOfferData.offerType, productId: makeAnOfferData.productId, bundleId: makeAnOfferData.bundleId, amount: self.txtOfferPrice.txt.text ?? "", storeId: "") { status,chatId,error   in
                    if status {
                        self.completion?(true)
                        self.dismiss()
                    } else {
                        self.completion?(false)
                        notifier.showToast(message: appLANG.retrive(label: error))
                        
                    }
                }
            }
        } else {
            self.completion?(false)
            notifier.showToast(message: Labels.pleaseEnteValidrAmount)
        }
    }
    
    // --------------------------------------------
    
}
// --------------------------------------------
// MARK: - UITextField Delegate methods
// --------------------------------------------

extension MakeAnOfferVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range1 = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range1, with: string)
            if textField == self.txtOfferPrice.txt {
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
                
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11 && ((Double(self.price)) >= (Double(newText) ?? 0))
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

//
//  BuildingProductVC.swift
//  Goodz
//
//  Created by Akruti on 13/12/23.
//

import Foundation
import UIKit

class BuildingProductVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwOffer: UIView!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblOfferDes: UILabel!
    @IBOutlet weak var vwStages: UIView!
    @IBOutlet weak var lblFirstStage: UILabel!
    @IBOutlet weak var txtFirstStage: AppTextField!
    @IBOutlet weak var lblFirstDiscount: UILabel!
    @IBOutlet weak var txtFirstDiscount: AppTextField!
    
    @IBOutlet weak var lblSecondStage: UILabel!
    @IBOutlet weak var txtSecondStage: AppTextField!
    @IBOutlet weak var lblSecondDiscount: UILabel!
    @IBOutlet weak var txtSecondDiscount: AppTextField!
    
    @IBOutlet weak var lblThirdStage: UILabel!
    @IBOutlet weak var txtThirdStage: AppTextField!
    @IBOutlet weak var lblThirdDiscount: UILabel!
    @IBOutlet weak var txtThirdDiscount: AppTextField!
    
    @IBOutlet weak var btnActiveBundle: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var viwModel : BuildingProductVM = BuildingProductVM()
    var pickerView: UIPickerView!

    var arrDiscount = ["10%", "20%", "30%", "40%", "50%"]
    
    var selectedFirstIndex = 0
    var selectedSecondIndex = 0
    var selectedThirdIndex = 0
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.vwOffer.cornerRadius(cornerRadius: 4.0)
        self.vwStages.cornerRadius(cornerRadius: 4.0)
        
        self.lblOffer.font(font: .semibold, size: .size16)
        self.lblOffer.color(color: .themeBlack)
        self.lblOfferDes.font(font: .regular, size: .size12)
        self.lblOfferDes.color(color: .themeBlack)
        
        self.lblFirstStage.font(font: .medium, size: .size14)
        self.lblFirstStage.color(color: .themeBlack)
        self.lblFirstDiscount.font(font: .medium, size: .size14)
        self.lblFirstDiscount.color(color: .themeBlack)
        
        self.lblSecondStage.font(font: .medium, size: .size14)
        self.lblSecondStage.color(color: .themeBlack)
        self.lblSecondDiscount.font(font: .medium, size: .size14)
        self.lblSecondDiscount.color(color: .themeBlack)
        
        self.lblThirdStage.font(font: .medium, size: .size14)
        self.lblThirdStage.color(color: .themeBlack)
        self.lblThirdDiscount.font(font: .medium, size: .size14)
        self.lblThirdDiscount.color(color: .themeBlack)
        
        self.txtFirstStage.txtType = .normalWithoutImage
        self.txtSecondStage.txtType = .normalWithoutImage
        self.txtThirdStage.txtType = .normalWithoutImage
        
        self.txtFirstDiscount.txtType = .dropDownWithoutImage
        self.txtSecondDiscount.txtType = .dropDownWithoutImage
        self.txtThirdDiscount.txtType = .dropDownWithoutImage
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.BundlingProducts
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func setData() {
        self.lblOffer.text = Labels.OfferAdiscountFor
        self.lblOfferDes.text = Labels.YouCanOfferIncreasingDiscountsBasedOnTheAmounts
        self.lblFirstStage.text = Labels.FirstStageDiscount
        self.lblFirstDiscount.text = Labels.discount
        
        self.lblSecondStage.text = Labels.secondndStageDiscount
        self.lblSecondDiscount.text = Labels.discount
        
        self.lblThirdStage.text = Labels.thirdStageDiscount
        self.lblThirdDiscount.text = Labels.discount
        
        self.txtFirstStage.placeholder = Labels.enterAmount
        self.txtSecondStage.placeholder = Labels.enterAmount
        self.txtThirdStage.placeholder = Labels.enterAmount
        
        self.txtFirstDiscount.placeholder = Labels.selectDiscount
        self.txtSecondDiscount.placeholder = Labels.selectDiscount
        self.txtThirdDiscount.placeholder = Labels.selectDiscount
        
        self.txtFirstStage.txt.keyboardType = .decimalPad
        self.txtSecondStage.txt.keyboardType = .decimalPad
        self.txtThirdStage.txt.keyboardType = .decimalPad
        
        self.btnActiveBundle.setTitle(Labels.activateBundle, for: .normal)
        
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.txtFirstDiscount.txt.inputView = self.pickerView
        self.txtFirstDiscount.txt.isUserInteractionEnabled = true
        self.txtFirstDiscount.txt.delegate = self
        
        self.txtSecondDiscount.txt.inputView = self.pickerView
        self.txtSecondDiscount.txt.isUserInteractionEnabled = true
        self.txtSecondDiscount.txt.delegate = self
        
        self.txtThirdDiscount.txt.inputView = self.pickerView
        self.txtThirdDiscount.txt.isUserInteractionEnabled = true
        self.txtThirdDiscount.txt.delegate = self
        
        self.txtFirstDiscount.txt.tag = 0
        self.txtSecondDiscount.txt.tag = 1
        self.txtThirdDiscount.txt.tag = 2
        
        for txt in [txtFirstDiscount.txt,txtSecondDiscount.txt,txtThirdDiscount.txt] {
            
            guard let textField = txt else {
                return
            }
            /// ToolBar
            let toolBar = UIToolbar()
            toolBar.barStyle = .default
            toolBar.isTranslucent = false
            toolBar.tintColor = .themeGreen
            toolBar.sizeToFit()
            
            /// Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: Labels.done, style: .plain, target: self, action: #selector(doneClick))
            doneButton.setTitleTextAttributes([NSAttributedString.Key.font: FUNCTION().getFont(for: .medium, size: FontSize.size16)], for: .normal)
            doneButton.tag = textField.tag
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            textField.inputAccessoryView = toolBar
            
        }
        
        self.txtFirstStage.txt.delegate = self
        self.txtSecondStage.txt.delegate = self
        self.txtThirdStage.txt.delegate = self
        
        if let userData = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser) {
            self.txtFirstStage.txt.text = userData.firstStageAmount
            self.txtSecondStage.txt.text = userData.secondStageAmount
            self.txtThirdStage.txt.text = userData.thirdStageAmount
            if (userData.firstStageDiscount ?? "").isEmpty {
                self.txtFirstDiscount.txt.isEnabled = false
            }
            if (userData.secondStageDiscount ?? "").isEmpty {
                self.txtSecondDiscount.txt.isEnabled = false
            }
            if (userData.thirdStageDiscount ?? "").isEmpty {
                self.txtThirdDiscount.txt.isEnabled = false
            }
            self.txtFirstDiscount.txt.text = userData.firstStageDiscount != "" ? userData.firstStageDiscount?.setPercentage() : ""
            self.txtSecondDiscount.txt.text = userData.secondStageDiscount != "" ? userData.secondStageDiscount?.setPercentage() : ""
            self.txtThirdDiscount.txt.text = userData.thirdStageDiscount != "" ? userData.thirdStageDiscount?.setPercentage() : ""
            self.btnActiveBundle.setTitle(Labels.modifybundleBtnTitle, for: .normal)
        }
        
    }
    
    @objc func doneClick(sender: UIButton) {
        if sender.tag == txtFirstDiscount.txt.tag {
            txtFirstDiscount.txt.text = arrDiscount[selectedFirstIndex]
            let _ = txtFirstDiscount.txt.resignFirstResponder()
        }else if sender.tag == txtSecondDiscount.txt.tag {
            txtSecondDiscount.txt.text = arrDiscount[selectedSecondIndex]
            let _ = txtSecondDiscount.txt.resignFirstResponder()
        }else if sender.tag == txtThirdDiscount.txt.tag {
            txtThirdDiscount.txt.text = arrDiscount[selectedThirdIndex]
            let _ = txtThirdDiscount.txt.resignFirstResponder()
            
        }
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
    @IBAction func btnActiveBundleTapped(_ sender: Any) {
        let first = (self.txtFirstStage.txt.text ?? "")
        let firstDis = ((self.txtFirstStage.txt.text ?? "").toDouble() < 1) ? "0" : String((self.txtFirstDiscount.txt.text ?? "").dropLast(1))
        let second = (self.txtSecondStage.txt.text ?? "")
        let secondDis = ((self.txtSecondStage.txt.text ?? "").toDouble() < 1) ? "0" : String((self.txtSecondDiscount.txt.text ?? "").dropLast(1))
        let third = (self.txtThirdStage.txt.text ?? "")
        let thirdDis = ((self.txtThirdStage.txt.text ?? "").toDouble() < 1) ? "0" : String((self.txtThirdDiscount.txt.text ?? "").dropLast(1))
        
        self.viwModel.fetch(firstStageAmount: first, firstStageDiscount: firstDis, secondStageAmount: second, secondStageDiscount: secondDis, thirdStageAmount: third, thirdStageDiscount: thirdDis) { status in
            if status {
                self.coordinator?.popVC()
                GlobalRepo.shared.getProfileAPI { _, _, _ in }
//                notifier.showToast(message: Labels.yourBundleProductHasBeenActivated)
            }
        }
    }
}

// --------------------------------------------
// MARK: - UITextFeild Delegate methods
// --------------------------------------------

extension BuildingProductVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var value = ""
        if textField == self.txtFirstDiscount.txt {
            value = txtFirstDiscount.txt.text ?? ""
            self.pickerView.reloadAllComponents()
        } else if textField == self.txtSecondDiscount.txt {
            value = txtSecondDiscount.txt.text ?? ""
            self.pickerView.reloadAllComponents()
        } else if textField == self.txtThirdDiscount.txt {
            value = txtThirdDiscount.txt.text ?? ""
            self.pickerView.reloadAllComponents()
        }
        let index = arrDiscount.firstIndex(of: value) ?? 0
        self.pickerView.selectRow(index, inComponent: 0, animated: false)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range1 = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range1, with: string)
            if textField == self.txtFirstStage.txt || textField == self.txtSecondStage.txt || textField == self.txtThirdStage.txt {
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
                if textField == self.txtFirstStage.txt {
                    if (newText).toDouble() < 1 {
                        self.txtFirstDiscount.txt.text = ""
                        self.txtFirstDiscount.txt.placeholder = Labels.selectDiscount
                        self.txtFirstDiscount.txt.isEnabled = false
                    } else {
                        self.txtFirstDiscount.txt.isEnabled = true
                    }
                } else if textField == self.txtSecondStage.txt {
                    if (newText).toDouble() < 1 {
                        self.txtSecondDiscount.txt.text = ""
                        self.txtSecondDiscount.txt.placeholder = Labels.selectDiscount
                        self.txtSecondDiscount.txt.isEnabled = false
                    } else {
                        self.txtSecondDiscount.txt.isEnabled = true
                    }
                } else if textField == self.txtThirdStage.txt {
                    if (newText).toDouble() < 1 {
                        self.txtThirdDiscount.txt.text = ""
                        self.txtThirdDiscount.txt.placeholder = Labels.selectDiscount
                        self.txtThirdDiscount.txt.isEnabled = false
                    } else {
                        self.txtThirdDiscount.txt.isEnabled = true
                    }
                }
                return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11
            }
        }
        return true
    }
}

// --------------------------------------------
// MARK: - UIPIckerView Delegate AND DataSource
// --------------------------------------------

extension BuildingProductVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDiscount.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrDiscount[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.txtFirstDiscount.txt.isFirstResponder {
            selectedFirstIndex = row
        } else if self.txtSecondDiscount.txt.isFirstResponder {
            selectedSecondIndex = row
        } else if self.txtThirdDiscount.txt.isFirstResponder {
            selectedThirdIndex = row
        } else {}
    }
}

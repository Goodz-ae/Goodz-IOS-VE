//
//  PriceVC.swift
//  Goodz
//
//  Created by Akruti on 01/02/24.
//

import Foundation
import UIKit
struct Price {
    var minPrice, maxPrice : String
}
struct Dimension {
    var width, weight, length, heigth : String
}
class PriceVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var headerView: AppStatusView!
    
    // price
    
    @IBOutlet weak var vwPrice: UIView!
    
    @IBOutlet weak var lblMinPrice: UILabel!
    @IBOutlet weak var lblMaxPrice: UILabel!
    @IBOutlet weak var txtMinPrice: AppTextField!
    @IBOutlet weak var txtMaaxPrice: AppTextField!
    
    @IBOutlet weak var vwDeminsion: UIStackView!
    
    @IBOutlet weak var lblWidth: UILabel!
    @IBOutlet weak var txtWidth: AppTextField!
    
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var txtWeigth: AppTextField!
    
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var txtHeight: AppTextField!
    
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var txtLength: AppTextField!
    
    @IBOutlet weak var btnDone: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isPrice : Bool = true
    var completionPrice : ((String, String) -> Void) = { _,_ in}
    var completionDeminsions : ((String, String, String, String) -> Void) = { _,_,_,_ in}
    var selectedPrice : Price = Price(minPrice: "", maxPrice: "")
    var selectedDeminsion : Dimension = Dimension(width: "", weight: "", length: "", heigth: "")
   
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.vwPrice.isHidden = !self.isPrice
        self.vwDeminsion.isHidden = self.isPrice
        
        self.btnDone.setTitle(Labels.done, for: .normal)
        
        let keyboardType: UIKeyboardType = .numberPad
        [self.txtMinPrice.txt, self.txtMaaxPrice.txt, self.txtHeight.txt, self.txtWidth.txt, self.txtWeigth.txt, self.txtLength.txt].forEach { $0.keyboardType = keyboardType }
        
        [self.lblMinPrice, self.lblMaxPrice, self.lblWidth, self.lblWeight, self.lblHeight, self.lblLength].forEach {
            $0.font(font: .regular, size: .size14)
            $0.color(color: .themeBlack)
        }
        
        [self.txtHeight, self.txtWidth, self.txtWeigth, self.txtLength, self.txtMinPrice, self.txtMaaxPrice].forEach { $0.txtType = .normalWithoutImage }
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblMinPrice.text = Labels.minPrice
        self.lblMaxPrice.text = Labels.maxPrice
        self.lblWidth.text = Labels.widthCm
        self.lblWeight.text = Labels.weightKg
        self.lblHeight.text = Labels.heightCm
        self.lblLength.text = Labels.lengthCm
        
        self.txtMinPrice.txt.placeholder = Labels.enterMinPrice
        self.txtMaaxPrice.txt.placeholder = Labels.enterMaxPrice
        self.txtHeight.txt.placeholder = Labels.enterHeightCm
        self.txtWidth.txt.placeholder = Labels.enterWidthCm
        self.txtWeigth.txt.placeholder = Labels.enterWeigthCm
        self.txtLength.txt.placeholder = Labels.enterLengthCm
        
        self.txtMinPrice.txt.text = selectedPrice.minPrice
        self.txtMaaxPrice.txt.text = selectedPrice.maxPrice
        self.txtHeight.txt.text = selectedDeminsion.heigth
        self.txtWidth.txt.text = selectedDeminsion.width
        self.txtWeigth.txt.text = selectedDeminsion.weight
        self.txtLength.txt.text = selectedDeminsion.length
        
        [self.txtMinPrice,self.txtMaaxPrice,self.txtHeight,self.txtWidth,self.txtWeigth, self.txtLength].forEach {
            $0.txt.keyboardType = .decimalPad
            $0.txt.delegate = self
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setLabels()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        if self.isPrice {
            if self.setPriceValidation() {
                self.coordinator?.popVC()
            }
        } else {
            if self.setDimensionValidation() {
                self.coordinator?.popVC()
            }
        }
        
    }
    
    // --------------------------------------------
    
    func setPriceValidation() -> Bool {
        let minPrice = self.txtMinPrice.txt.text ?? ""
        let maxPrice = self.txtMaaxPrice.txt.text ?? ""
        
        if minPrice.isEmpty && maxPrice.isEmpty {
            
        }else{
            if minPrice.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterMinPrice)
                return false
            } else if maxPrice.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterMaxPrice)
                return false
            }
        }

        if (Int(minPrice) ?? 0)  > (Int(maxPrice) ?? 0) {
            notifier.showToast(message: Labels.minPricelessthanMaxprive)
            return false
        } else {
            self.completionPrice(maxPrice, minPrice)
            return true
        }
    }
    
    // --------------------------------------------
    
    func setDimensionValidation() -> Bool {
        let heigth = self.txtHeight.txt.text ?? ""
        let width = self.txtWidth.txt.text ?? ""
        let weigth = self.txtWeigth.txt.text ?? ""
        let length = self.txtLength.txt.text ?? ""
        
        if width.isEmpty && weigth.isEmpty && heigth.isEmpty && length.isEmpty {
            self.completionDeminsions(width, weigth, heigth, length)
            return true
        }else{
            if width.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterWidthCm)
                return false
            } else if weigth.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterWeigthCm)
                return false
            } else if heigth.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterHeightCm)
                return false
            } else if length.isEmpty {
                notifier.showToast(message: Labels.pleaseEnterLengthCm)
                return false
            } else {
                self.completionDeminsions(width, weigth, heigth, length)
                return true
            }
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.headerView.textTitle = self.isPrice ? Labels.price : Labels.dimensions
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
}

extension PriceVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 11
    }
}

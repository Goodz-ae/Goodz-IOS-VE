//
//  PaymentOptionCell.swift
//  Goodz
//
//  Created by Akruti on 12/12/23.
//

import UIKit

class PaymentOptionCell: UITableViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var vwSelect: UIView!
    @IBOutlet weak var vwAccountDetails: UIStackView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: AppTextField!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var txtCardNumber: AppTextField!
    @IBOutlet weak var lblExpirationDate: UILabel!
    @IBOutlet weak var txtExpirationDate: AppTextField!
    @IBOutlet weak var lblCVV: UILabel!
    @IBOutlet weak var txtCVV: AppTextField!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------

    private func applyStyle() {
        self.txtCVV.txtType = .normalWithoutImage
        self.txtName.txtType = .normalWithoutImage
        self.txtName.txt.setAutocapitalization(.words)
        self.txtCardNumber.txtType = .normalWithoutImage
        self.txtExpirationDate.txtType = .normalWithoutImage
        
        self.lblCVV.font(font: .medium, size: .size14)
        self.lblCVV.color(color: .themeBlack)
        self.lblName.font(font: .medium, size: .size14)
        self.lblName.color(color: .themeBlack)
        self.lblCardNumber.font(font: .medium, size: .size14)
        self.lblCardNumber.color(color: .themeBlack)
        self.lblExpirationDate.font(font: .medium, size: .size14)
        self.lblExpirationDate.color(color: .themeBlack)
        
        self.btnSelect.font(font: .regular, size: .size14)
        self.btnSelect.color(color: .themeBlack)
        self.btnSelect.setImage(.iconCircle, for: .normal)
        self.btnSelect.setImage(.iconCircleFill, for: .selected)
        
        self.txtCVV.txt.keyboardType = .numberPad
        self.txtCardNumber.txt.keyboardType = .numberPad
        
    }
    
    // --------------------------------------------
    
    func setData() {
        self.lblCVV.text = Labels.cVV
        self.lblName.text = Labels.nameOfCard
        self.lblExpirationDate.text = Labels.expirationDate
        self.lblCardNumber.text = Labels.cardNumber
        self.txtCVV.placeholder = Labels.enterCVV
        self.txtName.placeholder = Labels.enterNameOfCard
        self.txtCardNumber.placeholder = Labels.enterCardNumber
        self.txtExpirationDate.placeholder = Labels.enterExpirationDate
    }
    
    // --------------------------------------------
    
    func setData(data: PaymentOptionModel) {
        self.imgPayment.image = data.imgCards
        self.btnSelect.setTitle(data.title, for: .normal)
    }
    
    // --------------------------------------------
    
    func setValidation(row: Int, completion: (Bool) -> Void) {
        let cardNumber = self.txtCardNumber.txt.text ?? ""
        let nameOfName = self.txtName.txt.text ?? ""
        let date = self.txtExpirationDate.txt.text ?? ""
        let cvv = self.txtCVV.txt.text ?? ""
        
        if nameOfName.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterNameOfCard)
            completion(false)
        } else if cardNumber.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterCardNumber)
            completion(false)
        } else if date.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterExpirationDate)
            completion(false)
        } else if cvv.isEmpty {
            notifier.showToast(message: Labels.pleaseEnterCVV)
            completion(false)
        } else if !Validation.shared.isValidateCVV(cvv: cvv) {
            notifier.showToast(message: Labels.pleaseEnterValidCVV)
           completion(false)
        } else {
            completion(true)
        }
    }
    
    // --------------------------------------------
    
}

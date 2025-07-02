//
//  KiaraTextField.swift
//  KiaraMayo
//
//  Created by vtadmin on 07/11/22.
//

import UIKit
protocol appTextFieldDelegate {
    func clearTextFieldClicked()
}
class AppTextField: UIView, UITextFieldDelegate {
    // MARK: - Outlets
    @IBOutlet weak var viewRound: UIView!
    @IBOutlet weak var imgleft : UIImageView!
    @IBOutlet fileprivate weak var viewCode: UIView!
    @IBOutlet fileprivate weak var lblCodeDevider: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    
    @IBOutlet weak var txt: UITextField!
    
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnShow: UIButton!
    
    @IBOutlet weak var viewCross: UIView!
    @IBOutlet weak var btnCross: UIButton!
    
    @IBOutlet weak var viewSelect: UIView!
    @IBOutlet weak var imgSelect: UIImageView!
    
    @IBOutlet weak var viewLedingSpace: UIView!
    @IBOutlet weak var viewTrailingSpace: UIView!
    @IBOutlet weak var txtCode: UITextField!
    
    @IBOutlet weak var btnShowCountry: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtFldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    // MARK: - Custom variables
    
    var textChange : (_ text: String) -> (Void) = {text in }
    var txtDidEndEditing : () -> (Void) = { }
    var countryCodeClicked : () -> (Void) = { }
    var dropdownButtonClicked : (() -> ())?
    var delegate: appTextFieldDelegate?
    var isFilled = true
    
    var txtType: TxtType = .normal {
        didSet {
            updateTxtType()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            updateTxtType()
        }
    }
    
    var isValid: Bool = false {
        didSet {
            checkInvalid()
        }
    }
    
    @IBInspectable open var textFieldType : Int {
        get {
            return self.txtType.rawValue
        }
        set(index) {
            self.txtType = TxtType(rawValue: index) ?? .normal
        }
    }
    
    @IBInspectable open var isApplyCoupon: Bool = false {
        didSet {
            self.setBtnText()
        }
    }
    
    @IBInspectable open var securTextOnly : Bool = false {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldActiveColor : UIColor = .red {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldDefaultBorder : UIColor = .themeLightGray {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldDefaultBG : UIColor = .themeWhite {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldInvalid : UIColor = .themeBlack {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldFilledBG : UIColor = .themeWhite {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldFilledBorder : UIColor = .themeGreen {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldFilledText : UIColor = .themeBlack {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldText : UIColor = .themeBlack {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldPlaceholder : UIColor = .themeGray {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldDevider : UIColor = .red {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldTitleColor : UIColor = .red {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var placeholder : String = "Placeholder" {
        didSet {
            self.updateUI()
        }
    }
    
    @IBInspectable open var textFieldTitle : String = "Title" {
        didSet {
            self.updateTitle()
        }
    }
    
    @IBInspectable open var strText : String = "" {
        didSet {
            txt.text = strText
            updateTextFieldState(isEditing: false)
        }
    }// MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    // MARK: - Custom methods// Performs the initial setup.
    private func setupView() {
        
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Show the view.
        self.addSubview(view)
        self.txt.delegate = self
        self.txt.setAutocapitalization(.sentences)
        self.updateUI()
        self.updateTitle()
        
        self.txt.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    private func updateTitle() {
        self.lblTitle.text = textFieldTitle
        if textFieldTitle == ""{
            self.lblTitle.isHidden = true
        } else {
            self.lblTitle.isHidden = true
        }
    }
    
    private func updateUI() {
        self.viewRound.layer.cornerRadius = 5
        self.viewRound.clipsToBounds = true
        self.lblTitle.textColor = .themeBlack
        self.lblCode.font(font: FontName.regular, size: .size14)
        self.lblTitle.font(font: FontName.light, size: .size12)
        
        self.lblCode.text = "+971" // CurrentCountry().getCountry()?.dial_code ?? "+1"
        self.lblCodeDevider.backgroundColor = .clear
        
        self.txtCode.tintColor = .clear
        self.btnApply.font(font: .medium, size: .size16)
        self.btnApply.color(color: .themeBlack)
        self.updateTxtUI()
        self.updateTextFieldState(isEditing: false)
        self.viewCross.isHidden = true
        self.btnShow.setImage(.iconEye, for: .normal)
        self.btnShow.setImage(.iconEyeoff, for: .selected)
        self.btnShow.addTarget(self, action: #selector(self.btnEyeAction(_:)), for: .touchUpInside)
        self.btnShowCountry.addTarget(self, action: #selector(self.btnShowCountryClicked(_:)), for: .touchUpInside)
        self.btnCross.addTarget(self, action: #selector(self.btnCrossAction(_:)), for: .touchUpInside)
        self.txt.placeholder = self.placeholder
        if self.textFieldTitle == "" {
            self.lblTitle.isHidden = true
        } else {
            self.lblTitle.isHidden = true
        }
        
    }
    
    private func setBtnText() {
        if isApplyCoupon {
            self.btnApply.setTitle(Labels.cancel, for: .normal)
        }else{
            self.btnApply.setTitle(Labels.apply, for: .normal)
        }
        
    }
    
    @objc func btnShowCountryClicked(_ sender: UIButton) {
        countryCodeClicked()
    }
    
    @objc func btnCrossAction(_ sender: UIButton) {
        self.txt.text = ""
        self.viewCross.isHidden = true
        updateTextFieldState(isEditing: true)
        delegate?.clearTextFieldClicked()
    }
    
    @objc func btnEyeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            txt.isSecureTextEntry = false
        } else {
            txt.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnDropdownAction(_ sender: UIButton) {
        self.dropdownButtonClicked?()
    }
    
    private func updateTxtUI() {
        
        self.txt.font(font: .regular, size: FontSize.size14)
        self.txt.addTarget(self, action: #selector(self.txtEditingDidBeginAction(_:)), for: .editingDidBegin)
        self.txt.addTarget(self, action: #selector(self.txtEditingDidEndAction(_:)), for: .editingDidEnd)
        self.txt.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func updateTxtType() {
        switch txtType {
        case .normal:
            self.txtNormal()
        case .password:
            self.txtPassword()
        case .phoneNumber:
            self.txtPhoneNumber()
        case .dropDown:
            self.txtDropDown()
        case .noTitle:
            self.txtNoTitle()
        case .dropDownWithoutImage:
            self.txtDropDownButton()
        case .normalWithoutImage:
            self.txtNormalWithoutImage()
        case .rightButton :
            self.txtRightButton()
        }
    }
    
    private func txtRightButton() {
        self.btnApply.superview?.isHidden = false
        self.imgleft.isHidden = true
        self.viewSelect.isHidden = true
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = true
        self.viewLedingSpace.isHidden = true
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .default
        self.txt.tintColor = txt.textColor
        self.btnDropDown.isHidden = true
    }
    
    private func txtNormalWithoutImage() {
        self.btnApply.superview?.isHidden = true
        self.imgleft.isHidden = true
        self.viewSelect.isHidden = true
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = true
        self.viewLedingSpace.isHidden = true
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .default
        self.txt.tintColor = txt.textColor
        self.btnDropDown.isHidden = true
    }
    
    private func txtNormal() {
        self.btnApply.superview?.isHidden = true
        self.viewSelect.isHidden = true
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = false
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .default
        self.txt.tintColor = txt.textColor
        self.btnDropDown.isHidden = true
    }
    
    private func txtPassword() {
        self.btnApply.superview?.isHidden = true
        self.viewSelect.isHidden = true
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = false
        self.viewTrailingSpace.isHidden = false
        self.txt.isSecureTextEntry = true
        self.txt.textAlignment = .left
        self.txt.keyboardType = .default
        self.txt.tintColor = txt.textColor
        self.btnDropDown.isHidden = true
    }
    
    private func txtPhoneNumber() {
        self.btnApply.superview?.isHidden = true
        self.viewSelect.isHidden = true
        self.viewCode.isHidden = false
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = false
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .phonePad
        self.txt.tintColor = txt.textColor
        self.txt.delegate = self
        self.btnDropDown.isHidden = true
    }
    
    private func txtDropDown() {
        self.btnApply.superview?.isHidden = true
        self.viewSelect.isHidden = false
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = false
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .decimalPad
        self.txt.placeholder = placeholder
        self.imgSelect.image = UIImage(named: "icon_dropdown")
        self.txt.tintColor = .clear
        self.btnDropDown.isHidden = true
        self.viewSelect.addTapGesture {
            self.txt.becomeFirstResponder()
            }
    }
    
    private func txtDropDownButton() {
        self.btnApply.superview?.isHidden = true
        self.imgleft.isHidden = true
        self.viewSelect.isHidden = false
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = true
        self.viewLedingSpace.isHidden = true
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .decimalPad
        self.txt.placeholder = placeholder
        self.imgSelect.image = UIImage(named: "icon_dropdown")
        self.txt.tintColor = .clear
        self.btnDropDown.isHidden = true
        self.btnCross.isHidden = true
        self.viewSelect.addTapGesture {
            self.txt.becomeFirstResponder()
            }
    }
    
    private func txtNoTitle() {
        self.btnApply.superview?.isHidden = true
        self.viewSelect.isHidden = false
        self.viewCode.isHidden = true
        self.viewPassword.isHidden = true
        self.viewTrailingSpace.isHidden = false
        self.txt.isSecureTextEntry = false
        self.txt.textAlignment = .left
        self.txt.keyboardType = .decimalPad
        self.txt.placeholder = placeholder
        self.imgSelect.image = UIImage(named: "icon_drop_down")
        self.txt.tintColor = .clear
        self.lblTitle.isHidden = true
        self.txtFldHeight.constant = 52
        self.viewSelect.addTapGesture {
            self.txt.becomeFirstResponder()
            }
    }
    
    @objc private func txtEditingDidBeginAction(_ sender: UITextField) {
        self.updateTextFieldState(isEditing: true)
        self.setCross()
    }
    
    @objc private func txtEditingDidEndAction(_ sender: UITextField) {
        self.updateTextFieldState(isEditing: false)
        txtDidEndEditing()
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        textChange(sender.text!)
        self.setCross()
    }
    
    func setCross() {
        if self.txtType != .password && self.txtType != .rightButton {
            if (self.txt.text ?? "").isEmpty {
                self.viewCross.isHidden = true
            } else {
                self.viewCross.isHidden = false
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldState(isEditing: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldState(isEditing: false)
        txtDidEndEditing()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.setCross()
        /*if TxtType(rawValue: textFieldType) == .normal {
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil || textField.text!.count >= TextFieldMaxLenth.nameMaxLenth.rawValue {
                    return false
                }
            } catch {
                print("ERROR")
                return false
            }
        } else */if TxtType(rawValue: textFieldType) == .phoneNumber {
            
            if let text = textField.text, let range = Range(range, in: text) {
                
                let finaltext = text.replacingCharacters(in: range, with: string)
                
                if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
                    return false
                }
                
                if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) && finaltext.count <= TextFieldMaxLenth.contactNumberMaxLenth.length {
                    print(range)
                    return true
                } else {
                    return false
                }
            }
        } else {
            // textChange(textField.text!)
            return true
        }
        return true
    }
    
    func updateTextFieldState(isEditing: Bool) {
        if isEditing {
            viewRound.backgroundColor = .themeWhite
            viewRound.border(borderWidth: 1, borderColor: .themeGreen)
            txt.placeHolderColor = .themeGray
            txt.textColor = .themeBlack
            lblCode.textColor = .themeGray
            
            if txtType == .dropDown {
                btnCross.isHidden = true
            }
        } else {
            self.viewCross.isHidden = true
            if self.txt.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && isFilled {
                viewRound.backgroundColor = .themeWhite
                viewRound.border(borderWidth: 1, borderColor: .themeBorder)
                txt.placeHolderColor = .themeGray
                txt.textColor = .themeBlack
                lblCode.textColor = .themeGray
                
            } else {
                viewRound.backgroundColor = .themeWhite
                viewRound.border(borderWidth: 1, borderColor: .themeBorder)
                txt.placeHolderColor = .themeGray
                txt.textColor = .themeBlack
                lblCode.textColor = .themeGray
            }
        }
    }
    
    func checkInvalid() {
        if isValid {
            if txt.isEditing {
                updateTextFieldState(isEditing: true)
            } else {
                updateTextFieldState(isEditing: false)
            }
        } else {
            viewRound.backgroundColor = .themeWhite
            viewRound.border(borderWidth: 1, borderColor: .themeBorder)
            txt.placeHolderColor = .themeGray
            txt.textColor = .themeBlack
            lblCode.textColor = .themeGray
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object is UITextField {
            updateTextFieldState(isEditing: false)
        }
    }
}

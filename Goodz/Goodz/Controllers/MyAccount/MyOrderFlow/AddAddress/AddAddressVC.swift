//
//  AddAddressVC.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

class AddAddressVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var txtFirstName: AppTextField!
    @IBOutlet weak var txtLastName: AppTextField!
    @IBOutlet weak var txtMobile: AppTextField!
    @IBOutlet weak var txtCity: AppTextField!
    @IBOutlet weak var txtArea: AppTextField!
    @IBOutlet weak var txtStreetAddress: AppTextField!
    @IBOutlet weak var lblStreetAddress: UILabel!
    @IBOutlet weak var txtFloor: AppTextField!
    @IBOutlet weak var lblFloor: UILabel!
    @IBOutlet weak var btnCancel: ThemeGreenBorderButton!
    @IBOutlet weak var btnAdd: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isEdit : Bool = false
    private var viewModel : AddAddressVM = AddAddressVM()
    var editData : MyAddressModel?
    var addressId : String = ""
    var isAresAPI : Bool = false
    var selectedArea : AreaModel?
    var selectedCity : CitiesModel?
    let currentUser = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.txtMobile.txtType = .phoneNumber
        self.txtMobile.txt.keyboardType = .numberPad
        self.txtMobile.imgleft.image = UIImage.iconMobile
        
        self.txtFirstName.txtType = .normal
        self.txtFirstName.imgleft.image = UIImage.iconUser
        self.txtFirstName.txt.setAutocapitalization(.words)
        
        self.txtLastName.txtType = .normal
        self.txtLastName.imgleft.image = UIImage.iconUser
        self.txtLastName.txt.setAutocapitalization(.words)
        
        self.txtCity.txtType = .dropDown
        self.txtCity.imgleft.image = UIImage.iconCity
        self.txtCity.txt.delegate = self
        
        self.txtArea.txtType = .dropDown
        self.txtArea.imgleft.image = UIImage.iconLocation
        self.txtArea.txt.delegate = self
        
        self.txtStreetAddress.txtType = .normal
        self.txtStreetAddress.imgleft.image = UIImage.iconStreet
        self.txtFloor.txtType = .normal
        self.txtFloor.imgleft.image = UIImage.iconFloor
        
        for (i, txt) in [txtCity,txtArea].enumerated() {
            txt?.txt.tag = i
            txt?.textFieldType = 3
        }
        
        self.lblFloor.font(font: .regular, size: .size12)
        self.lblFloor.color(color: .themeGray)
        self.lblStreetAddress.font(font: .regular, size: .size12)
        self.lblStreetAddress.color(color: .themeGray)
        
        self.txtMobile.countryCodeClicked = {
            self.coordinator?.coutryCodePopup(completion: { code in
                self.txtMobile.lblCode.text = code
            })
        }
        self.txtFirstName.txt.delegate = self
        self.txtLastName.txt.delegate = self
        self.txtMobile.txt.delegate = self
        self.btnCancel.setTitleColor(.themeGreen, for: .normal)
    }
    
    func splitFullName(fullName: String) -> (String, String) {
        let arrayFullName = fullName.components(separatedBy: " ")
        var firstName = ""
        var lastName = ""
        
        for i in 0..<arrayFullName.count {
            if i == 0 {
                firstName = arrayFullName[i]
            }else{
                if lastName == "" {
                    lastName = arrayFullName[i]
                }else{
                    lastName = lastName + " " + arrayFullName[i]
                }
            }
        }
        
        return (firstName, lastName)
    }
    
    // --------------------------------------------
    
    private func setData() {
        if self.isEdit {
            let str = self.splitFullName(fullName: self.editData?.fullName ?? "")
            self.txtFirstName.txt.text = str.0
            self.txtLastName.txt.text = str.1
            self.txtMobile.lblCode.text = self.editData?.countryCode
            self.txtMobile.txt.text = self.editData?.mobile
            self.txtCity.txt.text = self.editData?.city
            self.txtArea.txt.text = self.editData?.area
            self.txtStreetAddress.txt.text = self.editData?.streetAddress
            self.txtFloor.txt.text = self.editData?.floor
        } else {
            let str = self.splitFullName(fullName: self.currentUser?.fullName ?? "")
            self.txtFirstName.txt.text = str.0
            self.txtLastName.txt.text = str.1
            self.txtMobile.lblCode.text = currentUser?.countryCode
            self.txtMobile.txt.text = currentUser?.mobile
        }
        self.btnAdd.setTitle(isEdit ? Labels.save : Labels.addAddress, for: .normal)
        self.btnCancel.setTitle(Labels.cancel, for: .normal)
        self.txtFirstName.placeholder = Labels.firstName
        self.txtLastName.placeholder = Labels.lastName
        self.txtMobile.placeholder = Labels.phoneNumberPlaceholder
        self.txtCity.placeholder = Labels.selectCity
        self.txtArea.placeholder = Labels.selectArea
        self.txtStreetAddress.placeholder = Labels.streetAddressPlaceholder
        self.txtFloor.placeholder = Labels.floorPlaceholder
        self.lblFloor.text = Labels.floorApartmentNumberVillaNumber
        self.lblStreetAddress.text = Labels.streetAddressVillaBuildingEtc
        self.txtMobile.lblCode.text = kLengthMobile.countryCode
        
        
    }
    
    func apiCalling() {
        
        notifier.showLoader()
        
        self.viewModel.fetchCityData { [self] _ in
            self.selectedCity = self.viewModel.arrCities.first(where: { $0.cityName == editData?.city })
            
            self.viewModel.fetchAreaData(cityId: self.selectedCity?.cityId?.description ?? "") { [self] _ in
                self.selectedArea = self.viewModel.arrArea.first(where: { $0.areaName == editData?.area })
                notifier.hideLoader()
                self.setUppickerView()
            }
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = isEdit ? Labels.editAddress : Labels.addNewAddress
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
        self.apiCalling()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func btnAddTapped(_ sender: Any) {
        let fisrtName = self.txtFirstName.txt.text ?? ""
        let lastName = self.txtLastName.txt.text ?? ""
        let mobile = self.txtMobile.txt.text ?? ""
        let streetAddress = self.txtStreetAddress.txt.text ?? ""
        let floor = self.txtFloor.txt.text ?? ""
        let city = self.txtCity.txt.text ?? ""
        let area = self.txtArea.txt.text ?? ""
        let countryCode = self.txtMobile.lblCode.text ?? ""
        self.viewModel.checkAddressData(firstName : fisrtName, lastName : lastName, countryCode: countryCode,
                                        mobile: mobile, city: city, area: area,
                                        streetAddress: streetAddress, floor: floor,
                                        cityId: self.selectedCity?.cityId?.description ?? "", areaId: self.selectedArea?.areaId?.description ?? "",
                                        addressId: self.addressId) { isDone in
            if isDone {
                self.coordinator?.popVC()
            }
        }
    }
    
    // --------------------------------------------
}
// --------------------------------------------
// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
// --------------------------------------------

extension AddAddressVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - SetUp PickerView.
    func setDefaultPickerValue(_ textField: UITextField, _ pickerView: UIPickerView) {
        var index = 0
        
        if textField == self.txtArea.txt {
            index = self.viewModel.arrArea.firstIndex(where: {$0 == selectedArea}) ?? 0
            
        }else if textField == self.txtCity.txt {
            index = self.viewModel.arrCities.firstIndex(where: {$0 == selectedCity}) ?? 0
            
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func setUppickerView() {
        
        for txt in [self.txtCity.txt,
                    self.txtArea.txt] {
            
            guard let textField = txt else {
                return
            }
            
            /// UIPickerView
            let pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: 216))
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.white
            pickerView.tag = textField.tag
            textField.inputView = pickerView
            
            self.setDefaultPickerValue(textField, pickerView)
            
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
        
    }
    
    func selectCity() {
        
        self.txtArea.txt.text = nil
        self.selectedArea = nil
        self.viewModel.arrArea.removeAll()
        self.txtCity.txt.text = self.selectedCity?.cityName
        
        self.viewModel.fetchAreaData(cityId: self.selectedCity?.cityId?.description ?? "") { _ in }
    }
    
    
    @objc func doneClick(sender: UIButton) {
        
        if sender.tag == self.txtArea.txt.tag {
            if self.selectedArea == nil {
                self.selectedArea = self.viewModel.arrArea.first
            }
            self.txtArea.txt.text = self.selectedArea?.areaName
            let _ = self.txtArea.txt.resignFirstResponder()
            
        } else if sender.tag == self.txtCity.txt.tag {
            if self.selectedCity == nil {
                self.selectedCity = self.viewModel.arrCities.first
            }
            self.selectCity()
            let _ = self.txtCity.txt.resignFirstResponder()
            
        }
    }
    
    //MARK: - PickerView number Of Components method.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - PickerView title For Row method.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == self.txtArea.txt.tag {
            return self.viewModel.arrArea[row].areaName
        } else if pickerView.tag == self.txtCity.txt.tag {
            return self.viewModel.arrCities[row].cityName ?? ""
        } else {
            return ""
        }
        
    }
    
    //MARK: - PickerView number Of Rows In Component method.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == self.txtArea.txt.tag {
            return self.viewModel.numberOfArea()
        } else if pickerView.tag == self.txtCity.txt.tag {
            return self.viewModel.numberOfCity()
        } else {
            return 0
        }
    }
    
    //MARK: - PickerView did Select Row method.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        if pickerView.tag == self.txtCity.txt.tag {
            self.selectedCity = self.viewModel.setCityRow(row: row)
        } else if pickerView.tag == self.txtArea.txt.tag {
            self.selectedArea = self.viewModel.setAreaRow(row: row)
        }
    }
}
// --------------------------------------------
// MARK: - UITexyFeild Delegate Methods
// --------------------------------------------

extension AddAddressVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range = Range(range, in: text) {
            
            let finaltext = text.replacingCharacters(in: range, with: string)
            
            if textField == txtFirstName.txt || textField == txtLastName.txt {
                
                if textField.text == "" {
                    
                    if string == " " {
                        return false
                    }
                }
                
                if finaltext.count > TextFieldMaxLenth.productTitleMaxLength.length {
                    return false
                }
            } else if textField ==  self.txtMobile.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                if finaltext.count > 15 { // Int(kLengthMobile.phoneNumberLength ?? "7") ?? 7 {
                    return false
                }
            }
            
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtCity.txt {
            
            if self.viewModel.numberOfCity() == 0 {
                notifier.showToast(message: Labels.cityNotAvailable)
                return false
            }
            
        }else if textField == self.txtArea.txt {
            
            if self.txtCity.txt.text == "" {
                notifier.showToast(message: Labels.pleaseSelectCity)
                return false
            }
            
            if  self.viewModel.numberOfArea() == 0 {
                notifier.showToast(message: Labels.areaNotAvailable)
                return false
            }
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let pickerview = textField.inputView as? UIPickerView {
            
            self.setDefaultPickerValue(textField, pickerview)
            pickerview.reloadAllComponents()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtFirstName.txt {
            self.txtLastName.txt.becomeFirstResponder()
        }else if textField == self.txtLastName.txt {
            self.txtMobile.txt.becomeFirstResponder()
        } else if textField == self.txtStreetAddress.txt {
            self.txtFloor.txt.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

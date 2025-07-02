//
//  EditProfile.swift
//  Goodz
//
//  Created by Akruti on 01/12/23.
//

import Foundation
import UIKit

class EditProfile : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: ThemeGreenBorderImage!
    
    @IBOutlet weak var vwEditProfile: UIStackView!
    @IBOutlet weak var txtUserName: AppTextField!
    @IBOutlet weak var txtName: AppTextField!
    @IBOutlet weak var txtLastName: AppTextField!
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtMobile: AppTextField!
    @IBOutlet weak var txtDOB: AppTextField!
    @IBOutlet weak var btnUpdate: ThemeGreenButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var vwCommon: UIStackView!
    @IBOutlet weak var vwProUser: UIStackView!
    @IBOutlet weak var vwProUser2: UIStackView!
    @IBOutlet weak var txtNameOne: AppTextField!
    @IBOutlet weak var txtNameTwo : AppTextField!
    @IBOutlet weak var txtNameThree: AppTextField!
    @IBOutlet weak var txtNameFour: AppTextField!
    @IBOutlet weak var txtCity: AppTextField!
    @IBOutlet weak var txtArea: AppTextField!
    @IBOutlet weak var txtSelectAddress: AppTextField!
    @IBOutlet weak var txtFloor: AppTextField!
    @IBOutlet weak var txtId: AppTextField!
    
    @IBOutlet weak var lblStreetAddress: UILabel!
    @IBOutlet weak var lblFloor: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isProUser : Bool = false
    private var viewModel : EditProfileVM = EditProfileVM()
//    var cityId = Int()
//    var areaId = Int()
    var selectedArea : AreaModel?
    var selectedCity : CitiesModel?
    var comeFromSignup = false
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
        print("EditProfile")
        
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        DispatchQueue.main.async {
            self.imgProfile.cornerRadius(cornerRadius: self.imgProfile.frame.size.height / 2)
            self.imgProfile.border(borderWidth: 2, borderColor: .themeGreen)
        }
        self.commonView()
        if !self.isProUser {
            self.editUserView()
        } else {
            self.proUserView()
        }
        [self.txtMobile, self.txtName, self.txtLastName, self.txtNameOne, self.txtNameTwo, self.txtNameThree, self.txtUserName, self.txtNameFour].forEach {
            $0?.txt.delegate = self
        }
        self.setLabels()
        self.txtUserName.isHidden = true
    }
    
    private func commonView() {
        self.txtEmail.txtType = .normal
        self.txtEmail.imgleft.image = UIImage.iconMail
        self.txtEmail.txt.keyboardType = .emailAddress
        self.txtEmail.txt.delegate = self
        
        self.txtMobile.txtType = .phoneNumber
        self.txtMobile.txt.keyboardType = .numberPad
        self.txtMobile.imgleft.image = UIImage.iconMobile
        self.txtMobile.txt.delegate = self
        
        self.txtDOB.txtType = .dropDown
        self.txtDOB.imgleft.image = UIImage.iconCalendar
        self.txtDOB.imgSelect.image = UIImage()
        self.txtDOB.placeholder = Labels.dob
        self.txtDOB.txt.autocorrectionType = .no
        self.txtDOB.txt.delegate = self
        self.txtDOB.txt.setDatePickerAsInputViewFor(target: self, selector: #selector(doneJoiningDateClicked),minimumDate: Constants.birthAgeMinDate, maximumDate: Constants.birthAgeMaxDate)
        
        self.txtEmail.isUserInteractionEnabled = false
        self.txtMobile.isUserInteractionEnabled = false
    }
    
    // --------------------------------------------
    
    private func editUserView() {
        self.imgProfile.image = .avatarUser
        self.vwProUser.isHidden = true
        self.vwProUser2.isHidden = true
        self.vwEditProfile.isHidden = false
      
        self.txtUserName.txtType = .normal
        self.txtUserName.imgleft.image = UIImage.iconUser
        self.txtUserName.txt.delegate = self
        
        self.txtName.txtType = .normal
        self.txtName.imgleft.image = UIImage.iconUser
        self.txtName.txt.delegate = self
        self.txtName.txt.setAutocapitalization(.words)
        
        self.txtLastName.txtType = .normal
        self.txtLastName.imgleft.image = UIImage.iconUser
        self.txtLastName.txt.delegate = self
        self.txtLastName.txt.setAutocapitalization(.words)
    }
    
    @objc func doneJoiningDateClicked() {
        if let datePicker = self.txtDOB.txt.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormat.apiDateFormateymd
            self.txtDOB.txt.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDOB.txt.resignFirstResponder()
    }
    
    // --------------------------------------------
    
    private func proUserView() {
        
        self.vwProUser.isHidden = false
        self.vwProUser2.isHidden = false
        
        self.vwEditProfile.isHidden = true
        [self.txtNameOne, self.txtNameTwo, self.txtNameThree, self.txtNameFour, self.txtId, self.txtEmail].forEach {
            $0.txtType = .normal
        }
        
        self.txtNameOne.imgleft.image = UIImage.iconUser
        
        self.txtNameTwo.imgleft.image = UIImage.iconUser
        self.txtNameTwo.txt.setAutocapitalization(.words)
        
        self.txtNameThree.imgleft.image = UIImage.iconUser
        self.txtNameThree.txt.setAutocapitalization(.words)
        
        self.txtNameFour.imgleft.image = UIImage.iconUser
        self.txtNameFour.txt.setAutocapitalization(.words)
        
        self.txtId.imgleft.image = UIImage.iconUser
        
        self.txtEmail.imgleft.image = UIImage.iconMail
        self.txtEmail.txt.keyboardType = .emailAddress
        self.txtEmail.txt.delegate = self
        
        self.txtMobile.txtType = .phoneNumber
        self.txtMobile.txt.keyboardType = .numberPad
        self.txtMobile.imgleft.image = UIImage.iconMobile
        self.txtMobile.txt.delegate = self
        
        self.txtDOB.txtType = .dropDown
        self.txtDOB.imgleft.image = UIImage.iconCalendar
        self.txtDOB.imgSelect.image = UIImage()
        self.txtDOB.placeholder = Labels.dob
        self.txtDOB.txt.autocorrectionType = .no
        self.txtDOB.txt.delegate = self
        self.txtDOB.txt.setDatePickerAsInputViewFor(target: self, selector: #selector(doneJoiningDateClicked),minimumDate: Constants.birthAgeMinDate, maximumDate: Constants.birthAgeMaxDate)
        
        self.txtCity.txtType = .dropDown
        self.txtCity.imgleft.image = UIImage.iconCity
        self.txtCity.txt.delegate = self
        
        self.txtArea.txtType = .dropDown
        self.txtArea.imgleft.image = UIImage.iconLocation
        self.txtArea.txt.delegate = self
        self.txtSelectAddress.txtType = .normal
        self.txtSelectAddress.imgleft.image = UIImage.iconStreet
        
        self.txtFloor.txtType = .normal
        self.txtFloor.imgleft.image = UIImage.iconFloor
        
        [self.lblFloor, self.lblStreetAddress].forEach {
            $0?.font(font: .regular, size: .size12)
            $0?.color(color: .themeGray)
        }
       
    }
    
    func setLabels() {
        self.lblFloor.text = Labels.floorApartmentNumber
        self.lblStreetAddress.text = Labels.streetAddressVilla
        self.txtFloor.placeholder = Labels.floorPlaceHolder
        self.txtSelectAddress.placeholder = Labels.streetAddressPlaceHolder
        self.txtArea.placeholder = Labels.areaPlaceHolder
        self.txtId.placeholder = Labels.idPlaceHolder
        self.txtCity.placeholder = Labels.selectCity
        self.txtArea.placeholder = Labels.selectArea
        self.txtNameFour.placeholder = Labels.companyName
        self.txtNameThree.placeholder = Labels.lastName
        self.txtNameTwo.placeholder = Labels.firstName
        self.txtNameOne.placeholder = Labels.username
        self.txtEmail.placeholder = Labels.emailPlaceholder
        self.txtMobile.placeholder = Labels.mobilePlaceholder
        self.txtDOB.placeholder = Labels.dob_Placeholder
        self.txtUserName.placeholder = Labels.username
        self.txtName.placeholder = Labels.firstName
        self.txtLastName.placeholder = Labels.lastName
        self.btnUpdate.setTitle(Labels.updateDetails, for: .normal)
    }
    
    private func setData() {
       
        self.txtMobile.countryCodeClicked = {
            self.coordinator?.coutryCodePopup(completion: { code in
                self.txtMobile.lblCode.text = code
            })
        }
        // set api  user data        
        self.txtId.txt.text = currentUser?.userID
        let dob = (currentUser?.birthDate ?? "").dateFormateChange(currDateFormate: DateFormat.appDateFormateMMddYYY, needStringDateFormate: DateFormat.appDateFormateMMddYYY)
        self.txtDOB.txt.text = dob
        self.txtMobile.txt.text = currentUser?.mobile
        self.txtMobile.lblCode.text = currentUser?.countryCode
        self.txtEmail.txt.text = currentUser?.email
        self.txtName.txt.text = currentUser?.firstName
        self.txtLastName.txt.text = currentUser?.lastName
        self.txtUserName.txt.text = currentUser?.username
        self.txtId.isUserInteractionEnabled = false
        
        if let img = currentUser?.userProfile, let url = URL(string: img) {
            self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarUser) //avatar
            self.imgProfile.contentMode = .scaleToFill
        } else {
            self.imgProfile.image = .avatarUser
        }
        
        for (i, txt) in [txtCity,txtArea].enumerated() {
            txt?.txt.tag = i
            txt?.textFieldType = 3
        }
        
        if currentUser?.city != "" {
            selectedCity = CitiesModel(cityName: currentUser?.city ?? "", cityId: Int(currentUser?.cityID ?? "") ?? 0)
        }else{
            selectedCity = nil
        }
        
        if currentUser?.area != "" {
            selectedArea = AreaModel(areaName: currentUser?.area ?? "", areaId: Int(currentUser?.areaID ?? "") ?? 0)
        }else{
            selectedArea = nil
        }
       
//        selectedArea = AreaModel(areaName: currentUser?.area ?? "", areaId: Int(currentUser?.areaID ?? "") ?? 0)
//        selectedCity = CitiesModel(cityName: currentUser?.city ?? "", cityId: Int(currentUser?.cityID ?? "") ?? 0)
       
        // pro user deatils fill
        self.txtCity.txt.text = selectedCity?.cityName
        self.txtArea.txt.text = selectedArea?.areaName
        self.txtSelectAddress.txt.text = currentUser?.streetAddress
        self.txtFloor.txt.text = currentUser?.floor
        self.txtNameOne.txt.text = currentUser?.username
        
        self.txtNameFour.txt.text = currentUser?.storeName
       
        self.txtNameTwo.txt.text = currentUser?.firstName
        self.txtNameThree.txt.text = currentUser?.lastName
        
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        
        notifier.showLoader()
//        self.selectedCity = self.viewModel.arrCities.first(where: { $0.cityName == currentUser?.city })
        viewModel.fetchCityData { [self] _ in
            viewModel.fetchAreaData(cityId: selectedCity?.cityId?.description ?? "") { [self] _ in
                notifier.hideLoader()
                setUppickerView()
            }
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
        
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.editProfile
        self.appTopView.backButtonClicked = { [] in
           
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is GoodzProListVC {
                        navigationController.popToViewController(viewController, animated: true)
                        return
                    }
                }
            }
                self.coordinator?.popVC()
            
            
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
        if self.isProUser {
            self.viewModel.checkProUserDataFirst(profilePicture: self.imgProfile.image ?? UIImage(), username: self.txtNameOne.txt.text!, fName: self.txtNameTwo.txt.text!, lName: self.txtNameThree.txt.text!, companyName: self.txtNameFour.txt.text!, dob: (self.txtDOB.txt.text ?? "").dateFormateChange(currDateFormate: DateFormat.appDateFormateMMddYYY, needStringDateFormate: DateFormat.apiDateFormateymd)) { isDone in
                if isDone {
                    self.viewModel.checkProUserDataSecond(city: self.txtCity.txt.text!, area: self.txtArea.txt.text!, streetAddress: self.txtSelectAddress.txt.text!, floor: self.txtFloor.txt.text!) { isDone in
                        if isDone {
                            self.viewModel.repo.editProfileAPI(profilePicture: self.imgProfile.image ?? UIImage(), userName: self.txtNameOne.txt.text ?? "", dob: (self.txtDOB.txt.text ?? "").dateFormateChange(currDateFormate: DateFormat.appDateFormateMMddYYY, needStringDateFormate: DateFormat.apiDateFormateymd) , email: self.txtEmail.txt.text ?? "", countryCode: self.txtMobile.lblCode.text ?? "", mobile: self.txtMobile.txt.text ?? "", name: self.txtNameTwo.txt.text ?? "", city: self.selectedCity?.cityId?.description ?? "", streetAddress: self.txtSelectAddress.txt.text ?? "", area: self.selectedArea?.areaId?.description ?? "", floor: self.txtFloor.txt.text ?? "", lastName: self.txtNameThree.txt.text ?? "", companyName: self.txtNameFour.txt.text ?? "") { status, error in
                                if isDone {
                                    GlobalRepo.shared.getProfileAPI { _, _, _ in }
                                    if self.comeFromSignup {
                                        self.coordinator?.navigateToDocumentHelpCenter(isPro: true)
                                    } else {
                                        if let navigationController = self.navigationController {
                                            for viewController in navigationController.viewControllers {
                                                if viewController is GoodzProListVC {
                                                    navigationController.popToViewController(viewController, animated: true)
                                                    break
                                                } else {
                                                    self.coordinator?.popVC()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.viewModel.checkUserData(profilePicture: self.imgProfile.image ?? UIImage(), username: self.txtUserName.txt.text ?? "", firstName: self.txtName.txt.text ?? "", email: self.txtEmail.txt.text ?? "", countryCode: self.txtMobile.lblCode.text ?? "", mobile: self.txtMobile.txt.text ?? "", dob: (self.txtDOB.txt.text ?? "").dateFormateChange(currDateFormate: DateFormat.appDateFormateMMddYYY, needStringDateFormate: DateFormat.apiDateFormateymd), lastName: txtLastName.txt.text ?? "", companyName: "") { isDone in
                if isDone {
                    GlobalRepo.shared.getProfileAPI { _, _, _ in }
                    self.coordinator?.popVC()
                }
            }
            
        }
    }
    
    // --------------------------------------------
    
    @IBAction func btnCamerTapped(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            self.imgProfile.image = img
        }
    }
    
    // --------------------------------------------
    
}

extension EditProfile: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range = Range(range, in: text) {
            let finaltext = text.replacingCharacters(in: range, with: string)
            if textField == self.txtName.txt ||  textField == self.txtNameOne.txt ||  textField == self.txtNameTwo.txt ||  textField == self.txtNameThree.txt ||  textField == self.txtNameFour.txt || textField == self.txtUserName.txt || textField == self.txtLastName.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                if finaltext.count > TextFieldMaxLenth.productTitleMaxLength.length {
                    return false
                }
                
            } else if textField == txtUserName.txt  || textField == txtEmail.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                
            } else if textField ==  self.txtMobile.txt {
                if textField.text == "" {
                    if string == " " {
                        return false
                    }
                }
                if finaltext.count > TextFieldMaxLenth.contactNumberMinLenth.length {
                    return false
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtDOB.txt {
            
            if let datepicker = self.txtDOB.txt.inputView as? UIDatePicker {
                let date = (self.txtDOB.txt.text ?? "").toDate(withFormat: DateFormat.appDateFormateMMddYYY) ?? Date()
                datepicker.date = date
            }
        } else  if textField == txtCity.txt {
            
            if viewModel.numberOfCity() == 0 {
                notifier.showToast(message: Labels.cityNotAvailable)
                return false
            }
            
        }else if textField == txtArea.txt {
            
            if txtCity.txt.text == "" {
                notifier.showToast(message: Labels.pleaseSelectCity)
                return false
            }
            
            if  viewModel.numberOfArea() == 0 {
                notifier.showToast(message: Labels.areaNotAvailable)
                return false
            }
            
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let pickerview = textField.inputView as? UIPickerView {
            
            setDefaultPickerValue(textField, pickerview)
            pickerview.reloadAllComponents()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.txtUserName.txt {
            self.txtName.txt.becomeFirstResponder()
        } else if textField == self.txtName.txt {
            self.txtLastName.txt.becomeFirstResponder()
        } else if textField == self.txtLastName.txt {
            self.txtEmail.txt.becomeFirstResponder()
        } else if textField == self.txtEmail.txt {
            self.txtMobile.txt.becomeFirstResponder()
        } else if textField == self.txtMobile.txt {
            self.txtDOB.txt.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

// --------------------------------------------
// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
// --------------------------------------------

extension EditProfile : UIPickerViewDelegate, UIPickerViewDataSource {
    func setDefaultPickerValue(_ textField: UITextField, _ pickerView: UIPickerView) {
        var index = 0
        
        if textField == txtArea.txt {
            index = viewModel.arrArea.firstIndex(where: {$0 == selectedArea}) ?? 0
            
        }else if textField == txtCity.txt {
            index = viewModel.arrCities.firstIndex(where: {$0 == selectedCity}) ?? 0
            
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func setUppickerView() {
        
        for txt in [txtCity.txt,txtArea.txt] {
            
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
            
            setDefaultPickerValue(textField, pickerView)
            
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
        
        txtArea.txt.text = nil
        selectedArea = nil
        viewModel.arrArea.removeAll()
        txtCity.txt.text = selectedCity?.cityName
        
        viewModel.fetchAreaData(cityId: selectedCity?.cityId?.description ?? "") { _ in }
    }
    
    
    @objc func doneClick(sender: UIButton) {
        
        if sender.tag == txtArea.txt.tag {
            
            if selectedArea == nil {
                selectedArea = viewModel.arrArea.first
            }
            
            txtArea.txt.text = selectedArea?.areaName
            let _ = txtArea.txt.resignFirstResponder()
            
        }else if sender.tag == txtCity.txt.tag {
            
            if selectedCity == nil {
                selectedCity = viewModel.arrCities.first
            }
            
            selectCity()
            let _ = txtCity.txt.resignFirstResponder()
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == self.txtArea.txt.tag {
                return self.viewModel.numberOfArea()
        } else if pickerView.tag == self.txtCity.txt.tag {
                return self.viewModel.numberOfCity()
            } else {
                return 0
            }
    }
    
    // --------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // --------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == self.txtArea.txt.tag {
            return self.viewModel.setAreaRow(row: row).areaName
        } else if pickerView.tag == self.txtCity.txt.tag {
            return self.viewModel.setCityRow(row: row).cityName
        } else {
            return ""
        }
        
    }
    
    // --------------------------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == self.txtArea.txt.tag {
            selectedArea = viewModel.setAreaRow(row: row)
        } else if pickerView.tag == self.txtCity.txt.tag {
            selectedCity = viewModel.setCityRow(row: row)
        } else {}
        
    }
    
    // --------------------------------------------
}


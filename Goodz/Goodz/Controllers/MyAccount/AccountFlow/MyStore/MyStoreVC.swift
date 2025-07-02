//
//  MyStoreVC.swift
//  Goodz
//
//  Created by Akruti on 04/12/23.
//

import Foundation
import UIKit

struct EditStoreData {
    let storeId :String
    let storeName : String
    let city : CitiesModel
    let area : AreaModel
    let description : String
    let storeImage : String
}
class MyStoreVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var imgProfile: ThemeGreenBorderImage!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtStoreName: AppTextField!
    @IBOutlet weak var txtCity: AppTextField!
    @IBOutlet weak var txtState: AppTextField!
    @IBOutlet weak var vwTextView: UIView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var imgDescription: UIImageView!
    @IBOutlet weak var btnSkip: ThemeGreenBorderButton!
    @IBOutlet weak var btnContinue: ThemeGreenButton!
    
    @IBOutlet weak var vwSkip: UIStackView!
    @IBOutlet weak var btnUpdate: ThemeGreenButton!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var isEditable : Bool = false
    private var viewModel : MyStoreVM = MyStoreVM()
    var editStoreData: EditStoreData?
    var selectedArea : AreaModel?
    var selectedCity : CitiesModel?
    var storeImage: UIImage?
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.setData()
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
        self.imgProfile.image = .avatarStore
        self.vwTextView.cornerRadius(cornerRadius: 4.0)
        self.vwTextView.border(borderWidth: 1, borderColor: .themeBorder)
        
        self.imgProfile.cornerRadius(cornerRadius: self.imgProfile.frame.size.height / 2)
        self.imgProfile.border(borderWidth: 2, borderColor: .themeGreenProfile)
        self.imgProfile.image = .avatarStore
        
        self.txtCity.txtType = .normal
        self.txtCity.imgleft.image = UIImage.iconLocation
        self.txtCity.txt.delegate = self
        
        self.txtState.txtType = .normal
        self.txtState.imgleft.image = UIImage.iconLocation
        self.txtState.txt.delegate = self
        
        for (i, txt) in [txtCity,txtState].enumerated() {
            txt?.txt.tag = i
            txt?.textFieldType = 3
        }
        
        self.txtStoreName.txtType = .normal
        self.txtStoreName.imgleft.image = UIImage.iconCompany
        self.txtStoreName.txt.delegate = self
        self.txtStoreName.txt.setAutocapitalization()
        
        self.tvDescription.font(font: .regular, size: .size14)
        self.tvDescription.delegate = self
        self.tvDescription.setPlaceholder(text: Labels.enterDescription, color: UIColor.lightGray)
        self.tvDescription.setAutocapitalization()
        
        self.vwSkip.isHidden = !self.isEditable ? true : false
        self.btnUpdate.isHidden = !self.isEditable ? false : true
        
        
    }
    
    func apiCalling() {
        
        if isEditable {
            self.txtStoreName.txt.text = editStoreData?.storeName
            self.txtCity.txt.text = editStoreData?.city.cityName
            self.txtState.txt.text = editStoreData?.area.areaName
            self.tvDescription.textColor = UIColor.black
            self.tvDescription.text = editStoreData?.description
            self.tvDescription.checkPlaceholder()
            
            self.imgProfile.tintColor = .themeGreenProfile
            
            if let img = editStoreData?.storeImage, let url = URL(string: img) {
                self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarStore)
                self.imgProfile.contentMode = .scaleAspectFill
            } else {
                self.imgProfile.image = .avatarStore
            }
            
            selectedCity = CitiesModel(
                cityName: editStoreData?.city.cityName,
                cityId: editStoreData?.city.cityId
            )
            
            selectedArea = AreaModel(
                areaName: editStoreData?.area.areaName,
                areaId: editStoreData?.area.areaId
            )
        }
        notifier.showLoader()
        
        viewModel.fetchCityData { [self] _ in
            viewModel.fetchAreaData(cityId: selectedCity?.cityId?.description ?? "") { [self] _ in
                notifier.hideLoader()
                setUppickerView()
            }
        }
    }
    
    // --------------------------------------------
    
    func setEditStoreData() {
        if isEditable {
            self.txtStoreName.txt.text = editStoreData?.storeName
            self.txtCity.txt.text = editStoreData?.city.cityName
            self.txtState.txt.text = editStoreData?.area.areaName
            self.tvDescription.textColor = UIColor.black
            self.tvDescription.text = editStoreData?.description
            self.tvDescription.checkPlaceholder()
            
            self.imgProfile.tintColor = .themeGreenProfile
            
            if let img = editStoreData?.storeImage, let url = URL(string: img) {
                self.imgProfile.sd_setImage(with: url, placeholderImage: .avatarStore)
                self.imgProfile.contentMode = .scaleAspectFill
            } else {
                self.imgProfile.image = .iconUserPlaceholder
            }
            
            selectedCity = CitiesModel(
                cityName: editStoreData?.city.cityName,
                cityId: editStoreData?.city.cityId
            )
            
            selectedArea = AreaModel(
                areaName: editStoreData?.area.areaName,
                areaId: editStoreData?.area.areaId
            )
        }
    }
    // --------------------------------------------
    
    func setData() {
        self.txtCity.placeholder = Labels.selectCity
        self.txtState.placeholder = Labels.selectArea
        self.txtStoreName.placeholder = Labels.enterCompanyName
        self.btnUpdate.setTitle(Labels.updateDetails, for: .normal)
        self.btnSkip.setTitle(Labels.skip, for: .normal)
        self.btnContinue.setTitle(Labels.continueTitle, for: .normal)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        
        self.appTopView.textTitle = self.isEditable ? Labels.editStore :  Labels.storeDetail
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.apiCalling()
        self.setEditStoreData()
    }
    
    // --------------------------------------------
    
    func attachmentHandler() {
        
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
        
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            imgProfile.image = img
            storeImage = img
        }
    }
    
    // --------------------------------------------
    func apiEditStore() {
        self.viewModel.checkMyStoreData(companyName: self.txtStoreName.txt.text ?? "", city: self.txtCity.txt.text ?? "", state: self.txtState.txt.text ?? "", description: tvDescription.text ?? "", storeImage: self.imgProfile.image) { [self] isDone in
            if isDone {
                if let storeId = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID {
                    print("success...")
                    
                    viewModel.editStoreDetailsData(
                        storeId: storeId,
                        storeName: txtStoreName.txt.text ?? "",
                        storeImage: imgProfile.image ?? UIImage(),
                        storeCityId: selectedCity?.cityId?.description ?? "",
                        storeAreaId: selectedArea?.areaId?.description ?? "",
                        description: tvDescription.text ?? ""
                    ) { [self] done in
                        
                        if done {
                            GlobalRepo.shared.getProfileAPI { _, _, _ in }
                            showOKAlert(title: Labels.appname, message: Labels.storeDetailUpdatedSuccessfully, okAction: { [self] in
                                coordinator?.popVC()
                            })
                        }
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnContinueTapped(_ sender: Any) {
//        var des : String = ""
//        if self.tvDescription.textColor == UIColor.lightGray {
//            des = ""
//        } else {
//            des = self.tvDescription.text!
//        }
//        
//        self.viewModel.checkMyStoreData(companyName: self.txtStoreName.txt.text ?? "", city: self.txtCity.txt.text ?? "", state: self.txtState.txt.text ?? "", description: des, storeImage: storeImage) { isDone in
//            if isDone {
//                if let id = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID {
//                    self.coordinator?.navigateToPopularStore(storeId: id)
//                }
//            }
//        }
        self.apiEditStore()
    }
    
    // --------------------------------------------
    
    @IBAction func btnSkipTapped(_ sender: Any) {
//        let id = appUserDefaults.codableObject(dataType : CurrentUserModel.self,key: .currentUser)?.storeID
//        self.coordinator?.navigateToPopularStore(storeId: id ?? "")
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func btnUpdateTapped(_ sender: ThemeGreenButton) {
        self.apiEditStore()
    }
    
    @IBAction func btnChooseAction(_ sender: UIButton) {
        attachmentHandler()
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension MyStoreVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

extension MyStoreVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - SetUp PickerView.
    func setDefaultPickerValue(_ textField: UITextField, _ pickerView: UIPickerView) {
        var index = 0
        
        if textField == txtState.txt {
            index = viewModel.arrArea.firstIndex(where: {$0 == selectedArea}) ?? 0
            
        }else if textField == txtCity.txt {
            index = viewModel.arrCities.firstIndex(where: {$0 == selectedCity}) ?? 0
            
        }
        
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    func setUppickerView() {
        
        for txt in [txtCity.txt,txtState.txt] {
            
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
        
        txtState.txt.text = nil
        selectedArea = nil
        viewModel.arrArea.removeAll()
        txtCity.txt.text = selectedCity?.cityName
        
        viewModel.fetchAreaData(cityId: selectedCity?.cityId?.description ?? "") { _ in }
    }
    
    
    @objc func doneClick(sender: UIButton) {
        
        if sender.tag == txtState.txt.tag {
            
            if selectedArea == nil {
                selectedArea = viewModel.arrArea.first
            }
            
            txtState.txt.text = selectedArea?.areaName
            let _ = txtState.txt.resignFirstResponder()
            
        }else if sender.tag == txtCity.txt.tag {
            
            if selectedCity == nil {
                selectedCity = viewModel.arrCities.first
            }
            
            selectCity()
            let _ = txtCity.txt.resignFirstResponder()
            
        }
    }
    
    //MARK: - PickerView number Of Components method.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - PickerView title For Row method.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == txtState.txt.tag {
            return viewModel.arrArea[row].areaName
        }else if pickerView.tag == txtCity.txt.tag {
            return viewModel.arrCities[row].cityName ?? ""
        }else {
            return ""
        }
        
    }
    
    //MARK: - PickerView number Of Rows In Component method.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == txtState.txt.tag {
            return viewModel.numberOfArea()
        }else if pickerView.tag == txtCity.txt.tag {
            return viewModel.numberOfCity()
        }else {
            return 0
        }
    }
    
    //MARK: - PickerView did Select Row method.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)  {
        if pickerView.tag == txtCity.txt.tag {
            selectedCity = viewModel.setCityRow(row: row)
        }else if pickerView.tag == txtState.txt.tag {
            selectedArea = viewModel.setAreaRow(row: row)
        }
    }
}

//MARK: - UITextFieldDelegate
extension MyStoreVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if [txtCity.txt,txtState.txt].contains(textField) {
            return false
        }
        
        if let text = textField.text, let range = Range(range, in: text) {
            
            let finaltext = text.replacingCharacters(in: range, with: string)
            
            if textField == txtStoreName.txt {
                
                if textField.text == "" {
                    
                    if string == " " {
                        return false
                    }
                }
                
                if finaltext.count > TextFieldMaxLenth.productTitleMaxLength.length {
                    return false
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtCity.txt {
            
            if viewModel.numberOfCity() == 0 {
                notifier.showToast(message: Labels.cityNotAvailable)
                return false
            }
            
        }else if textField == txtState.txt {
            
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
        
        if textField == txtStoreName.txt {
            txtCity.txt.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}

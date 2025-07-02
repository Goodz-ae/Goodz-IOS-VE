//
//  BrandsVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit

class BrandsVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerView: AppStatusView!
    @IBOutlet weak var tbvBrands: UITableView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSeperator: UIView!
    @IBOutlet weak var btnDone: ThemeGreenButton!
    @IBOutlet weak var btnCancel: ThemeGreenBorderButton!
    @IBOutlet weak var btnSave: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : BrandVM = BrandVM()
    var page : Int = 1
    var strSearch : String = ""
    var selectedIndex : Int = -1
    var completion : (([BrandModel]?) -> ())?
    var isMultipleSelection : Bool = false
    var arrSelectBrands : [BrandModel] = []
    var selectedID : String = ""
    var workItem : DispatchWorkItem?
    var isFromCustomization = false
    var customizationModel: CustomizationModels?
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
        
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalling(isShowLoader: true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods
    // --------------------------------------------
    
    private func setUp() {        
        self.txtSearch.delegate = self
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
        self.registerTableView()
        
        self.btnDone.font(font: .semibold, size: .size16)
        self.btnCancel.font(font: .semibold, size: .size16)
        self.btnSave.font(font: .semibold, size: .size16)
        self.btnDone.isHidden = isFromCustomization
        self.btnCancel.isHidden = !isFromCustomization
        self.btnSave.isHidden = !isFromCustomization
        self.setLabels()
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.headerView.lblTitle.text = Labels.brands
        self.txtSearch.placeholder = Labels.searchBrand
        self.btnDone.title(title: Labels.done)
        self.btnCancel.title(title: Labels.cancel)
        self.btnSave.title(title: Labels.save)

    }
    // --------------------------------------------
    
    func apiCalling(isShowLoader: Bool) {
        self.viewModel.fetchData(pageNo: self.page, serach: self.strSearch,isShowLoader: isShowLoader) { [self] isDone in
            if isDone {
                self.setNoData(scrollView: self.tbvBrands, noDataType: .productEmptyData)
                if self.arrSelectBrands.count == 0 {
                    self.arrSelectBrands = self.viewModel.arrBrand.filter({$0.isCustomizationSelected == "1"})
                }
                self.tbvBrands.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            
            if isFromCustomization {
                self.btnCancel.isHidden = (viewModel.arrBrand.count == 0)
                self.btnSave.isHidden = (viewModel.arrBrand.count == 0)
            }else {
                self.btnDone.isHidden = (viewModel.arrBrand.count == 0)
            }
            
            self.tbvBrands.reloadData()
            self.tbvBrands.endRefreshing()
        }
    }
    
    // --------------------------------------------
    
    private func registerTableView() {
        self.tbvBrands.delegate = self
        self.tbvBrands.dataSource = self
        self.tbvBrands.register(SingleSelectionCell.nib, forCellReuseIdentifier: SingleSelectionCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    // MARK: - Action methods
    // --------------------------------------------
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        
        if isFromCustomization {
            var arr = [SelectedItemsList]()
            for brand in arrSelectBrands {
                arr.append(SelectedItemsList(id: brand.brandID, name: brand.brandTitle, selectedSubItemsList: nil))
            }
            
            if var model = customizationModel {
                model.selectedItemsList = arr
                customizationModel = model
            } else {
                customizationModel = CustomizationModels(title: CustomizationType.brands.title, type: CustomizationType.brands.title, id: "", selectedItemsList: arr)
            }
            
            if let selectedIndex = appDelegate.arrCustomization.firstIndex(where: { $0.type == CustomizationType.brands.title }), let data = customizationModel {
                appDelegate.arrCustomization[selectedIndex] = data
                appDelegate.isCustomizationChanges = true
            } else if let data = customizationModel {
                appDelegate.arrCustomization.append(data)
                appDelegate.isCustomizationChanges = true
            }
            
            self.completion?(self.arrSelectBrands)
            
        } else {
            if self.isMultipleSelection {
//                if self.arrSelectBrands.count < 1 {
//                    notifier.showToast(message: Labels.pleaseSelectBrand)
//                    return
//                }
                self.completion?(self.arrSelectBrands)
            } else {
                if self.selectedIndex > -1 {
                    self.completion?([self.viewModel.setBrands(row: self.selectedIndex)])
                }else if selectedID != "" {
                    if let index = self.viewModel.arrBrand.firstIndex(where: {$0.brandID == selectedID}) {
                        self.completion?([self.viewModel.setBrands(row: index)])
                    }
                } else {
                    completion?([])
                }
            }
        }
        
        self.coordinator?.popVC()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
     
        var arr = [SelectedItemsList]()
        for brand in arrSelectBrands {
            arr.append(SelectedItemsList(id: brand.brandID, name: brand.brandTitle, selectedSubItemsList: nil))
        }
        
        if var model = customizationModel {
            model.selectedItemsList = arr
            customizationModel = model
        } else {
            customizationModel = CustomizationModels(title: CustomizationType.brands.title, type: CustomizationType.brands.title, id: "", selectedItemsList: arr)
        }
        
        if let selectedIndex = appDelegate.arrCustomization.firstIndex(where: { $0.type == CustomizationType.brands.title }), let data = customizationModel {
            appDelegate.arrCustomization[selectedIndex] = data
            appDelegate.isCustomizationChanges = true
        } else if let data = customizationModel {
            appDelegate.arrCustomization.append(data)
            appDelegate.isCustomizationChanges = true
        }
        
        self.completion?(self.arrSelectBrands)
        
        self.coordinator?.popVC()
    }
}

extension BrandsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let range = Range(range, in: text) {
            
            let searchtext = text.replacingCharacters(in: range, with: string)
            
            workItem?.cancel()
            workItem = DispatchWorkItem { [weak self] in
                
                guard let strongself = self else {
                    return
                }
                
                strongself.strSearch = searchtext
                strongself.page = 1
                strongself.apiCalling(isShowLoader: false)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem!)
        }
        
        return true
    }
}

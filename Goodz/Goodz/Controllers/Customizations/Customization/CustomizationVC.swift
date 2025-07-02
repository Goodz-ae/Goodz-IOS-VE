//
//  CustomizationVC.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import Foundation
import UIKit

class CustomizationVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblCustomization: UITableView!
    @IBOutlet weak var consHeightTable: NSLayoutConstraint!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnReset: ThemeGreenButton!
    @IBOutlet weak var btnSave: ThemeGreenButton!
    @IBOutlet weak var btnCancel: ThemeGreenBorderButton!
    @IBOutlet weak var vwScroll: UIScrollView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : CustomizationVM = CustomizationVM()
    var page  : Int = 1
    var arrBrands = [BrandModel]()
    var categoryMain : CategoryMainModel?
    var categorySub : CategorySubModel?
    var categoryCollection : CategoryCollectionModel?
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblCustomization.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblCustomization.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        appDelegate.arrCustomization.removeAll()
        
        self.tblCustomization.cornerRadius(cornerRadius: 4.0)
        
        self.lblDescription.font(font: .regular, size: .size14)
        self.lblDescription.color(color: .themeBlack)
        
        self.apiCalling()
        let nib = UINib(nibName: "CustomizationCell", bundle: nil)
        self.tblCustomization.register(nib , forCellReuseIdentifier: "CustomizationCell")
        self.tblCustomization.delegate = self
        self.tblCustomization.dataSource = self
        self.tblCustomization.isHidden = true
        
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
        
        self.btnReset.font(font: .semibold, size: .size16)
        self.btnCancel.font(font: .semibold, size: .size16)
        self.btnSave.font(font: .semibold, size: .size16)
        
        self.btnReset.isHidden = true
        self.btnSave.isHidden = true
        self.btnCancel.isHidden = true
        
        self.setLabels()
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblDescription.text = Labels.commitmentContentOne
        self.btnReset.title(title: Labels.reset)
        self.btnCancel.title(title: Labels.cancel)
        self.btnSave.title(title: Labels.save)
    }
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        
        self.viewModel.dispatchGroup.enter()
        self.viewModel.fetchCustomizationData() { isDone in
            self.viewModel.dispatchGroup.leave()
        }
        
        self.viewModel.dispatchGroup.enter()
        self.viewModel.fetchData(pageNo: self.page) { isDone in
            self.viewModel.dispatchGroup.leave()
        }
        
        self.viewModel.dispatchGroup.enter()
        self.viewModel.fetchBrandsData(completion: { _ in
                self.viewModel.dispatchGroup.leave()
        })
        
        self.viewModel.dispatchGroup.notify(queue: .main) {
            self.btnReset.isHidden = appDelegate.arrCustomization.count == 0
            self.tblCustomization.isHidden = false
            self.tblCustomization.reloadData()
            self.vwScroll.endRefreshing()
        }
        
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblCustomization && keyPath == "contentSize" {
            self.consHeightTable.constant = self.tblCustomization.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.customization
        self.appTopView.backButtonClicked = {
            appDelegate.isCustomizationChanges = false
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        appDelegate.isCustomizationChanges = false
        appDelegate.arrCustomization.removeAll()
        self.tblCustomization.reloadData()
        self.btnReset.isHidden = true
        self.btnSave.isHidden = true
        self.btnCancel.isHidden = true
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        self.viewModel.customizationRepo.saveCustomizationAPI() { [self] status, error in
            showOKAlert(title: Labels.goodz, message: Labels.saveCustomizationSuccessfully) { [self] in
                appDelegate.isCustomizationChanges = false
                self.btnReset.isHidden = false
                self.btnSave.isHidden = true
                self.btnCancel.isHidden = true
                self.tblCustomization.reloadData()
            }
        }
    }
    
    
    @IBAction func btnResetAction(_ sender: ThemeGreenButton) {
        if !appDelegate.isCustomizationChanges {
            appDelegate.arrCustomization.removeAll()
        }
        self.viewModel.customizationRepo.saveCustomizationAPI() { [self] status, error in
            showOKAlert(title: Labels.goodz, message: Labels.resetCustomizationSuccessfully) { [self] in
                appDelegate.isCustomizationChanges = false
                self.btnReset.isHidden = true
                self.btnSave.isHidden = true
                self.btnCancel.isHidden = true
                self.tblCustomization.reloadData()
            }
        }
    }
}

// --------------------------------------------
// MARK: - UItableView Delegate and DataSource
// --------------------------------------------

extension CustomizationVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as CustomizationCell
        
        if indexPath.row == 0 {
            cell.lblTitle.text = Labels.brands
            cell.imgTitle.sd_setImage(with: URL(string: viewModel.brandUrl))
            let selectedBrands = appDelegate.arrCustomization.filter{ $0.type == CustomizationType.brands.title }.first?.selectedItemsList?.compactMap{ $0.name }.joined(separator: ", ")
            cell.lblDescription.text = selectedBrands
            cell.vwSeperator.isHidden = viewModel.numberOfRows() < 1
        }else {
            let data = self.viewModel.setSubCategories(row: indexPath.row-1)
            let selectedCategory = appDelegate.arrCustomization.filter{ $0.id == data.categoriesMainId }.first
            cell.lblDescription.text = selectedCategory?.selectedItemsList?.compactMap{ $0.name }.joined(separator: ", ")
            cell.setDataCustomization(data: data, lastRow: self.viewModel.numberOfRows()-1, currentRow: indexPath.row)
        }
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let selectedBrands = appDelegate.arrCustomization.filter{ $0.type == CustomizationType.brands.title }.first
            let arrSelectedBrands = selectedBrands?.selectedItemsList?.compactMap{ BrandModel(brandTitle: $0.name, brandID: $0.id, isCustomizationSelected: "") }
            self.coordinator?.navigateToBrands(selectedBrands: arrSelectedBrands ?? [], isMultipleSelection: true, id: "", isFromCustomization: true, customizationModel: selectedBrands) { brands in
                self.arrBrands = brands ?? []
            
                self.btnReset.isHidden = appDelegate.isCustomizationChanges
                self.btnSave.isHidden = !appDelegate.isCustomizationChanges
                self.btnCancel.isHidden = !appDelegate.isCustomizationChanges
                
                self.tblCustomization.reloadData()
            }
            
        }else {
            let data = self.viewModel.setSubCategories(row: indexPath.row-1)
            //            self.coordinator?.navigateToCustomization(categoryMain: data)
            let selectedCategory = appDelegate.arrCustomization.filter{ $0.id == data.categoriesMainId }.first
            self.coordinator?.navigateToSubCategory(selectedData: [],openType: .comeFrromCustomization, title: data.categoriesMainTitle ?? "", categoryMain: data, customizationModel: selectedCategory, completion: { [self] categoryMainData, categorySubData, categoryCollectionData in
                self.categoryMain = categoryMainData
                self.categorySub = categorySubData
                self.categoryCollection = categoryCollectionData
                self.btnReset.isHidden = appDelegate.isCustomizationChanges
                self.btnSave.isHidden = !appDelegate.isCustomizationChanges
                self.btnCancel.isHidden = !appDelegate.isCustomizationChanges
                self.tblCustomization.reloadData()
            })
        }
        
        self.tblCustomization.reloadData()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = self.viewModel.numberOfRows()-1
        
        if (total - 1) == indexPath.row && self.viewModel.totalRecords > total {
            self.page += 1
            self.apiCalling()
        }
        
    }
    
    // --------------------------------------------
    
}

//
//  CustomizationItemVC.swift
//  Goodz
//
//  Created by Akruti on 19/12/23.
//

import Foundation
import UIKit

class CustomizationItemVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var consHeightTable: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: ThemeGreenBorderButton!
    @IBOutlet weak var btnSave: ThemeGreenButton!
    
    @IBOutlet weak var vwScroll: UIScrollView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var arrItems : [SubCustomizationModel]  = []
    var selectedItems = NSMutableArray()
    var categoryMain : CategoryMainModel?
    private var viewModel : CustomizationItemVM = CustomizationItemVM()
    var page : Int = 1
    var categoryMainId = String()
    var categorySubId = String()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.apiCalling()
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblItems.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.tblItems.cornerRadius(cornerRadius: 4.0)
        let nib = UINib(nibName: "CustomizationItemCell", bundle: nil)
        self.tblItems.register(nib , forCellReuseIdentifier: "CustomizationItemCell")
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        self.vwScroll.addRefreshControl(target: self, action: #selector(refreshData))
        
        self.btnCancel.font(font: .semibold, size: .size16)
        self.btnSave.font(font: .semibold, size: .size16)
        self.setLabel()
    }
    
    // --------------------------------------------
    
    func setLabel() {
        self.btnSave.title(title: Labels.save)
        self.btnCancel.title(title: Labels.cancel)
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchGetCustomization(mainId: self.categoryMain?.categoriesMainId ?? "") { isDone in
            if isDone {
                self.tblItems.reloadData()
            }
        }
        self.viewModel.fetchData(pageNo: self.page, id: self.categoryMain?.categoriesMainId ?? "") { isDone in
            if isDone {
                self.tblItems.reloadData()
            }
        }
        self.vwScroll.endRefreshing()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblItems && keyPath == "contentSize" {
            self.consHeightTable.constant = self.tblItems.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = self.categoryMain?.categoriesMainTitle ?? ""
        self.appTopView.backButtonClicked = {
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
    
    @IBAction func btnCencelTapped(_ sender: Any) {
        self.coordinator?.popVC()
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        self.viewModel.saveCustomization(categoryMainId: "1", arrSubId: "2", arrCollectionId: "13,14") { isDone in
            self.coordinator?.popVC()
        }
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UItableView Delegate and DataSource
// --------------------------------------------

extension CustomizationItemVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizationItemCell", for: indexPath) as! CustomizationItemCell
        cell.setDataCustomization(data: self.viewModel.setSubCategories(row: indexPath.row), lastRow: self.viewModel.numberOfRows(), currentRow: indexPath.row)
        cell.btnSelect.isUserInteractionEnabled = false
        let subCategoryModel = self.viewModel.setSubCategories(row: indexPath.row)
        let commonSubIDs = Set(self.viewModel.arrSubCategory.compactMap { $0.categoriesSubId })
//            .intersection(Set(self.viewModel.arrCustomization.compactMap { $0.categoriesSubID }))
        
        if let categoriesSubId = subCategoryModel.categoriesSubId,
           commonSubIDs.contains(categoriesSubId) {
            cell.btnSelect.isSelected = true
        } else {
            cell.btnSelect.isSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataSelected = [CategoryCollectionModel]()
        let selectedSubCategory = self.viewModel.setSubCategories(row: indexPath.row)
        let commonSubIDs = Set(self.viewModel.arrSubCategory.compactMap { $0.categoriesSubId })
//            .intersection(Set(self.viewModel.arrCustomization.compactMap { $0.categoriesSubID }))
        if let selectedSubId = selectedSubCategory.categoriesSubId, commonSubIDs.contains(selectedSubId) {
//            let matchingCustomizationModels = self.viewModel.arrCustomization.filter { $0.categoriesSubID == selectedSubId }
//            if let firstMatchingModel = matchingCustomizationModels.first {
//                dataSelected = firstMatchingModel.categoriesSubData ?? [CategoryCollectionModel]()
//            }
        }
        
        DispatchQueue.main.async {
            let data = self.viewModel.setSubCategories(row: indexPath.row)
            self.categorySubId = data.categoriesSubId ?? ""
            self.coordinator?.navigateToCustomCategory(openType: .comeFrromCustomization, selectedData: dataSelected, title: data.categoriesSubTitle ?? "", categoryMain : self.categoryMain, categorySub: data, completion: { selectedData in
                print(selectedData)
            })
            self.tblItems.reloadData()
        }
    }
}

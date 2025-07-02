//
//  CategoryListVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit
enum OpenTypeCategory {
    case comeFromSell
    case comeFrromCustomization
    case comeFromFilter
    case other
}
class CategoryListVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tbvCategory: UITableView!
    @IBOutlet weak var btnDone: ThemeGreenButton!
    @IBOutlet weak var btnCancel: ThemeGreenBorderButton!
    @IBOutlet weak var btnSave: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var titleText: String = ""
    var viewModel = CategoryListVM(arrSubCollectionCategory: [CategoryCollectionModel]())
    var subCategoryID = ""
    var page : Int = 1
    var categoryMain : CategoryMainModel?
    var categorySub : CategorySubModel?
    var categoryCollection : CategoryCollectionModel?
    var arrSelectedCategory : [CategoryCollectionModel] = []
    var didSelectSubCategories: (([CategoryCollectionModel]) -> Void)?
    var openType : OpenTypeCategory = .other
    var completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?
    var customizationModels: CustomizationModels?
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.registerTableView()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(pageNo: self.page, id: self.categorySub?.categoriesSubId ?? "") { [self] isDone in
            if !isDone {
                self.setNoData(scrollView: self.tbvCategory, noDataType: .productEmptyData)
                self.tbvCategory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                self.btnDone.isHidden = true
            }
            print(self.openType)
            
            if openType == .comeFromFilter {
                if self.arrSelectedCategory.count == 0 {
                    self.arrSelectedCategory = viewModel.arrSubCollectionCategory.filter({$0.isCustomizationSelected == "1"})
                }
            }
            
            if self.openType == .comeFrromCustomization {
                let categorySubData = self.customizationModels?.selectedItemsList?.first(where: { $0.id == self.categorySub?.categoriesSubId })
                var arrSelectedData = [CategoryCollectionModel]()
                for data in (categorySubData?.selectedSubItemsList ?? []) {
                    if let selectedSubCatData = self.viewModel.arrSubCollectionCategory.first(where: { $0.categoryCollectionId == data.id }) {
                        arrSelectedData.append(selectedSubCatData)
                    }
                }
                self.arrSelectedCategory = arrSelectedData
                self.btnDone.isHidden = true

            }
            if isDone && self.openType != .comeFrromCustomization{
                if self.viewModel.numberOfRows() == 0 {
                    self.setNoData(scrollView: self.tbvCategory, noDataType: .productEmptyData)
                    self.tbvCategory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                    self.btnDone.isHidden = true
                }  else if openType == .other || openType == .comeFromSell {
                    self.btnDone.isHidden = true
                }   else {
                    self.btnDone.isHidden = false
                }
            } else if openType == .comeFrromCustomization {
                self.btnCancel.isHidden = (viewModel.arrSubCollectionCategory.count == 0)
                self.btnSave.isHidden = (viewModel.arrSubCollectionCategory.count == 0)
            }
            self.tbvCategory.reloadData()
            self.tbvCategory.endRefreshing()
        }
    }
    
    // --------------------------------------------
    
    func registerTableView() {
        self.apiCalling()
        self.tbvCategory.delegate = self
        self.tbvCategory.dataSource = self
        self.tbvCategory.register(MyAccountCell.nib, forCellReuseIdentifier: MyAccountCell.reuseIdentifier)
        let nib = UINib(nibName: "CustomizationItemCell", bundle: nil)
        self.tbvCategory.register(nib , forCellReuseIdentifier: "CustomizationItemCell")
        self.tbvCategory.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerTitle.font(font: .regular, size: .size16)
        self.headerTitle.text = titleText
        
        self.btnDone.font(font: .semibold, size: .size16)
        self.btnCancel.font(font: .semibold, size: .size16)
        self.btnSave.font(font: .semibold, size: .size16)
        
        self.btnCancel.isHidden = true
        self.btnSave.isHidden = true
        self.btnDone.isHidden = true
        self.setLabels()
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.btnDone.title(title: Labels.done)
        self.btnCancel.title(title: Labels.cancel)
        self.btnSave.title(title: Labels.save)
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        didSelectSubCategories?(self.arrSelectedCategory)
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        if let filterVC = navigationController?.viewControllers.first(where: { $0 is FilterVC }) as? FilterVC {
            filterVC.filterData?.collectionCategory = self.arrSelectedCategory
            if let index = filterVC.arrFilter.firstIndex(where: {$0.title == Labels.category}) {
                filterVC.arrFilter[index].description = self.arrSelectedCategory.compactMap {$0.categoryCollectionTitle}.joined(separator: ",")
                filterVC.tbvFilter.reloadData()
            }
            self.navigationController?.popToViewController(filterVC, animated: true)
            return
        }
        
        if let filterVC = navigationController?.viewControllers.first(where: { $0 is ProductListVC }) as? ProductListVC {
            filterVC.filterData?.collectionCategory = self.arrSelectedCategory
            if let index = filterVC.arrFilter.firstIndex(where: {$0.title == Labels.category}) {
                filterVC.clvFilter.reloadData()
            }
            self.navigationController?.popToViewController(filterVC, animated: true)
            return
        }
        
        if openType == .comeFrromCustomization {
            
            var arr = [SelectedSubItemsList]()
            for category in arrSelectedCategory {
                arr.append(SelectedSubItemsList(id: category.categoryCollectionId, name: category.categoryCollectionTitle))
            }
            
            let selectedItemList = SelectedItemsList(id: categorySub?.categoriesSubId, name: categorySub?.categoriesSubTitle, selectedSubItemsList: arr)
            
            if var model = customizationModels {
                if var selectedItemsListData = model.selectedItemsList, let index = selectedItemsListData.firstIndex(where: { $0.id == categorySub?.categoriesSubId }) {
                    selectedItemsListData[index] = selectedItemList
                    model.selectedItemsList = selectedItemsListData
                } else {
                    model.selectedItemsList?.append(selectedItemList)
                }
                customizationModels = model
            } else {
                customizationModels = CustomizationModels(title: categoryMain?.categoriesMainTitle,type: CustomizationType.categories.title, id: categoryMain?.categoriesMainId, selectedItemsList: [selectedItemList])
            }
            
            if let selectedIndex = appDelegate.arrCustomization.firstIndex(where: { $0.id == categoryMain?.categoriesMainId }), let data = customizationModels {
                appDelegate.arrCustomization[selectedIndex] = data
                appDelegate.isCustomizationChanges = true
            } else if let data = customizationModels {
                appDelegate.arrCustomization.append(data)
                appDelegate.isCustomizationChanges = true
            }
            
            self.completion?(categoryMain, categorySub, categoryCollection)
            self.coordinator?.popToSellVC(CustomizationVC.self, animated: true)
        }
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.coordinator?.popToSellVC(CustomizationVC.self, animated: true)
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        var arr = [SelectedSubItemsList]()
        for category in arrSelectedCategory {
            arr.append(SelectedSubItemsList(id: category.categoryCollectionId, name: category.categoryCollectionTitle))
        }
        
        let selectedItemList = SelectedItemsList(id: categorySub?.categoriesSubId, name: categorySub?.categoriesSubTitle, selectedSubItemsList: arr)
        
        if var model = customizationModels {
            if var selectedItemsListData = model.selectedItemsList, let index = selectedItemsListData.firstIndex(where: { $0.id == categorySub?.categoriesSubId }) {
                selectedItemsListData[index] = selectedItemList
                model.selectedItemsList = selectedItemsListData
            } else {
                model.selectedItemsList?.append(selectedItemList)
            }
            customizationModels = model
        } else {
            customizationModels = CustomizationModels(title: categoryMain?.categoriesMainTitle,type: CustomizationType.categories.title, id: categoryMain?.categoriesMainId, selectedItemsList: [selectedItemList])
        }
        
        if let selectedIndex = appDelegate.arrCustomization.firstIndex(where: { $0.id == categoryMain?.categoriesMainId }), let data = customizationModels {
            appDelegate.arrCustomization[selectedIndex] = data
            appDelegate.isCustomizationChanges = true
        } else if let data = customizationModels {
            appDelegate.arrCustomization.append(data)
            appDelegate.isCustomizationChanges = true
        }
        
        self.completion?(categoryMain, categorySub, categoryCollection)
        self.coordinator?.popToSellVC(CustomizationVC.self, animated: true)
    }
}

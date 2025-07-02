//
//  SearchProductVC.swift
//  Goodz
//
//  Created by Akruti on 31/01/24.
//

import UIKit
import IQKeyboardManagerSwift
class SearchProductVC: BaseVC, UITextFieldDelegate {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var clvProductList: UICollectionView!
    @IBOutlet weak var clvFilter: UICollectionView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgCross: UIImageView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrFilter: [CategoryData] = []
    var viewModel : ProductListVM = ProductListVM()
    lazy var titleText: String = ""
    var page : Int = 1
    var filterData : ProductListParameter?  = kProductListParameter
    var completionFilter : ((ProductListParameter) -> Void)?
    var completionClear : ((Bool) -> Void)?
    var arrSort : [SortModel] = []
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.setProductListAPI()
        self.arrFilterTypes()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        
        self.viewModel.fetchFilter(pageNo: self.page, data: filterData) { isDone in
            if !isDone {
                self.setNoData(scrollView: self.clvProductList, noDataType: .productEmptyData)
                self.clvProductList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            self.btnSort.isHidden = self.viewModel.arrProducts.count == 0
            self.lblItemCount.isHidden = self.btnSort.isHidden
            
            if  self.viewModel.totalRecords > 1 {
                self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.results.capitalizeFirstLetter()
            } else {
                self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.result.capitalizeFirstLetter()
            }
            
            self.clvProductList.reloadData()
            self.clvProductList.endRefreshing()
            
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.collectionRegister()
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.txtSearch.text = self.filterData?.search ?? ""
        self.txtSearch.setAutocapitalization(.words)
        self.txtSearch.returnKeyType = .done
        self.lblItemCount.font(font: .medium, size: .size14)
        self.btnSort.font(font: .medium, size: .size12)
        self.imgBack.addTapGesture {
            self.completionClear?(false)
            self.coordinator?.popVC()
        }
        self.txtSearch.delegate = self
       // self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.btnSort.isHidden = true
        self.lblItemCount.isHidden = true
        self.txtSearch.addTapGesture {
            self.completionClear?(false)
            self.coordinator?.popVC()
        }
        self.imgCross.addTapGesture {
            self.completionClear?(true)
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    func setProductListAPI() {
        self.arrSort = [
            SortModel(sortTitle: "Sort by: High to low", sortId: "2"),
            SortModel(sortTitle: "Sort by: Low to high", sortId: "3"),
            SortModel(sortTitle: "Sort by: Recently added", sortId: "1")
//            SortModel(sortTitle: "Sort by: Relevant", sortId: "")
        ]
//        GlobalRepo.shared.sortListAPI(.productList) { status, data, error in
//            if status, let storeList = data {
//                self.arrSort = storeList
                var data = self.filterData
                data?.sortId = self.arrSort.last?.sortId ?? ""
                self.filterData = data
                self.btnSort.setTitle(self.arrSort.last?.sortTitle ?? "", for: .normal)
                self.apiCalling()
//            }
//        }
    }
    
    // --------------------------------------------
    
    func arrFilterTypes() {
        self.arrFilter = [
            CategoryData(icon: .icFilter, title: Labels.filter, isSelected: true),
            CategoryData(icon: nil, title: Labels.category, isSelected: (self.filterData?.collectionCategory?.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.brands, isSelected: (self.filterData?.brand.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.condition, isSelected: (self.filterData?.condition.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.price, isSelected: (self.filterData?.priceMin.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.color, isSelected: (self.filterData?.color.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.material, isSelected: (self.filterData?.material.isEmpty ?? true) ? false : true),
            CategoryData(icon: nil, title: Labels.dimensions, isSelected: (self.filterData?.dimensionsWidth.isEmpty ?? true) ? false : true)
        ]
        self.clvFilter.reloadData()
    }
    
    // --------------------------------------------
    
    func collectionRegister() {
        
        self.clvFilter.delegate = self
        self.clvFilter.dataSource = self
        self.clvFilter.register(CategoryViewCell.nib, forCellWithReuseIdentifier: CategoryViewCell.reuseIdentifier)
        
        self.clvProductList.delegate = self
        self.clvProductList.dataSource = self
        self.clvProductList.register(MyProductCell.nib, forCellWithReuseIdentifier: MyProductCell.reuseIdentifier)
        self.clvProductList.addRefreshControl(target: self, action: #selector(refreshData))
        
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        self.page = 1
//        var data = self.filterData
//        data?.search = self.txtSearch.text ?? ""
//        self.filterData = data
//        self.apiCalling()
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.page = 1
//        var data = self.filterData
//        data?.search = self.txtSearch.text ?? ""
//        self.filterData = data
//        self.apiCalling()
//        self.view.endEditing(true)
//        return true
//    }
//    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionSort(_ sender: Any) {
        self.coordinator?.presentSort(data: self.arrSort, completion: { data in
            self.btnSort.setTitle(data.sortTitle, for: .normal)
            var sort = self.filterData
            sort?.sortId = data.sortId ?? ""
            self.filterData = sort
            self.apiCalling()
        })
    }
    
    // --------------------------------------------
    
    @IBAction func actionCart(_ sender: Any) {
        if UserDefaults.isGuestUser {
            appDelegate.setLogin()
        } else {
            self.coordinator?.navigateToCart()
        }
    }
    
    // --------------------------------------------
    
}

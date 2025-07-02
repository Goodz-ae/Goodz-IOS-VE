//
//  ProductListVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

class ProductListVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var clvProductList: UICollectionView!
    @IBOutlet weak var clvFilter: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var ivTitle: UIImageView!
    @IBOutlet weak var btnSort: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var arrFilter: [CategoryData] = []
    var viewModel : ProductListVM = ProductListVM()
    lazy var titleText: String = ""
    var page : Int = 1
    var filterData : ProductListParameter?  =  kProductListParameter
    var completionFilter : ((ProductListParameter) -> Void)?
    var arrSort : [SortModel] = []
    var islatest : Bool = false
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrFilterTypes()
        if islatest == true {
            self.clvProductList.reloadData()
            return
        }
        self.setProductListAPI()
       
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchFilter(pageNo: self.page, data: filterData) { isDone in
            if !isDone {
                self.setNoData(scrollView: self.clvProductList, noDataType: .productEmptyData)
                self.clvProductList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            } else {
                if self.viewModel.arrProducts.count == 0 {
                    self.setNoData(scrollView: self.clvProductList, noDataType: .productEmptyData)
                    self.clvProductList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
                }
                
                if  self.viewModel.totalRecords > 1 {
                    self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.results.capitalizeFirstLetter()
                } else {
                    self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.result.capitalizeFirstLetter()
                }
                
                self.clvProductList.reloadData()
            }
            
            self.btnSort.isHidden = self.viewModel.arrProducts.count == 0
            self.lblItemCount.isHidden = self.btnSort.isHidden
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
        self.headerTitle.font(font: .regular, size: .size16)
        self.headerTitle.text = titleText
        self.lblItemCount.font(font: .medium, size: .size14)
        self.btnSort.font(font: .medium, size: .size12)
        self.btnSort.isHidden = true
        self.lblItemCount.isHidden = true
        self.setLabels()
    }
    
    // --------------------------------------------
    
    func setLabels() {
        if  self.viewModel.totalRecords > 1 {
            self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.results.capitalizeFirstLetter()
        } else {
            self.lblItemCount.text = self.viewModel.totalRecords.description + " " + Labels.result.capitalizeFirstLetter()
        }
        
        if self.titleText == "Goodz Deals" || self.titleText == Labels.goodzDeals {
            self.headerTitle.color(color: .themeGoodz)
            self.ivTitle.isHidden = false
        } else {
            self.headerTitle.color(color: .themeBlack)
            self.ivTitle.isHidden = !(titleText == Labels.goodzDeals)
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
               // self.arrSort = storeList
                var data = self.filterData
                data?.sortId = self.arrSort.last?.sortId ?? ""
                self.filterData = data
        self.page = 1
        self.clvProductList.scrollsToTop(animated: false)
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
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionSort(_ sender: Any) {
        self.coordinator?.presentSort(data: self.arrSort, completion: { data in
            print(data)
            var sort = self.filterData
            sort?.sortId = data.sortId ?? ""
            self.filterData = sort
            self.apiCalling()
            self.btnSort.setTitle(data.sortTitle, for: .normal)
        })
    }
    
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}

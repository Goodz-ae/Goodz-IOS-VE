//
//  FilterVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

class FilterVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tbvFilter: UITableView!
    @IBOutlet weak var btnClear: UIButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var arrFilter: [FilterDataModel] = []
    var filterData : ProductListParameter? = kProductListParameter
    var completionFilter : ((ProductListParameter) -> Void)?
    
    // --------------------------------------------
    // MARK: - Life cycle methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.applyStyle()
        self.registerTableView()
        
    }
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    func setUp() {
        let d1 = (self.filterData?.dimensionsHeight ?? "").isEmpty ? "" : ("H" + (self.filterData?.dimensionsHeight ?? "") + "; ")
        let d2 = (self.filterData?.dimensionsLength ?? "").isEmpty ? "" : ("L" + (self.filterData?.dimensionsLength ?? "") + "; ")
        let d3 = (self.filterData?.dimensionsWidth ?? "").isEmpty ? "" : ("W" + (self.filterData?.dimensionsWidth ?? "") + "; ")
        let d4 = (self.filterData?.dimensionsWeight ?? "").isEmpty ? "" : ((self.filterData?.dimensionsWeight ?? "") + "kg")
        
        let demension3 = d1 + d2 + d3 + d4
        
        let p1 = (self.filterData?.priceMax ?? "").isEmpty ? "" : ((self.filterData?.priceMax ?? "") + "-")
//        let cat1 = (self.filterData?.mainCategory?.categoriesMainTitle ?? "") + "/"
//        let cat2 = (self.filterData?.subCategory?.categoriesSubId ?? "") + "/"
//        let cat3 = self.filterData?.collectionCategory?.compactMap { $0.categoryCollectionTitle}.joined(separator: ",") ?? ""
//        let desCat =  cat1 + cat2 + cat3
        let desCat = self.filterData?.collectionCategory?.compactMap { $0.categoryCollectionTitle}.joined(separator: ",")
        let desBrand = self.filterData?.brand.compactMap { $0.brandTitle }.joined(separator: ", ")
        let desCondition = self.filterData?.condition.compactMap { $0.conditionTitle }.joined(separator: ", ")
        let desPrice = p1 + (self.filterData?.priceMin ?? "")
        let desColor = self.filterData?.color.compactMap { $0.title }.joined(separator: ", ")
        let desMaterial = self.filterData?.material.compactMap { $0.title }.joined(separator: ", ")
        self.arrFilter = [
            FilterDataModel(title: Labels.category, description: desCat),
            FilterDataModel(title: Labels.brands, description: desBrand),
            FilterDataModel(title: Labels.condition, description: desCondition),
            FilterDataModel(title: Labels.price, description: desPrice),
            FilterDataModel(title: Labels.color, description: desColor),
            FilterDataModel(title: Labels.material, description: desMaterial),
            FilterDataModel(title: Labels.dimensions, description: demension3)]
        DispatchQueue.main.async {
            self.tbvFilter.reloadData()
        }
    }
    
    // --------------------------------------------
    
    func registerTableView() {
        self.tbvFilter.delegate = self
        self.tbvFilter.dataSource = self
        self.tbvFilter.register(MyAccountCell.nib, forCellReuseIdentifier: MyAccountCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerTitle.font(font: .regular, size: .size16)
        self.headerTitle.text = Labels.filter
        self.btnClear.font(font: .semibold, size: .size16)
        self.btnApply.font(font: .semibold, size: .size16)
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func actionCross(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionApply(_ sender: Any) {
        
        self.completionFilter?(self.filterData ?? kProductListParameter)
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
    @IBAction func actionClear(_ sender: Any) {
        DispatchQueue.main.async {
            var data = self.filterData
            data?.collectionCategory = []
            data?.subCategory = CategorySubModel(categoriesSubTitle: "", categoriesSubId: "", categoriesSubImage: "")
            data?.mainCategory = CategoryMainModel(categoriesMainTitle: "", categoriesMainId: "", categoriesMainImage: "", isCustomizationSelected: "")
            data?.brand = []
            data?.material = []
            data?.condition = []
            data?.priceMax = ""
            data?.priceMin = ""
            data?.color = []
            data?.dimensionsWidth = ""
            data?.dimensionsWeight = ""
            data?.dimensionsHeight = ""
            data?.dimensionsLength = ""
            self.filterData = data
            self.arrFilter = [
                FilterDataModel(title: Labels.category, description: nil),
                FilterDataModel(title: Labels.brands, description: nil),
                FilterDataModel(title: Labels.condition, description: nil),
                FilterDataModel(title: Labels.price, description: nil),
                FilterDataModel(title: Labels.color, description: nil),
                FilterDataModel(title: Labels.material, description: nil),
                FilterDataModel(title: Labels.dimensions, description: "H; L; W, kg")]
            self.tbvFilter.reloadData()
            self.completionFilter?(self.filterData ?? kProductListParameter)
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
}

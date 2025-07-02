//
//  SuperCategoryVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 27/12/23.
//

import UIKit

class SuperCategoryVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tbvCategory: UITableView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var titleText: String = ""
    var viewModel : SuperCategoryVM = SuperCategoryVM(arrMainCategory: [CategoryMainModel]())
    var page  : Int = 1
    var opeonType : OpenTypeCategory = .other
    var selectedData: [CategoryCollectionModel] = []
    var completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?
    
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.registerTableView()
    }
    
    // --------------------------------------------
    
    func registerTableView() {
        self.apiCalling()
        self.tbvCategory.delegate = self
        self.tbvCategory.dataSource = self
        self.tbvCategory.register(MyAccountCell.nib, forCellReuseIdentifier: MyAccountCell.reuseIdentifier)
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.fetchData(pageNo: self.page) { isDone in
            if isDone {
                if self.opeonType == .other {
                    self.viewModel.arrMainCategory.insert(CategoryMainModel(categoriesMainTitle: "All", categoriesMainId: "-1", categoriesMainImage: "", isCustomizationSelected: ""), at: 0)
                }
                self.tbvCategory.reloadData()
                self.tbvCategory.endRefreshing()
            }
        }
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerTitle.font(font: .regular, size: .size16)
        self.headerTitle.text = titleText
    }
    
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}

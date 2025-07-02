//
//  SubCategoryVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 13/12/23.
//

import UIKit

class SubCategoryVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tbvSubcategory: UITableView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSeperator: UIView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    lazy var titleText: String = ""
    var viewModel : SubCategoryVM = SubCategoryVM(arrSubCategory: [CategorySubModel]())
    var page : Int = 1
    var categoryMain : CategoryMainModel?
    var categorySubId : CategorySubModel?
    var opeonType : OpenTypeCategory = .other
    var selectedData: [CategoryCollectionModel] = []
    var completion: ((CategoryMainModel?, CategorySubModel?, CategoryCollectionModel?) -> ())?
    var customizationModel: CustomizationModels?
    var workItem : DispatchWorkItem?
    var strSearch : String = ""
    
    // --------------------------------------------
    // MARK: - Initial methods
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
    
    func apiCalling() {
        self.viewModel.fetchData(pageNo: self.page, id: self.categoryMain?.categoriesMainId ?? "", searchText: strSearch) { isDone in
            if !isDone {
                self.setNoData(scrollView: self.tbvSubcategory, noDataType: .productEmptyData)
                self.tbvSubcategory.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
            }
            self.tbvSubcategory.reloadData()
            self.tbvSubcategory.endRefreshing()
        }
    }
    
    // --------------------------------------------
    
    func registerTableView() {
        self.apiCalling()
        self.tbvSubcategory.delegate = self
        self.tbvSubcategory.dataSource = self
        self.tbvSubcategory.register(MyAccountCell.nib, forCellReuseIdentifier: MyAccountCell.reuseIdentifier)
        self.tbvSubcategory.addRefreshControl(target: self, action: #selector(refreshData))
    }
    
    // --------------------------------------------
    
    @objc func refreshData() {
        self.page = 1
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    private func applyStyle() {
        self.headerTitle.font(font: .regular, size: .size16)
        self.headerTitle.text = titleText
        
        self.txtSearch.delegate = self
        self.txtSearch.placeholder = Labels.search + " " + titleText
        
        self.vwSearch.superview?.isHidden = opeonType != .comeFrromCustomization
    }
    
    // --------------------------------------------
    
    @IBAction func actionBack(_ sender: Any) {
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}

extension SubCategoryVC: UITextFieldDelegate {
    
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
                strongself.apiCalling()
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem!)
        }
        
        return true
    }
}

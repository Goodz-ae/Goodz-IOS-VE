//
//  ColorsVC.swift
//  Goodz
//
//  Created by Priyanka Poojara on 26/12/23.
//

import UIKit

class ColorsVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var tbvColors: UITableView!
    @IBOutlet weak var headerView: AppStatusView!
    
    @IBOutlet weak var btnDone: UIButton!
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var viewModel : ColorsVM = ColorsVM()
    var selectedIndex : Int = -1
    var arrSelect : [ColorModel] = []
    var completion : (([ColorModel]?) -> Void) = { _ in }
    var isColor : Bool = false
    var selectedID : String = ""
    var isMultipleSelection : Bool = false
    var selectALL : Bool = false
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.apiCaling()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    private func setUp() {
        self.headerView.lblTitle.text = self.isColor ? Labels.color : Labels.material
        self.btnDone.setTitle(Labels.done, for: .normal)
        self.headerView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
        self.registerTableView()
    }
    
    // --------------------------------------------
    
    func apiCaling() {
        if self.isColor {
            self.viewModel.fetchColors() { isDone in
                if isDone {
                    if !self.isMultipleSelection {
                        self.viewModel.arrColor = Array(self.viewModel.arrColor.dropFirst())
                        if let index = self.viewModel.arrColor.firstIndex(where: {$0.id == self.selectedID}) {
                            self.selectedIndex = index
                        }
                    }
                    self.tbvColors.reloadData()
                }
            }
        } else {
            self.viewModel.fetchMaterials { isDone in
                if isDone {
                    if !self.isMultipleSelection {
                        self.viewModel.arrMaterial = Array(self.viewModel.arrMaterial.dropFirst())
                        if let index = self.viewModel.arrMaterial.firstIndex(where: {$0.id == self.selectedID}) {
                            self.selectedIndex = index
                        }
                    }
                    self.tbvColors.reloadData()
                }
            }
        }
    }
    // --------------------------------------------
    
    func registerTableView() {
        self.tbvColors.allowsMultipleSelection = true
        self.tbvColors.delegate = self
        self.tbvColors.dataSource = self
        self.tbvColors.registerReusableCell(SingleSelectionCell.self)
    }
    
    // --------------------------------------------
    
    @IBAction func actionDone(_ sender: Any) {
        if self.isMultipleSelection {
            if self.isColor {
//                if self.arrSelect.count < 1 {
//                    notifier.showToast(message: Labels.selectColor)
//                    return
//                }
                if self.selectALL {
                    self.arrSelect = Array(self.arrSelect.dropFirst())
                    
                }
                self.completion(self.arrSelect)
                
               
            } else {
//                if self.arrSelect.count < 1 {
//                    notifier.showToast(message: Labels.selectmaterial)
//                    return 
//                }
                if self.selectALL {
                    self.arrSelect = Array(self.arrSelect.dropFirst())
                    
                }
                self.completion(self.arrSelect)
            }
        
        } else {
            if self.selectedIndex > -1 {
                if self.isColor {
                    self.completion([self.viewModel.setColor(row: selectedIndex)])
                } else {
                    self.completion([self.viewModel.setMaterial(row: selectedIndex)])
                }
            } else {
                self.completion([])
            }
        }
        self.coordinator?.popVC()
    }
    
    // --------------------------------------------
    
}

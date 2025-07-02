//
//  SortVC.swift
//  Goodz
//
//  Created by vtadmin on 13/12/23.
//

import UIKit

class SortVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var consraintTblHeight: NSLayoutConstraint!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var sortType : SortType = .productList
    var selectedSort: ((SortModel) -> Void)?
    var arrSort : [SortModel] = [SortModel]()
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUi()
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    
    func setUi() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.tblView.register(UINib(nibName: "SortCell", bundle: nil), forCellReuseIdentifier: "SortCell")
        
        self.tblView.reloadData()
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.btnClose.round()
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tblView = object as? UITableView {
            if tblView == self.tblView {
                tblView.layer.removeAllAnimations()
                self.consraintTblHeight.constant = tblView.contentSize.height
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    // MARK: - Action methods
    // --------------------------------------------
    
    @IBAction func actionBtnClose(_ sender: UIButton) {
        if let data = self.arrSort.first {
            selectedSort?(data)
        }
        self.dismiss()
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITableView Delegate and DataSource
// --------------------------------------------

extension SortVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSort.count
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
        cell.lblTitle.text = self.arrSort[indexPath.row].sortTitle
        cell.vwMain.round()
        cell.selectionStyle = .none
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSort?(self.arrSort[indexPath.row])
        self.dismiss()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // --------------------------------------------
    
}

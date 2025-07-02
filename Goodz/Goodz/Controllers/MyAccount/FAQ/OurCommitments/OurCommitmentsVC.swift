//
//  OurCommitmentsVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit

class OurCommitmentsVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOurDedication: UILabel!
    @IBOutlet weak var imgGoodz: UIImageView!
    @IBOutlet weak var lblMesaage: UILabel!
    @IBOutlet weak var btnCommitments: UIButton!
    @IBOutlet weak var btnTimer: UIButton!
    @IBOutlet weak var btnSecurity: UIButton!
    @IBOutlet weak var lblMessageDes: UILabel!
    @IBOutlet weak var lblOurLatestNews: UILabel!
    @IBOutlet weak var colItems: UICollectionView!
    @IBOutlet weak var lblGoodz: UILabel!
    @IBOutlet weak var lblGoodzDes: UILabel!
    @IBOutlet weak var tblNews: UITableView!
    @IBOutlet weak var constHeightOfTable: NSLayoutConstraint!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : OurCommitmentsVM = OurCommitmentsVM()
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblNews.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        super.viewWillAppear(animated)
        print(self)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblNews.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblTitle.font(font: .semibold, size: .size14)
        self.lblTitle.color(color: .themeBlack)
        self.lblOurDedication.font(font: .regular, size: .size14)
        self.lblOurDedication.color(color: .themeBlack)
        
        self.lblMesaage.font(font: .semibold, size: .size14)
        self.lblMesaage.color(color: .themeBlack)
        self.lblMessageDes.font(font: .regular, size: .size14)
        self.lblMessageDes.color(color: .themeBlack)
        
        self.lblOurLatestNews.font(font: .semibold, size: .size14)
        self.lblOurLatestNews.color(color: .themeBlack)
        
        self.lblGoodz.font(font: .semibold, size: .size14)
        self.lblGoodz.color(color: .themeBlack)
        self.lblGoodzDes.font(font: .regular, size: .size14)
        self.lblGoodzDes.color(color: .themeBlack)
        
        let nib = UINib(nibName: "CommitmentsCell", bundle: nil)
        self.tblNews.register(nib , forCellReuseIdentifier: "CommitmentsCell")
        self.viewModel.setData()
        self.tblNews.delegate = self
        self.tblNews.dataSource = self
        self.tblNews.reloadData()
        
        let nibNews = UINib(nibName: "NewsCell", bundle: nil)
        self.colItems.register(nibNews, forCellWithReuseIdentifier: "NewsCell")
        self.colItems.delegate = self
        self.colItems.dataSource = self
        self.colItems.reloadData()
        
    }
    
    // --------------------------------------------
    
    private func setData() {
        self.lblTitle.text = Labels.committedToASustainable
        self.lblOurDedication.text = Labels.ourDedicationToThisCause
        self.imgGoodz.image = .goodzbg
        self.lblMesaage.text = Labels.aMessageFromGoodz
        self.lblMessageDes.text = Labels.thatsWhyWeHaveTaken
        self.lblOurLatestNews.text = Labels.ourLatestNews
        self.lblGoodz.text = Labels.goodz
        self.lblGoodzDes.text = Labels.weActivelySeekInnoVATive
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj1 = object as? UITableView,
           obj1 == self.tblNews && keyPath == "contentSize" {
            self.constHeightOfTable.constant = self.tblNews.contentSize.height
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.ourCommitments
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        self.setData()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}

// --------------------------------------------
// MARK: - UItableView Delegate and DataSource
// --------------------------------------------

extension OurCommitmentsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfCommitment()
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitmentsCell", for: indexPath) as! CommitmentsCell
        cell.setData(data: self.viewModel.setRowDataOfCommitment(row: indexPath.row))
        return cell
    }
    
}

// -------------------------------------------------
// MARK: - UICollectionView Delegate and DataSource
// -------------------------------------------------

extension OurCommitmentsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! NewsCell
        return cell
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  0.4402035623 * screenWidth, height: self.colItems.frame.height)
    }
}

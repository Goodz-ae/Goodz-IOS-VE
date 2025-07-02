import UIKit

protocol GetSelectedCountryImgandCodeDelegete {
    func getSelectedCountryDetail(countryCode: CountryListModel)
}

class SelectCountryVC: BaseVC {
    
    // --------------------------------------------
    // MARK: Outlets
    // --------------------------------------------
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCross: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mainView: UIView!
    @IBOutlet var lblNoData: UILabel!
    
    // --------------------------------------------
    // MARK: - Variables
    // --------------------------------------------
    
    var onCountrySelected: ((String) -> Void)?
    private var viewModel : SelectCountryVM = SelectCountryVM()
    var objgetSelectedCountryImgandCodeDelegete: GetSelectedCountryImgandCodeDelegete?
    
    // --------------------------------------------
    // MARK: - View controller life cycle.
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCrossClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
  
}

extension SelectCountryVC {
    
    func configUI() {
       
        DispatchQueue.main.async {
            self.viewModel.fetchCoutryList { isDone in
                if isDone {
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tblView.reloadData()
                }
            }
        }
        searchBar.tintColor = UIColor.themeBlack
        self.tblView.register(UINib(nibName: "CountyDetailCell", bundle: nil), forCellReuseIdentifier: "CountyDetailCell")
       
        self.tblView.keyboardDismissMode = .onDrag
        self.tblView.tableFooterView = UIView()
        self.searchBar.delegate = self
        self.manageUI()
        self.lblNoData.isHidden = true
    }
    
    // --------------------------------------------
    
    func manageUI() {
        self.btnCross.cornerRadius(cornerRadius: self.btnCross.frame.size.height / 2)
        self.mainView.cornerRadius(cornerRadius: 4.0)
        self.labelManager()
    }
    
    // --------------------------------------------
    
    func labelManager() {
        self.lblTitle.text = Labels.selectCountry
        self.lblTitle.font(font: .medium, size: .size18)
        self.lblTitle.color(color: .themeGreen)
    }

    // --------------------------------------------
    
    func checkNoData() {
        DispatchQueue.main.async {
            self.lblNoData.text = Labels.noDataFound
            self.lblNoData.isHidden = ((self.viewModel.arrCoutryList?.count ?? 0) > 0)
            self.tblView.reloadData()
        }
    }
}

// --------------------------------------------
// MARK: Table view delegate and datasource methods.
// --------------------------------------------

extension SelectCountryVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.setNumberOfCountry() 
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountyDetailCell", for: indexPath) as! CountyDetailCell
        cell.setData(data: self.viewModel.setCoutryData(row: indexPath.row))
        return cell
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // --------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objgetSelectedCountryImgandCodeDelegete?.getSelectedCountryDetail(countryCode: self.viewModel.setCoutryData(row: indexPath.row))
        onCountrySelected?((self.viewModel.setCoutryData(row: indexPath.row).countryCode) ?? "971")
        kLengthMobile = self.viewModel.setCoutryData(row: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: Search bar delegate method define.
// --------------------------------------------

extension SelectCountryVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.viewModel.fetchCoutryList { isDone in
                if isDone {
                    self.viewModel.arrCoutryList = self.viewModel.arrAllCountryCode
                    self.checkNoData()
                }
            }
        } else {
            self.viewModel.arrCoutryList = self.viewModel.arrAllCountryCode
            self.viewModel.arrCoutryList = self.viewModel.arrCoutryList?.filter({ (data: CountryListModel ) -> Bool in
                return data.countryName?.range(of: searchText, options: .caseInsensitive) != nil
            })
            self.checkNoData()
        }
        
       
    }
}

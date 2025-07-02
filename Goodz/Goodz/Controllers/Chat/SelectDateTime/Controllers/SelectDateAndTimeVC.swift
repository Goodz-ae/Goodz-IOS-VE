//
//  SelectDateAndTimeVC.swift
//  Goodz
//
//  Created by vtadmin on 21/12/23.
//

import UIKit
import FSCalendar

class SelectDateAndTimeVC: BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var viewChooesDate: UIView!
    @IBOutlet weak var lblChooseDateDescription: UILabel!
    
    @IBOutlet weak var viewCal: UIView!
    @IBOutlet weak var viewCalendar: FSCalendar!
    
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var constraintTblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNext: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var chatId: String = ""
    var toID : String = ""
    lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var selectedIndex : Int = -1
    var selectedDate : String = ""
    var viewModel : SelectDateAndTimeVM = SelectDateAndTimeVM()
    var isSelectPickupAddress : String = "0"
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUi()
        self.getTimeSlotAPI()
        self.tblview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tblview.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    
    deinit {
        self.tblview.removeObserver(self, forKeyPath: "contentSize")
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.selectDateAndTime
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let tbl = object as? UICollectionView {
            if tbl == self.tblview {
                tbl.layer.removeAllAnimations()
                self.constraintTblHeight.constant = self.tblview.contentSize.height
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    
    func getTimeSlotAPI() {
        self.viewModel.getTimeSlots { status in
            self.tblview.reloadData()
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func nextTapped(_ sender:UIButton) {
        let moveTo = getNextMonth(date: viewCalendar.currentPage)
        self.viewCalendar.setCurrentPage(moveTo, animated: true)
    }
    
    // --------------------------------------------
    
    @IBAction  func previousTapped(_ sender:UIButton) {
        let moveTo = getPreviousMonth(date: viewCalendar.currentPage)
        self.viewCalendar.setCurrentPage(moveTo, animated: true)
    }
    
    // --------------------------------------------
    
    @IBAction func actionBtnNext(_ sender: UIButton) {
        if self.selectedDate.isEmpty {
            notifier.showToast(message: Labels.pleaseSelectedPickupDate)
        } else if self.selectedIndex < 0 {
            notifier.showToast(message: Labels.pleaseSelectedPickupTimeSlot)
        } else {
            
            self.viewModel.setDateAndTime(chatId: self.chatId, date: self.selectedDate, timeSlotId: self.viewModel.setTimeSlots(row: selectedIndex).timeSlotID ?? "", toId: self.toID, isSelectPickupAddress: self.isSelectPickupAddress) { status in
                if status {
                    if self.isSelectPickupAddress == "1" {
                        self.coordinator?.popVC()
                    } else {
                        self.coordinator?.navigateToChatAddressVC(chatId: self.chatId, toId: self.toID)
                        
                    }
                }
            }
        }
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - Custom methods
// --------------------------------------------

extension SelectDateAndTimeVC {
    
    func setUi() {
        self.setupCalendar()
        
        self.lblChooseDateDescription.font(font: .medium, size: .size14)
        self.viewChooesDate.cornerRadius(cornerRadius: 4.0)
        self.viewChooesDate.border(borderWidth: 1.0, borderColor: .themeGreen)
        
        let nib = UINib(nibName: "TimeCell", bundle: nil)
        self.tblview.register(nib, forCellReuseIdentifier: "TimeCell")
        
        self.tblview.delegate = self
        self.tblview.dataSource = self
        
    }
    
    // --------------------------------------------
    
    func setupCalendar() {
        self.viewCalendar.delegate = self
        self.viewCalendar.dataSource = self
        self.viewCalendar.placeholderType = .none
        self.viewCalendar.appearance.weekdayFont = UIFont(name: FontName.regular.rawValue, size: FUNCTION().getFontSize(size: FontSize.size14.rawValue))
        self.viewCalendar.appearance.headerTitleFont = UIFont(name: FontName.regular.rawValue, size: FUNCTION().getFontSize(size: FontSize.size14.rawValue))
        self.viewCalendar.appearance.titleFont = UIFont(name: FontName.regular.rawValue, size: FUNCTION().getFontSize(size: FontSize.size14.rawValue))
        
        self.viewCalendar.appearance.weekdayTextColor = .themeBlack
        self.viewCalendar.appearance.headerTitleColor = .themeBlack
        self.viewCalendar.appearance.eventDefaultColor = .themeGreen
        self.viewCalendar.appearance.eventSelectionColor = .themeGreen
        self.viewCalendar.appearance.selectionColor = .themeGreen
        self.viewCalendar.appearance.todaySelectionColor = .themeGreen
        self.viewCalendar.appearance.headerDateFormat = "MMMM yyyy"
        self.viewCalendar.appearance.borderRadius = 0.4
        self.viewCalendar.appearance.headerMinimumDissolvedAlpha = 0
        self.viewCalendar.headerHeight = 45
        self.viewCalendar.appearance.todayColor = UIColor.clear
        
        self.viewCalendar.appearance.titleTodayColor = .themeGray
        
        if IS_IPAD {
            self.viewCalendar.appearance.eventOffset = CGPoint(x: 0, y: -16)
        } else {
            self.viewCalendar.appearance.eventOffset = CGPoint(x: 0, y: -8)
        }
        self.viewCalendar.firstWeekday = 2
    }
}

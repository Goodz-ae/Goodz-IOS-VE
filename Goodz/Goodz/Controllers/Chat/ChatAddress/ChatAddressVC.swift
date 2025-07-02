//
//  ChatAddressVC.swift
//  Goodz
//
//  Created by Akruti on 22/02/24.
//

import Foundation
import UIKit

class ChatAddressVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAdddress: UILabel!
    @IBOutlet weak var lblChange: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var vwSchedule: UIView!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var vwDateTime: UIView!
    @IBOutlet weak var btnNext: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var chatId : String = ""
    var toID : String = ""
    private var viewModel : ChatAddressVM = ChatAddressVM()
    var addressId : String = ""
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.apiCalling()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("ChatAddressVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblSchedule.font(font: .medium, size: .size16)
        self.lblSchedule.color(color: .themeBlack)
        
        self.lblTime.font(font: .semibold, size: .size16)
        self.lblTime.color(color: .themeBlack)
        
        self.lblDate.font(font: .semibold, size: .size16)
        self.lblDate.color(color: .themeBlack)
        
        self.lblAdddress.font(font: .semibold, size: .size16)
        self.lblAdddress.color(color: .themeBlack)
        
        self.lblChange.font(font: .semibold, size: .size16)
        self.lblChange.color(color: .themeBlack)
        
        self.lblArea.font(font: .regular, size: .size14)
        self.lblArea.color(color: .themeGray)
        
        self.lblCity.font(font: .regular, size: .size14)
        self.lblCity.color(color: .themeGray)
        
        self.lblMobile.font(font: .regular, size: .size14)
        self.lblMobile.color(color: .themeGray)
        
        self.lblAdddress.text = Labels.address
        self.lblChange.text = Labels.change
        self.lblSchedule.text = Labels.youHaveScheduledApickUpOfYourGOODZ
    }
    
    // --------------------------------------------
    
    func setLabels() {
        self.lblAdddress.text = Labels.address
        self.lblChange.text = Labels.change
        self.btnNext.setTitle(Labels.next, for: .normal)

        self.lblChange.addTapGesture {
            self.coordinator?.navigateToSelectAddress(completion: { data in
                self.addressId = data.addressId ?? ""
                self.lblArea.text = (data.streetAddress ?? "") + (data.area ?? "")
                self.lblCity.text = (data.city ?? "")
                self.lblMobile.text = (data.countryCode ?? "") + (data.mobile ?? "")
                
            })
        }
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.selectPickUpAddress
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.setLabels()
        self.applyStyle()
        self.setTopViewAction()
    }
    
    // --------------------------------------------
    
    func apiCalling() {
        self.viewModel.getPickupAddressAPI(chatId: self.chatId, toId: self.toID) { status, data in
            if status {
                self.setData(data: data)
            }
        }
        
    }
    // --------------------------------------------
    
    func setData(data: PickUpAddressModel) {
        if let address = data.address {
            self.lblDate.text = data.pickupDate
            self.lblTime.text = data.timeSlot
            if !(address.addressID ?? "").isEmpty {
                self.addressId = address.addressID ?? ""
                self.lblArea.text = (address.streetAddress ?? "") + (address.area ?? "")
                self.lblCity.text = address.city
                self.lblMobile.text = (address.countryCode ?? "") + (address.mobile ?? "")
                
            } else {
                self.lblChange.text = Labels.add
            }
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnNextTapped(_ sender: Any) {
        self.viewModel.setPickupAddressAPI(chatId: self.chatId, toId: toID, addressId: self.addressId) { status in
            if status {
                if let chatDetailVC = self.navigationController?.viewControllers.first(where: { $0 is ChatDetailVC }) as? ChatDetailVC {
                    self.navigationController?.popToViewController(chatDetailVC, animated: true)
                    return
                }
            }
        }
    }
    
    // --------------------------------------------
    
}


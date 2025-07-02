//
//  NegotiationOffersVC.swift
//  Goodz
//
//  Created by on 10/04/25.
//

import UIKit

class NegotiationOffersVC: BaseVC {

    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var receiveLbl: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    private var viewModel : NegotiationOfferVM = NegotiationOfferVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.setTopViewAction()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        self.receiveLbl.font(font: .regular, size: .size16)
        
        self.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.negotiationOffer
        self.appTopView.backButtonClicked = {
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------

    func getNegotiationOffer(negotiationStatus: Bool) {
        self.viewModel.getNegotiationOffers(NegotiationStatus: negotiationStatus) { status in
            print("Status", status)
            self.showOKAlert(title: "", message: self.viewModel.arrNegotiation.first?.message ?? "", okAction: {})
        }
    }
    
    // --------------------------------------------
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

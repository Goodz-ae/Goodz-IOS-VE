//
//  ProSplashVC.swift
//  Goodz
//
//  Created by vtadmin on 19/12/23.
//

import UIKit

class ProSplashVC: BaseVC {

    @IBOutlet weak var lblTitle: UILabel!
    var isComeFromSignup : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.font(font: .regular, size: .size52)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.coordinator?.navigateToProBenefitList(comeFormSignup: self.isComeFromSignup)
        }
    }
}

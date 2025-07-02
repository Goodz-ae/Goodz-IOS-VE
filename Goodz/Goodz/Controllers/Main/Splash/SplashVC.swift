//
//  SplashVC.swift
//  Goodz
//
//  Created by Akruti on 29/11/23.
//

import Foundation
import UIKit
import SwiftGifOrigin

class SplashVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    @IBOutlet weak var imgSplash: UIImageView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : SplashVM = SplashVM()

    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSplash.image = UIImage.gif(name: "animated_splash")
        self.applyStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SplashVC")
        
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.viewModel.setAppBase()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            appDelegate.setRootWindow()
            
            self.viewModel.fetchCoutryList { isDone in
                if isDone {
                    kLengthMobile = self.viewModel.arrCoutryList?.first ?? (CountryListModel(id: "1", countryCode: "+971", countryName: "UAE", phoneNumberLength: "7"))
                }
            }
            NotificationCenter.default.post(name: .isFromSplash, object: nil)
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}

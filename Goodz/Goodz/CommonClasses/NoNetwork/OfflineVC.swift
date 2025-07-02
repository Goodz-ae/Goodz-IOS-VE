//
//  OfflineVC.swift
//  Goodz
//
//  Created by Akruti on 02/01/24.
//

import UIKit

class OfflineVC: UIViewController {

    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        indicator.isHidden = true
        
        NETWORK.reachability.whenReachable = { reachability in
            
            self.dismissNoNetwork()
        }
    }

    

    @IBAction func btnRefreshAction(_ sender: UIButton) {
        
        btnRefresh.isHidden = true
        
        indicator.isHidden = false
        indicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        
            self.btnRefresh.isHidden = false
            
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
            
            NoNetworkManager.isReachable { _ in
                
                self.dismissNoNetwork()
            }
        }
    }
    
    func dismissNoNetwork() {
        
        if let topVC : UIViewController = UIApplication.topViewController() {
            
            if topVC.isKind(of: OfflineVC.self) {
                
                topVC.dismiss(animated: true, completion: nil)
            }
        }
    }

}

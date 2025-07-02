//
//  TelrPaymentVC.swift
//  Goodz
//
//  Created by Akruti on 09/05/24.
//

import Foundation
import UIKit
import WebKit

class TelrPaymentVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var webVW: WKWebView!
    @IBOutlet weak var apptopView: AppStatusView!
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var boostdata : [PaymentModel] = []
    var cartData :  [AddOrderModel] = []
    var openTypeTelrPayment : TelrPaymentType = .boostItem
    var storeID = ""
    var successUrl = ""
    var failUrl = ""
    var declineUrl = ""
    var isStatus = false
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TelrPaymentVC")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        if isStatus {
//            webVW.stopLoading()
//        }
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        if self.openTypeTelrPayment == .boostItem || self.openTypeTelrPayment == .boostStore {
            if let str = self.boostdata.first?.redirectURL, !str.isEmpty {
                self.webVW.load(str)
            }
        } else if self.openTypeTelrPayment == .cart {
            print(self.cartData)
            if let str = self.cartData.first?.redirectURL, !str.isEmpty {
                self.webVW.load(str)
            }
        }
        if openTypeTelrPayment == .boostItem || openTypeTelrPayment == .boostStore {
            self.successUrl = self.boostdata.first?.successURL ?? ""
            self.failUrl = self.boostdata.first?.cancelURL ?? ""
            self.declineUrl = self.boostdata.first?.declinedURL ?? ""
        } else {
            self.successUrl = self.cartData.first?.successURL ?? ""
            self.failUrl = self.cartData.first?.cancelURL ?? ""
            self.declineUrl = self.cartData.first?.declinedURL ?? ""
        }
        self.webVW.navigationDelegate = self
    }
    
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
    }
    
    func setTopViewAction() {
        self.apptopView.textTitle = ""
        self.apptopView.backButtonClicked = { [] in
            self.webVW.load(self.failUrl)
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//                self.coordinator?.popVC()
            })
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}

extension TelrPaymentVC : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        notifier.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        notifier.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        notifier.hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request != nil {
            let strRedirectUrl = navigationAction.request.url
            let strUrl = strRedirectUrl?.description
            print("RedirectionURL: \(strUrl)")
            if strUrl!.contains("handle-payment/success") {
                
                isStatus = true
                print("Success")
                decisionHandler(WKNavigationActionPolicy.allow)
                webVW.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    if self.openTypeTelrPayment == .cart {
                        self.coordinator?.navigateToOrderCompletePopup(paymentType : self.openTypeTelrPayment,cartData: self.cartData, orderID : self.cartData.first?.orderID ?? "",storeId: self.cartData.first?.storeID ?? "", productId: "", type: .confirmation)
                    } else if self.openTypeTelrPayment == .boostItem {
                        self.coordinator?.navigateToOrderCompletePopup(paymentType : self.openTypeTelrPayment,cartData: [], data: self.boostdata ,storeId: "", productId: "", type: .boostItem)
                    } else if self.openTypeTelrPayment == .boostStore {
                        self.coordinator?.navigateToOrderCompletePopup(paymentType : self.openTypeTelrPayment,cartData: [], data: self.boostdata ,storeId: "", productId: "", type: .boostStore)
                    } else if self.openTypeTelrPayment == .bundle {
                        self.coordinator?.navigateToOrderCompletePopup(paymentType : self.openTypeTelrPayment,cartData: self.cartData,orderID : self.cartData.first?.orderID ?? "",storeId: self.storeID, productId: "", type: .confirmation)
                    } else {}
                })
                return
            } else if (strUrl!.contains("handle-payment/cancel")) || (strUrl!.contains("handle-payment/declined")){
                decisionHandler(WKNavigationActionPolicy.allow)
                isStatus = true
                webVW.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                    self.coordinator?.navigateToOrderCompletePopup(paymentType : self.openTypeTelrPayment,cartData: self.cartData, data: self.boostdata ,storeId: "", productId: "", type: .paymentFail)
                })
                print("fail")
                return
            } else {
                print("Nothing")
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
        
    }
}

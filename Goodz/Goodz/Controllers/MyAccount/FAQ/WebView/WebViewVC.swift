//
//  WebViewVC.swift
//  Goodz
//
//  Created by Akruti on 14/12/23.
//

import Foundation
import UIKit
import WebKit
class WebViewVC : BaseVC, UIScrollViewDelegate {
    
    var backendUrlString: String {
        get {
            return infoForKey("App_BackendURL") ?? ""
        }
    }
    
    func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwWeb: WKWebView!
    @IBOutlet weak var lblDes: UILabel!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    var strTitle : String = ""
    var strDescription : String = ""
    var id = Int()
    private var viewModel : FAQVM = FAQVM()
    var comeFrom : OpenWebView = .productDetails
    var productURl : String = ""
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    // --------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WebViewVC ")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        self.lblDes.isHidden = true
        self.setTopViewAction()
        if self.comeFrom == .productDetails {
            self.vwWeb.isHidden = false
            if let url = URL(string: self.productURl) {
                let requestObj = URLRequest(url: url)
                self.vwWeb.load(requestObj)
            }
            return
        } else if self.id == 33 && comeFrom == .cms {
            self.vwWeb.isHidden = false
            self.strTitle = "How It works"
            self.setTopViewAction()
            if let url = URL(string: "https://stag.goodz.ae/app_how_it_works") {
                let requestObj = URLRequest(url: url)
                self.vwWeb.load(requestObj)
            }
            return
        } else if comeFrom == .cms {
            DispatchQueue.main.async {
                
                    self.viewModel.setCmsData(id: self.id) { data in
                        self.strTitle = data.first?.cmsTitle ?? ""
                        self.lblDes.text = data.first?.descriptions ?? ""
                        let content = data.first?.descriptions ?? ""
                        if self.id == 39 {
                            self.vwWeb.backgroundColor = .clear
                            self.vwWeb.scrollView.delegate = self
                            print("\(self.backendUrlString)/app_commitments")
                            self.vwWeb.load("\(self.backendUrlString)app_commitments")
                            self.vwWeb.scrollView.showsVerticalScrollIndicator = false
                        } /*else if self.id == 1 {
                            self.vwWeb.backgroundColor = .clear
                            self.vwWeb.scrollView.delegate = self
                            self.vwWeb.load("\(self.backendUrlString)app_about-us")
                            self.vwWeb.scrollView.showsVerticalScrollIndicator = false
                        }else*/
                        else {
                            self.loadHtml(str: content)
                        }
                        self.setTopViewAction()
                        print(data)
                    }
                

            }
            return
        } else if self.comeFrom == .faq {
            self.loadHtml(str: self.strDescription)
            return
        } else { }
        
    }
    
    func loadHtml(str: String) {
        let strFormate = String(format: "<!DOCTYPE html><head><style>@font-face {font-family: '%@';src: url('%@.ttf')format('truetype')}body {font-family: '%@'; background-color: #F3F5FF; text-align:%@; font-size: 14px;}</style></head>%@</html>", FontName.medium.rawValue, FontName.regular.rawValue, FontName.regular.rawValue,"left", str)

        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"

        let strDataLoad = String(format: "%@", FUNCTION().textToHtml(str: String(format: "%@%@", headerString, strFormate)))
        let path = Bundle.main.bundlePath
        let baseURL = URL(fileURLWithPath: path)
        self.vwWeb.backgroundColor = .clear
        self.vwWeb.scrollView.delegate = self
        self.vwWeb.loadHTMLString(strDataLoad, baseURL: baseURL)
        self.vwWeb.scrollView.showsVerticalScrollIndicator = false
    }
    
    // --------------------------------------------
    
    ///
    func setTopViewAction() {
        self.appTopView.textTitle = self.strTitle
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
        
    }
    
    // --------------------------------------------
    
    private func setUp() {
        self.applyStyle()
        
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
}
extension WebViewVC: WKNavigationDelegate{
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint(#function)
        if #available(iOS 13.0, *) {
            webView.scalesLargeContentImage = true
        } else {
            // Fallback on earlier versions
        }
        
        let str = "var meta = document.createElement('meta');"
        let str1 = "meta.setAttribute( 'name', 'viewport' ); "
        let str2 = "meta.setAttribute( 'content', 'width = device-width-32, initial-scale = 0.8, user-scalable = yes' ); "
        let str3 = "document.getElementsByTagName('head')[0].appendChild(meta)"
        
        webView.evaluateJavaScript("\(str)\(str1)\(str2)\(str3)")
        webView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        debugPrint(#function)
        completionHandler(.performDefaultHandling,nil)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                debugPrint(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        debugPrint(#function)
        decisionHandler(.allow)

    }
}

//
//  BaseVC.swift
//  Sahlbooks
//
//  Created by vtadmin on 06/11/23.
//

import UIKit
import IQKeyboardManagerSwift
import DZNEmptyDataSet

class BaseVC: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, Storyboarded, UIGestureRecognizerDelegate {
 
    weak var coordinator : MainCoordinator?
    var noDataType = NodataType.nothingHere

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.coordinator == nil {
            self.coordinator = appDelegate.coordinator
        }
        hideNavigationbar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func hideNavigationbar() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    func setNoData(scrollView: UIScrollView!) {
             scrollView.emptyDataSetSource = self
             scrollView.emptyDataSetDelegate = self
        }
    
    func setNoData(scrollView: UIScrollView!, noDataType: NodataType = .nothingHere) {
        
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        self.noDataType = noDataType
    }
    
    internal func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = noDataType.title
        let attributes = [
            NSAttributedString.Key.foregroundColor:  UIColor.themeBlack,
            NSAttributedString.Key.font: UIFont(name: FontName.medium.rawValue, size: FontSize.size18.rawValue)
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    internal func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return noDataType.image
    }
    
    internal func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return noDataType.shouldAllowScroll
    }
}

extension BaseVC {
    func downloadFile(url: String,completion: @escaping ((URL?)->())) {
        notifier.showLoader()
        NetworkManager.download(downloadURL: url) { success, error, filePath in
            notifier.hideLoader()
            if success {
                completion(filePath)
            } else {
                completion(nil)
            }
        }
    }
}

// extension BaseVC : EmptyDataSetSource, EmptyDataSetDelegate {
//   
//    func setNoData(scrollView: UIScrollView!) {
//        scrollView.emptyDataSetSource = self
//        scrollView.emptyDataSetDelegate = self
//    }
//    
//
//    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//
//        let text = APP_LBL().no_data_found
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.appColor(.gray_text),
//            NSAttributedString.Key.font: FUNCTION().getFont(for: FontName.ManropeRegular, size: 20.0)
//        ]
//        return NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
//        
//    }
//    
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
//        return true
//    }
//    
// }

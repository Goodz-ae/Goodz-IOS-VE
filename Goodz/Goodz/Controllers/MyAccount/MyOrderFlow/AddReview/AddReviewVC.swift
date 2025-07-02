//
//  AddReviewVC.swift
//  Goodz
//
//  Created by Jigz's-Macbook   on 29/03/24.
//

import UIKit
import Cosmos

class AddReviewVC: BaseVC {
  
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    // Order Details View
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var vwMain: UIView!

    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var lblRatingTitle: UILabel!
    @IBOutlet weak var reviewView : CosmosView!
    
    @IBOutlet weak var vwComment: UIView!
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var vwTextView: UIView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnSubmit: ThemeGreenButton!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    private var viewModel : AddReviewVM = AddReviewVM()
    
    var doubleRating: Double = 1.0
    var orderID = ""
    var toStoreID = ""
    var saller_name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTopViewAction()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmitClicked() {
        let str: String = txtView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if str != "" {
            viewModel.addReviewAPI(toStoreID: toStoreID, orderId: orderID, rating: String(format: "%d", Int(doubleRating)), comment: str) { isDone in
                if isDone {
                    self.coordinator?.popVC()
                }
            }
        } else {
            notifier.showToast(message: Labels.pleaseEnterComment)
        }
    }

}
extension AddReviewVC {
    func setUI() {
        lblRatingTitle.text = saller_name == "" ? Labels.how_would_you_rate_this_product : (Labels.how_would_you_like_this + " " + saller_name)
        lblCommentTitle.text = Labels.tellUsMore
        
        self.txtView.delegate = self
        self.txtView.setPlaceholder(text: Labels.startWritingHere, color: UIColor.lightGray)
        self.txtView.setAutocapitalization()
        
        self.vwRating.cornerRadius(cornerRadius: 4.0)
        self.vwComment.cornerRadius(cornerRadius: 4.0)
        
        self.reviewView.settings.disablePanGestures = true
        self.reviewView.settings.fillMode = .full
        self.reviewView.settings.starSize = 32.0
        self.reviewView.settings.starMargin = 24.0
        self.reviewView.settings.totalStars = 5
        self.reviewView.rating = self.doubleRating
        self.reviewView.settings.filledImage = UIImage(named: "cosmos_sel")
        self.reviewView.settings.emptyImage = UIImage(named: "cosmos_unsel")
        self.reviewView.settings.updateOnTouch = true
        self.reviewView.didFinishTouchingCosmos = { rating in
            self.doubleRating = rating
        }
        
        self.btnSubmit.setTitle(Labels.submit, for: .normal)
    }
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.addReview
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension AddReviewVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.vwTextView.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

//
//  ReportVC.swift
//  Goodz
//
//  Created by Akruti on 06/12/23.
//

import Foundation
import UIKit

class ReportVC : BaseVC {
    
    // --------------------------------------------
    // MARK: - Outlets -
    // --------------------------------------------
    
    @IBOutlet weak var appTopView: AppStatusView!
    @IBOutlet weak var lblOdrerID: UILabel!
    @IBOutlet weak var lblPlaceDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDeliverdate: UILabel!
    @IBOutlet weak var lblTellus: UILabel!
    @IBOutlet weak var tvIssue: UITextView!
    @IBOutlet weak var btnPhotoTapped: ThemeGreenBorderButton!
    @IBOutlet weak var btnSubmit: ThemeGreenButton!
    @IBOutlet weak var vwIssue: UIView!
    @IBOutlet weak var btnAttachmentRemove: UIButton!
    @IBOutlet weak var lblAttachmentRemove: UILabel!
    @IBOutlet weak var vwAttachmentRemove: UIView!
    
    // --------------------------------------------
    // MARK: - Custom Variables -
    // --------------------------------------------
    
    private var viewModel : ReportVM = ReportVM()
    var orderDetails : OrderDetailsResult?
    var reportImageURL: URL?
    
    // --------------------------------------------
    // MARK: - Initial Methods -
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("LoginVC")
    }
    
    // --------------------------------------------
    // MARK: - Custom Methods -
    // --------------------------------------------
    
    private func applyStyle() {
        
        self.lblOdrerID.font(font: .regular, size: .size12)
        self.lblOdrerID.color(color: .themeDarkGray)
        
        self.lblPlaceDate.font(font: .regular, size: .size12)
        self.lblPlaceDate.color(color: .themeDarkGray)
        
        self.lblStatus.font(font: .regular, size: .size12)
        self.lblStatus.color(color: .themeBlack)
        
        self.lblDeliverdate.font(font: .regular, size: .size12)
        self.lblDeliverdate.color(color: .themeDarkGray)
        
        self.lblTellus.font(font: .medium, size: .size16)
        self.lblTellus.color(color: .themeBlack)
        
        self.lblAttachmentRemove.font(font: .medium, size: .size14)
        
        self.tvIssue.border(borderWidth: 1, borderColor: .themeBorder)
        self.btnPhotoTapped.setTitle(Labels.attachAPhoto, for: .normal)
        self.btnPhotoTapped.setImage(.iconCameraSmall, for: .normal)
        self.btnSubmit.font(font: .semibold, size: .size16)
        self.btnSubmit.color(color: .themeBlack)
        
        self.tvIssue.delegate = self
        self.tvIssue.font(font: .regular, size: .size14)
        self.tvIssue.setPlaceholder(text: Labels.describeTheIssues, color: UIColor.lightGray,x: 6)
        self.tvIssue.setAutocapitalization()
        self.vwIssue.cornerRadius(cornerRadius: 4.0)
        self.vwIssue.border(borderWidth: 1, borderColor: .clear)
    }
    
    // --------------------------------------------
    
    func setTopViewAction() {
        self.appTopView.textTitle = Labels.reportAProblem
        self.appTopView.backButtonClicked = { [] in
            self.coordinator?.popVC()
        }
    }
    
    // --------------------------------------------
    
    private func setData() {
        
        let model = self.orderDetails
        
        lblOdrerID.text = Labels.orderId + " : #" + (model?.orderID ?? "")
        lblPlaceDate.text = Labels.orderPlaced + " : " + (model?.placedDate ?? "").UTCToLocal(inputFormat: DateFormat.apiDateFormateymd, outputFormat: DateFormat.appDateFormateMMddYYY)
        self.btnSubmit.setTitle(Labels.submit, for: .normal)
        self.lblTellus.text = Labels.tellUsMore
        
        let orderStatus = OrderStatus.allCases.first(where: { $0.orderStatusID == model?.items?.first?.deliveryStatus }) ?? .inTransit
        self.lblStatus.text = Labels.deliveryStatus + ": " + orderStatus.rawValue
        self.lblDeliverdate.text = "Delivered:" + (model?.pickUpDate ?? "")
//        lblDeliverdate.isHidden = orderStatus == .shipped || orderStatus == .inTransit || orderStatus == .orderPlaced
    }
    
    // --------------------------------------------
    private func setUp() {
        self.applyStyle()
        self.setTopViewAction()
        self.setData()
    }
    
    // --------------------------------------------
    
    func attachmentHandler() {
        
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary], vc: self)
        
        AttachmentHandler.shared.imagePickedBlock = { [self] (_,imgUrl) in
            
            reportImageURL = imgUrl
            lblAttachmentRemove.text = imgUrl?.lastPathComponent
            vwAttachmentRemove.isHidden = false
            btnPhotoTapped.isHidden = true
        }
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnPhototapped(_ sender: Any) {
        attachmentHandler()
    }
    
    @IBAction func btnAttachementRemoveTapped(_ sender: Any) {
        
        reportImageURL = nil
        lblAttachmentRemove.text = nil
        vwAttachmentRemove.isHidden = true
        btnPhotoTapped.isHidden = false
        
    }
    
    // --------------------------------------------
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        if self.tvIssue.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            notifier.showToast(message: Labels.pleaseEnterDescribeTheIssues)
        } else {
            // TODO: please set orderProductId
            self.viewModel.fetchConfirmReceptionAPI(issue: self.tvIssue.text, image: reportImageURL, orderProductId: self.orderDetails?.items?.first?.orderProductID ?? "") { [self] isDone in
                
                if isDone {
                    
                    showOKAlert(title: Labels.goodz, message: Labels.reportAddedSuccessfully) {
                        self.coordinator?.popVC()
                    }
                }
            }
           
        }
    }
    
    // --------------------------------------------
    
}

// --------------------------------------------
// MARK: - UITextView Delegate Mathods
// --------------------------------------------

extension ReportVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvIssue.border(borderWidth: 1, borderColor: .themeGreen)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.tvIssue.border(borderWidth: 1, borderColor: .themeBorder)
    }
}

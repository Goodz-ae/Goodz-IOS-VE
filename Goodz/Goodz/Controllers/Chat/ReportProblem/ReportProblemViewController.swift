//
//  ReportProblemViewController.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 29/05/25.
//

import UIKit

class ReportProblemViewController: BaseVC {

    
    @IBOutlet weak var titleLab :  UILabel!
    @IBOutlet weak var telusLab :  UILabel!
    @IBOutlet weak var deliveryStatusLab :  UILabel!
    @IBOutlet weak var deliverLab :  UILabel!
    @IBOutlet weak var dateLab :  UILabel!
    @IBOutlet weak var orderIdLab :  UILabel!
    @IBOutlet weak var tellTV  :  UITextView!
    var attachmentImage :  UIImage?
    var msgDate : MessageModel?
     let vModle = ReportProbVM()
    var completion: ((Bool?) -> Void)?
    @IBOutlet weak var saveButton :  UIButton!
    @IBOutlet weak var imgButton :  UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiUpdate()
        details()
    }
    
    func details(){
        
        self.orderIdLab.text =  "Order ID: \(msgDate?.productDetails?.order_id ?? "" )"
        self.deliverLab.text =  "Delivered : \(msgDate?.productDetails?.choosen_pickup_slot?.choosen_pickup_date ?? "" )"
        self.dateLab.text =  "Order Placed: \(msgDate?.productDetails?.date ?? "" )"
        
        let dateVal = (msgDate?.productDetails?.date ?? "")//.convertDateForYYYYMMdd()
       let valArr =  dateVal.components(separatedBy: " ")
        //(data.productDetails?.date ?? "").loadDate(dateFormate:DateFormatE.YYYYMMdd.rawValue )
        if valArr.count > 0 {
            dateLab.text =  "Order Placed: \(valArr[0] )"
        }else {
            dateLab.text = "Order Placed \(dateVal)"
        }
        
    }
    
    func uiUpdate(){
        
        self.telusLab.font(font: .medium, size: .size14)
        self.titleLab.font(font: .medium, size: .size16)
        
        self.deliveryStatusLab.font(font: .light, size: .size10)
        self.deliverLab.font(font: .light, size: .size10)
        self.dateLab.font(font: .light, size: .size10)
        self.orderIdLab.font(font: .light, size: .size10)
        
        self.saveButton.font(font: .medium, size: .size16)
        self.saveButton.color(color: .themeGreen)
        self.imgButton.font(font: .medium, size: .size16)
        self.imgButton.color(color: .themeGreen)
    }
    
    @IBAction func saveAction(_ sender :  UIButton!){
        if tellTV.text.isEmpty {
            showSimpleAlert(Message: "Please enter details")
            return
        }
        vModle.reportProblemt(tell_us: tellTV.text, img: self.attachmentImage  ) { [weak self] _status in
            if _status {
                
                self?.completion?(_status )
            }
        }
        self.coordinator?.dismissVC()
    }
    
    @IBAction func imgAction(_ sender :  UIButton!){
        attachmentHandler()
    }
    
    
    func attachmentHandler() {
        AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .phoneLibrary,.file], vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [self] (img,imgUrl) in
            print(img)
             
            self.attachmentImage = img
             
            
        }
    }

}

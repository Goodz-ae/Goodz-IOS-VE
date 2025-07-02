//
//  ChatViewCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 19/12/23.
//

import UIKit

class ChatViewCell: UITableViewCell, Reusable {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    /// `Pick up` & `Contact Us`
    @IBOutlet weak var viewContactPickUp: UIView!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    
    /// Sender
    @IBOutlet weak var viewSender: UIView!
    @IBOutlet weak var lblSenderChat: UILabel!
    @IBOutlet weak var lblSenderTime: UILabel!
    
    /// Receiver Image
    @IBOutlet weak var viewReceiveImage: UIView!
    @IBOutlet weak var lblReceiveImageTime: UILabel!
    @IBOutlet weak var ivReceive: UIImageView!
    @IBOutlet weak var imgReceiverPlay: UIImageView!
    
    /// Sender Image
    @IBOutlet weak var viewSendImage: UIView!
    @IBOutlet weak var lblSendImageTime: UILabel!
    @IBOutlet weak var ivSend: UIImageView!
    @IBOutlet weak var imgSenderPlay: UIImageView!
    
    /// Receiver
    @IBOutlet weak var viewReceiver: UIView!
    @IBOutlet weak var lblReceiverChat: UILabel!
    @IBOutlet weak var lblReceiverTime: UILabel!
    
    /// Other
    @IBOutlet weak var viewOther: UIView!
    @IBOutlet weak var lblOther: UILabel!
    
    //pickup date and time
    @IBOutlet weak var vwPickUpDate: UIView!
    @IBOutlet weak var lblPickupDate: UILabel!
    
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblChange: UILabel!
    
    ///address
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    ///schedule sucess
    
    @IBOutlet weak var vwSchedule: UIView!
    @IBOutlet weak var lblSchedule: UILabel!
    
    @IBOutlet weak var vwReceivePdf: UIView!
    @IBOutlet weak var lblReceivePdf: UILabel!
    @IBOutlet weak var vwSendPdf: UIView!
    @IBOutlet weak var lblReceivePdfTime: UILabel!
    @IBOutlet weak var imgReceivePdf: UIImageView!
    
    @IBOutlet weak var lblSendPdf: UILabel!
    @IBOutlet weak var lblSendPdfTime: UILabel!
    @IBOutlet weak var imgSendPdf: UIImageView!
    
    //
    // --------------------------------------------
    // MARK: - Initial Methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.lblOther.font(font: .medium, size: .size14)
        self.lblSenderChat.font(font: .regular, size: .size14)
        self.lblReceiverChat.font(font: .regular, size: .size14)
        
        self.lblSenderTime.font(font: .regular, size: .size12)
        self.lblReceiverTime.font(font: .regular, size: .size12)
    
        self.lblReceivePdfTime.font(font: .regular, size: .size12)
        self.lblSendPdfTime.font(font: .regular, size: .size12)
        
        self.lblSendImageTime.font(font: .regular, size: .size12)
        self.lblReceiveImageTime.font(font: .regular, size: .size12)
        self.ivSend.backgroundColor = .purple
        self.ivReceive.backgroundColor = .themeGray
        self.lblPickupDate.font(font: .semibold, size: .size16)
        self.lblPickupDate.color(color: .themeBlack)
        
        self.lblAddress.font(font: .semibold, size: .size16)
        self.lblAddress.color(color: .themeBlack)
        
        self.lblChange.font(font: .semibold, size: .size16)
        self.lblChange.color(color: .themeBlack)
        
        self.lblArea.font(font: .regular, size: .size14)
        self.lblArea.color(color: .themeGray)
        
        self.lblCity.font(font: .regular, size: .size14)
        self.lblCity.color(color: .themeGray)
        
        self.lblMobile.font(font: .regular, size: .size14)
        self.lblMobile.color(color: .themeGray)
        
        self.lblSchedule.font(font: .medium, size: .size16)
        self.lblSchedule.color(color: .themeBlack)
        
        self.lblAddress.text = Labels.address
        self.lblChange.text = Labels.change
        
        self.imgSenderPlay.cornerRadius(cornerRadius: self.imgSenderPlay.frame.size.height / 2.0)
        self.imgReceiverPlay.cornerRadius(cornerRadius: self.imgReceiverPlay.frame.size.height / 2.0)
        
        self.viewReceiver.isHidden = true
        self.viewSender.isHidden = true
        self.viewOther.isHidden = true
        self.viewReceiveImage.isHidden = true
        self.viewSendImage.isHidden = true
        self.viewContactPickUp.isHidden = true
        self.vwAddress.isHidden = true
        self.vwPickUpDate.isHidden = true
        self.vwSchedule.isHidden = true
        self.vwSendPdf.isHidden = true
        self.vwReceivePdf.isHidden = true
        self.imgSenderPlay.isHidden = true
        self.imgReceiverPlay.isHidden = true
    }
    
    // --------------------------------------------
    
    func  setChatDetails(data: MessageModel) {
        
        let date  = data.messageDateTime?.getTimerOnly()
        self.viewReceiver.isHidden = true
        self.viewSender.isHidden = true
        self.viewOther.isHidden = true
        self.viewReceiveImage.isHidden = true
        self.viewSendImage.isHidden = true
        self.viewContactPickUp.isHidden = true
        self.vwAddress.isHidden = true
        self.vwPickUpDate.isHidden = true
        self.vwSchedule.isHidden = true
        self.vwSendPdf.isHidden = true
        self.vwReceivePdf.isHidden = true
        self.imgSenderPlay.isHidden = true
        self.imgReceiverPlay.isHidden = true
        switch (data.sendByMe, data.messageType) {
        case (Status.zero.rawValue, Status.one.rawValue):
            self.viewReceiver.isHidden = false
            self.lblReceiverChat.text = data.messageText
            self.lblReceiverTime.text = date
        case (Status.zero.rawValue, Status.four.rawValue):
            self.vwReceivePdf.isHidden = false
            self.lblReceivePdf.text = URL(fileURLWithPath: data.messageURL ?? "").lastPathComponent
            self.lblReceivePdfTime.text = date
        case (Status.zero.rawValue, Status.two.rawValue), (Status.zero.rawValue, Status.three.rawValue):
            self.viewReceiveImage.isHidden = false
            self.ivReceive.image = (data.messageURL != nil) ? .ivInterior : nil
            self.imgReceiverPlay.isHidden = (data.messageType == Status.two.rawValue)
            if data.messageType == Status.three.rawValue {
                let img: ()? = data.messageURL?.createVideoThumbnail(completion: { image in
                    self.ivReceive.image = image
                })
            } else {
                if let img = data.messageURL, let url = URL(string: img) {
                    self.ivReceive.sd_setImage(with: url, placeholderImage: .product)
                    self.ivReceive.contentMode = .scaleAspectFill
                } else {
                    self.ivReceive.image = .product
                }
            }
            self.lblReceiveImageTime.text = date
        case (Status.one.rawValue, Status.one.rawValue):
            self.viewSender.isHidden = false
            self.lblSenderChat.text = data.messageText
            self.lblSenderTime.text = date
            
        case (Status.one.rawValue, Status.four.rawValue):
            self.vwSendPdf.isHidden = false
            self.lblSendPdf.text = URL(fileURLWithPath: data.messageURL ?? "").lastPathComponent
            self.lblSendPdfTime.text = date
        case (Status.one.rawValue, Status.two.rawValue), (Status.one.rawValue, Status.three.rawValue):
            self.viewSendImage.isHidden = false
            self.imgSenderPlay.isHidden = data.messageType == Status.two.rawValue
            self.ivSend.image = (data.messageURL != nil) ? .ivInterior : nil
            if data.messageType == Status.three.rawValue {
                let img: ()? = data.messageURL?.createVideoThumbnail(completion: { image in
                    self.ivSend.image = image
                })
            } else {
                if let img = data.messageURL, let url = URL(string: img) {
                    self.ivSend.sd_setImage(with: url, placeholderImage: .product)
                    self.ivSend.contentMode = .scaleAspectFill
                } else {
                    self.ivSend.image = .product
                }
            }
            self.lblSendImageTime.text = date
        case (_, Status.five.rawValue), (_, Status.six.rawValue):
            self.viewOther.isHidden = false
            self.lblOther.text = data.messageText
        case (_, _):
            print("hellooo =========================")
            break
        }
        print(self.viewReceiver.isHidden == true,
              self.viewSender.isHidden == true,
              self.viewOther.isHidden == true,
              self.viewReceiveImage.isHidden == true,
              self.viewSendImage.isHidden == true,
              self.viewContactPickUp.isHidden == true,
              self.vwAddress.isHidden == true,
              self.vwPickUpDate.isHidden == true,
              self.vwSchedule.isHidden == true,
              self.vwSendPdf.isHidden == true,
              self.vwReceivePdf.isHidden == true,
              self.imgSenderPlay.isHidden == true,
              self.imgReceiverPlay.isHidden == true)
    }
}

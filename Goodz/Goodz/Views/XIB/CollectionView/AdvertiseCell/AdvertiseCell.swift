//
//  AdvertiseCell.swift
//  Goodz
//
//  Created by Priyanka Poojara on 12/12/23.
//

import UIKit

class AdvertiseCell: UICollectionViewCell, Reusable {

    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblTelr: UILabel!
    @IBOutlet weak var imgDelivery: UIImageView!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    
    // --------------------------------------------
    // MARK: - Initial methods
    // --------------------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
        self.setData()
    }
    
    // --------------------------------------------
    // MARK: - Custom methods
    // --------------------------------------------
    
    func applyStyle() {
        self.lblDoor.font(font: .medium, size: .size16)
        self.lblDoor.color(color: .themeBlack)
        
        self.lblDelivery.font(font: .regular, size: .size12)
        self.lblDelivery.color(color: .themeBlack)
        
        self.lblPayment.font(font: .medium, size: .size18)
        self.lblPayment.color(color: .themeBlack)
        
        self.lblTelr.font(font: .medium, size: .size14)
        self.lblTelr.color(color: .themeBlack)
        self.imgBG.image = .cellBgImg
        self.imgPayment.image = .cellBgImg1
        self.imgDelivery.image = .cellBgImg2
    }

    // --------------------------------------------
    
    func setData() {
        self.lblDoor.text = Labels.DoorToDoor
        self.lblTelr.text = Labels.telr
        self.lblPayment.text = Labels.paymentWith
        self.lblDelivery.text = Labels.delivery
    }
}

//
//  Step1View.swift
//  Goodz
//
//  Created by shobhitdhuria on 06/05/25.
//

import UIKit

class SellStepView: UITableViewCell, Reusable {

    @IBOutlet weak var stepCountLbl: UILabel!
    @IBOutlet weak var stepCountImageView: UIImageView!
    
    @IBOutlet weak var headingBackView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    
    @IBOutlet weak var productDetailBackView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productOnSaleLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    
    @IBOutlet weak var collectionBackView: UIView!
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    
    @IBOutlet weak var actionStatusBackView: UIView!
    @IBOutlet weak var actionStatusLbl: UILabel!
    
    @IBOutlet weak var infoProviderBackView: UIView!
    @IBOutlet weak var infoSymbolImageView: UIImageView!
    @IBOutlet weak var infoDetailLbl: UILabel!
    
    @IBOutlet weak var addressBackView: UIView!
    @IBOutlet weak var flatNoAddressLbl: UILabel!
    @IBOutlet weak var cityAddressLbl: UILabel!
    
    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var messageDisplayLbl: UILabel!
    
    @IBOutlet weak var btnStackView: UIStackView!
    @IBOutlet weak var firstFillBtn: UIButton!
    @IBOutlet weak var secondEmptyBtn: UIButton!
    
    //var selectedIndexes: Set<Int> = []
    
    var selectedPickupSlots : Pickup_slots?
    
    var pickup_slots : [Pickup_slots]?
    var choosen_pickup_slot : Choosen_pickup_slot?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonUI() {
        self.stepCountLbl.font(font: .regular, size: .size14)
        self.headingLbl.font(font: .semibold, size: .size14)
        self.productNameLbl.font(font: .semibold, size: .size14)
        self.productOnSaleLbl.font(font: .extraLight, size: .size12)
        self.productPriceLbl.font(font: .semibold, size: .size14)
        
        self.flatNoAddressLbl.font(font: .regular, size: .size14)
        self.cityAddressLbl.font(font: .regular, size: .size14)
        
        self.firstFillBtn.titleLabel?.font(font: .semibold, size: .size14)
        self.secondEmptyBtn.titleLabel?.font(font: .semibold, size: .size14)
        
        self.slotsCollectionView.delegate = self
        self.slotsCollectionView.dataSource = self
        self.slotsCollectionView.registerReusableCell(StepSlotsCVC.self)
    }
    
    func  setChatDetails(data: MessageModel) {        
        pickup_slots = data.productDetails?.pickup_slots
        choosen_pickup_slot = data.productDetails?.choosen_pickup_slot
        
        let dateVal = (data.productDetails?.date ?? "")//.convertDateForYYYYMMdd()
       let valArr =  dateVal.components(separatedBy: " ")
        //(data.productDetails?.date ?? "").loadDate(dateFormate:DateFormatE.YYYYMMdd.rawValue )
        if valArr.count > 0 {
            productOnSaleLbl.text = "On sale since \(valArr[0])"
        }else {
            productOnSaleLbl.text = "On sale since \(dateVal)"
        }
        if let product = data.productDetails {
            if let img = product.image, let url = URL(string: img) {
                productImageView.sd_setImage(with: url, placeholderImage: .product)
                productImageView.contentMode = .scaleToFill
            } else {
                productImageView.image = .product
            }
            
            productNameLbl.text     =   product.name
            productPriceLbl.text    =   kCurrency + (product.selling_price ?? Status.zero.rawValue)
                
            
            
            let isSeller = (data.productDetails?.owner_id ?? "") ==  UserDefaults.userID ? true : false
            
            
            var availability_confirmed    = product.availability_confirmed
            
            availability_confirmed = availability_confirmed == nil ? 0 : availability_confirmed
           // let isSeller        = data.is_seller == "1"
          //  let isBuyer         = data.is_seller == "0"
            let deliveryMethod  = data.delivery_method
            let hasPickupSlots  = (data.productDetails?.pickup_slots?.count ?? 0) > 0
            let hasChosenPickup = data.productDetails?.choosen_pickup_slot != nil
            
            switch (availability_confirmed, isSeller, deliveryMethod, hasPickupSlots, hasChosenPickup) {
                
             //   confirmedAvailability
                
            case (1, false , "2", false  , false ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 601
                self.secondEmptyBtn.tag = 602
                setUpUI(.confirmedAvailability, .first, .Buyer, .Pickup, data: data)
                break
                
            case (1, true , "2", true  , true ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 1001
                self.secondEmptyBtn.tag = 1002
                setUpUI(.ChoosePickupData, .third, .Seller, .Pickup, data: data)
                
                 if data.productDetails?.pickupConfirmed == 1 {
                     
                     self.firstFillBtn.title(title: "Everything’s OK")
                     //self.secondEmptyBtn.isHidden = true
                     
                 }
                break
            case (1, false , "2", true  , true ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 501
                self.secondEmptyBtn.tag = 502
                setUpUI(.ChoosePickupData, .third, .Buyer, .Pickup, data: data)
                break
            case (1, false , "2", true  , false ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 401
                self.secondEmptyBtn.tag = 402
                setUpUI(.ChoosePickupData, .second, .Buyer, .Pickup, data: data)
                break
                
            case (1, true, "2", true  , false ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 301
                self.secondEmptyBtn.tag = 302
                setUpUI(.thanksForChoosing, .second, .Seller, .Pickup, data: data)
                break
                
            case (1, true, "2", false , false ):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 201
                self.secondEmptyBtn.tag = 202
                setUpUI(.ChoosePickupData, .second, .Seller, .Pickup, data: data)
                break
                
            case (0, false , _, _, _):
                // No action, or maybe a comment for clarity
                setUpUI(.waitingtoconfirmavailability, .first, .Buyer, .Pickup, data: data)
                break

                
            case (0, true, "2", _, _):
                // No action, or maybe a comment for clarity
                self.firstFillBtn.tag = 101
                self.secondEmptyBtn.tag = 102
                setUpUI(.confirmAvailability, .first, .Seller, .Pickup, data: data)
                break

            case (1, false, "2", true, true):
                setUpUI(.Pickup, .third, .Buyer, .Pickup, data: data)
            case (2, false, "2", _, _):
                setUpUI(.declined, .first, .Buyer, .Delivery, data: data)

            case (2, true, "2", _, _):
                setUpUI(.declined, .first, .Seller, .Delivery, data: data)

            case (2, false, "1", _, _):
                setUpUI(.declined, .first, .Buyer, .Delivery, data: data)

            case (2, true, "1", _, _):
                setUpUI(.declined, .first, .Seller, .Delivery, data: data)

                
                
            case (1, false, "1", _, _):
                
                self.firstFillBtn.tag = 901
                self.secondEmptyBtn.tag = 902
                
                setUpUI(.confirmAvailability, .third, .Buyer, .Delivery, data: data)

            case (1, true, "1", _, _):
                self.firstFillBtn.tag = 701
                self.secondEmptyBtn.tag = 702
                setUpUI(.confirmAvailability, .third, .Seller, .Delivery, data: data)
                
               /* if data.productDetails?.pickupConfirmed == 1 {
                    
                    self.firstFillBtn.isHidden = true
                    self.secondEmptyBtn.isHidden = true
                    
                }*/
                

            case (0, true, "1", _, _):
                self.firstFillBtn.tag = 101
                self.secondEmptyBtn.tag = 102
                setUpUI(.confirmAvailability, .first, .Seller, .Delivery, data: data)

            case (0, false, "1", _, _):
                setUpUI(.waitingtoconfirmavailability, .first, .Buyer, .Delivery, data: data)

            default:
                break
            }
            
            
            /*
            if product.availability_confirmed == nil && data.is_seller == "1" {
                
            } else if product.availability_confirmed == 1 && data.is_seller == "0" && data.delivery_method == "2" && ((data.productDetails?.pickup_slots?.count ?? 0 ) > 0) && ((data.productDetails?.choosen_pickup_slot != nil  ) ) {
                setUpUI(.Pickup, .third, .Buyer, .Pickup , data:data )
            } else if product.availability_confirmed == 2 && data.is_seller == "0" && data.delivery_method == "1"{
                setUpUI(.declined, .first, .Buyer, .Delivery , data:data )
            } else if product.availability_confirmed == 2 && data.is_seller == "1" && data.delivery_method == "1"{
                setUpUI(.declined, .first, .Seller, .Delivery , data:data )
            }else if product.availability_confirmed == 1 && data.is_seller == "0" && data.delivery_method == "1"{
                setUpUI(.confirmAvailability, .third, .Buyer, .Delivery , data:data )
            } else if product.availability_confirmed == 1 && data.is_seller == "1" && data.delivery_method == "1"{
                self.firstFillBtn.tag = 101 // For Confirm availablity
                self.secondEmptyBtn.tag = 102 // For Confirm availablity
                setUpUI(.confirmAvailability, .third, .Seller, .Delivery , data:data )
            } else if data.is_seller == "1" && data.delivery_method == "1"{
                setUpUI(.confirmAvailability, .first, .Seller, .Delivery , data:data)
                self.firstFillBtn.tag = 101 // For Confirm availablity
                self.secondEmptyBtn.tag = 102 // For Confirm availablity
            }else if data.is_seller == "0" && data.delivery_method == "1"{
                setUpUI(.waitingtoconfirmavailability, .first, .Buyer, .Delivery, data:data)
            }*/
        }
    }
    
    func setUpUI(_ status: OrderStatusDeli, _ stepCount: StepCount, _ user: UserTypeChat, _ deliveryType: DeliveryType , data: MessageModel) {
        switch user {
        case .Buyer:
            switch deliveryType {
                
                // MARK: - Delivery for Buyer
            case .Delivery:
                switch stepCount {
                    // MARK: - First step for Buyer in Delivery
                case .first:
                    self.stepCountLbl.text = "Step 1"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep1")
                    
                    if status == .waitingtoconfirmavailability {
                        self.headingLbl.text = "We are waiting for the seller to confirm availability"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Clock")
                        let hour = 90
                        let boldPart = "\(hour) hours left"
                        let fullText = "He has \(boldPart) to confirm that the product is still available to buy !"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }

                        self.infoDetailLbl.attributedText = attributedText
                        self.messageDisplayLbl.text = ""//"When it’s done, you’ll have to chose a time slot to pick up your product"
                        self.messageDisplayLbl.font(font: .regular, size: .size14)
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .confirmedAvailability {
                        
                        self.actionStatusBackView.backgroundColor = .themeGreenBG
                        self.actionStatusLbl.text = "The seller has confirmed the availability of the product !"
                        self.actionStatusLbl.textColor = .black
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 0
                        
                        self.messageDisplayLbl.text = "You can track your shippment by clicking here:"
                        self.messageDisplayLbl.font(font: .regular, size: .size14)
                        
                        self.firstFillBtn.title(title: "Track my order")
                        
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .declined {
                        
                        self.actionStatusBackView.backgroundColor = .themeStepRedBG
                        self.actionStatusLbl.text = "The product is no longer available, the sale has been cancel..."
                        self.actionStatusLbl.textColor = .themeRedStepFG
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 0
                        
                        self.messageDisplayLbl.text = "Don't give up, you'll finally find the perfect piece"
                        self.messageDisplayLbl.font(font: .regular, size: .size14)
                        
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                    }
                    
                    // MARK: - Second step for Buyer in Delivery
                case .second:
                    
                    self.stepCountLbl.text = "Step 2"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep2")
                    self.headingLbl.text = "Your item is on it way"
                    self.infoSymbolImageView.image = UIImage(named: "Calendar")
                    let date = "14/May/2025"
                    let time = "12:00 pm to 5:00 pm"
                    let boldPart = "\(date) between \(time)"
                    let fullText = "You will be delivered on the \(boldPart)"

                    let attributedText = NSMutableAttributedString(string: fullText,
                                                                   attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                    if let range = fullText.range(of: boldPart) {
                        let nsRange = NSRange(range, in: fullText)
                        attributedText.addAttribute(.font,
                                                    value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                     range: nsRange)
                    }
                    self.infoDetailLbl.attributedText = attributedText
                    self.firstFillBtn.title(title: "Track my order")
                    self.secondEmptyBtn.title(title: "Postpone delivery")
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = true
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = false
                    self.addressBackView.isHidden = true
                    self.messageBackView.isHidden = true
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                    // MARK: - Third step for Buyer in Delivery
                case .third:
                    
                    self.stepCountLbl.text = "Step 3"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep3")
                    
                    self.headingLbl.text = "Your item has been delivered"
                    
                    self.actionStatusLbl.text = "You now have 24hours to report any issues with your item"
                    self.actionStatusLbl.font(font: .regular, size: .size14)
                    
                    self.messageDisplayLbl.text = "Thank’s for choosing goodz"
                    self.messageDisplayLbl.font(font: .semibold, size: .size16)
                    
                    self.firstFillBtn.title(title: "Everything’s OK")
                    self.secondEmptyBtn.title(title: "Report an issue")
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = true
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = false
                    self.infoProviderBackView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.messageBackView.isHidden = false
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                default:
                    return
                }
                
                // MARK: - Pickup for Buyer
            case.Pickup:
                switch stepCount {
                    // MARK: - First step for Buyer in Pickup
                case .first:
                    
                    self.stepCountLbl.text = "Step 1"
                    self.stepCountImageView.image = UIImage(named: "PickupStep1")
                    
                    if status == .waitingtoconfirmavailability {
                        self.headingLbl.text = "We are waiting for the seller to confirm availability"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Clock")
                        let hour = 96
                        let boldPart = "\(hour) hours left"
                        let fullText = "He has \(boldPart) to confirm that the product is still available to buy !"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }

                        self.infoDetailLbl.attributedText = attributedText
                        
                        self.messageDisplayLbl.text = "When it’s done, you’ll have to chose a time slot to pick up your product"
                        self.messageDisplayLbl.font(font: .light, size: .size14)
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .confirmedAvailability {
                        
                        self.actionStatusBackView.backgroundColor = .themeGreenBG
                        self.actionStatusLbl.text = "The seller has confirmed the availability of the product !"
                        self.actionStatusLbl.textColor = .black
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 0
                        
                        self.messageDisplayLbl.text = "We’re wating for him to choose time slots where you can pick up your product"
                        self.messageDisplayLbl.font(font: .light, size: .size14)
                                                
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .declined {
                        
                        self.actionStatusBackView.backgroundColor = .themeStepRedBG
                        self.actionStatusLbl.text = "The product is no longer available, the sale has been cancel..."
                        self.actionStatusLbl.textColor = .themeRedStepFG
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 0
                        
                        self.messageDisplayLbl.text = "Don't give up, you'll finally find the perfect piece"
                        self.messageDisplayLbl.font(font: .regular, size: .size14)
                        
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                    }
                    
                    // MARK: - Second step for Buyer in Pickup
                case .second:
                    self.stepCountLbl.text = "Step 2"
                    self.stepCountImageView.image = UIImage(named: "PickupStep2")
                    
                    if status == .ChoosePickupData {
                        
                        self.headingLbl.text = "Choose the pick up slot that suits you best"
                        
                        self.firstFillBtn.title(title: "Confirm")
                        self.secondEmptyBtn.title(title: "I am not available")
                        
                        self.slotsCollectionView.reloadData()
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = false
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    } else if status == .thanksForChoosing {
                        
                        self.headingLbl.text = "Thanks for choosing a pick up date"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Calendar")
                        let date = "14/May/2025"
                        let time = "12:00 pm to 5:00 pm"
                        let boldPart = "\(date) between \(time)"
                        let fullText = "You can get your item on the \(boldPart)"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }

                        self.infoDetailLbl.attributedText = attributedText
                        
                        self.firstFillBtn.title(title: "I want to change the slot")
                        self.secondEmptyBtn.title(title: "Contact us ")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                    }
                    
                    // MARK: - Third step for Buyer in Pickup
                case .third:
                    self.stepCountLbl.text = "Step 3"
                    self.stepCountImageView.image = UIImage(named: "PickupStep3")
                    
                    self.headingLbl.text = "The time to pick up your item is close, don’t forget"
                    
                    self.infoSymbolImageView.image = UIImage(named: "Calendar")
                    
                    let prodcut  = data.productDetails
                    
                    let date = prodcut?.choosen_pickup_slot?.choosen_pickup_date ?? "" //"14/May/2025"
                    let time = prodcut?.choosen_pickup_slot?.choosen_pickup_time ?? ""//"12:00 pm to 5:00 pm"
                    let boldPart = "\(date) between \(time)"
                    let fullText = "Your appointment to collect your item from the seller is on \(boldPart)"

                    let attributedText = NSMutableAttributedString(string: fullText,
                                                                   attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                    if let range = fullText.range(of: boldPart) {
                        let nsRange = NSRange(range, in: fullText)
                        attributedText.addAttribute(.font,
                                                    value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                     range: nsRange)
                    }

                    self.cityAddressLbl.text = ""
                    self.flatNoAddressLbl.text = "-"
                    self.infoDetailLbl.attributedText = attributedText
                    
                    self.firstFillBtn.title(title: "Find the route")
                    self.secondEmptyBtn.title(title: "I want to change the slot")
                    self.secondEmptyBtn.titleLabel?.font(font: .semibold, size: .size12)
                    let addressPickUpModel = prodcut?.addressPickUpModel
                    self.cityAddressLbl.text = (addressPickUpModel?.city ?? "" ) + ", " + (addressPickUpModel?.city ?? "" )
                    self.flatNoAddressLbl.text = (addressPickUpModel?.floor ?? "" ) + ", " + (addressPickUpModel?.street_address ?? "" )
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = true
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = false
                    self.addressBackView.isHidden = false
                    self.messageBackView.isHidden = true
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                    // MARK: - Fourth step for Buyer in Pickup
                case .fourth:
                    
                    self.stepCountLbl.text = "Step 4"
                    self.stepCountImageView.image = UIImage(named: "PickupStep4")
                    
                    
                    let boldPart = data.productDetails?.owner_name ?? ""
                    let fullText = "You’ve pick up your article at \(boldPart)s"

                    let attributedText = NSMutableAttributedString(string: fullText,
                                                                   attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                    if let range = fullText.range(of: boldPart) {
                        let nsRange = NSRange(range, in: fullText)
                        attributedText.addAttribute(.font,
                                                    value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                     range: nsRange)
                    }
                    self.headingLbl.attributedText = attributedText
                    
                    self.firstFillBtn.title(title: "Confirm pick up")
                    self.secondEmptyBtn.title(title: "Something is wrong")
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = false
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.messageBackView.isHidden = true
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                default:
                    return
                }
            default:
                return
            }
            
            // MARK: - Seller side
        case .Seller:
            switch deliveryType {
                
                // MARK: - Seller Delivery
            case .Delivery:
                switch stepCount {
                    // MARK: - First step for Seller in Delivery
                case .first:
                    
                    self.stepCountLbl.text = "Step 1"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep1")
                    
                    if status == .confirmAvailability {
                        
                        self.headingLbl.text = "Please, confirm the availability of your product"
                        self.infoSymbolImageView.image = UIImage(named: "Clock")
                        let hour = 90
                        let boldPart = "\(hour) hours left"
                        let fullText = "You have \(boldPart) to confirm that your product is still available to buy !"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }

                        self.infoDetailLbl.attributedText = attributedText
                        
                        self.firstFillBtn.title(title: "Confirm availability")
                        self.secondEmptyBtn.title(title: "Cancel sale")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    } else if status == .availabilityConfirm {
                        
                        self.headingLbl.text = "Please, confirm the availability of your product"
                        
                        self.actionStatusBackView.backgroundColor = .themeBG
                        self.actionStatusLbl.text = "The availability has been confirm"
                        self.actionStatusLbl.textColor = .black
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 3
                                                                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .declined {
                        
                        self.headingLbl.text = "Please, confirm the availability of your product"
                       self.headingBackView.isHidden = true
                        self.actionStatusBackView.backgroundColor = .themeStepRedBG
                        self.actionStatusLbl.text = "The sale has been cancel"
                        self.actionStatusLbl.textColor = .themeRedStepFG
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 3
                        
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                    }
                    
                    // MARK: - Second step for Seller in Delivery
                case .second:
                    
                    self.stepCountLbl.text = "Step 2"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep2")
                    
                    if status == .arrangePickUp {
                        
                        self.headingLbl.text = "Thanks for using GOODZ to sell your item"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Calendar")
                        self.infoDetailLbl.text = "You will be contacted by our delivery partner to arrange the pick up at your house. Please be prepared."
                        self.infoDetailLbl.font(font: .light, size: .size14)
                        
                        self.firstFillBtn.title(title: "Contact us")
                        self.secondEmptyBtn.title(title: "Your wrapping guide")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    } else if status == .ontheway {
                        
                        self.headingLbl.text = "Thanks for using GOODZ to sell your item"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Pickup")
                        self.infoDetailLbl.text = "Your article is now on its way to its new owner's home."
                        self.infoDetailLbl.font(font: .light, size: .size14)
                        
                        self.firstFillBtn.title(title: "Track my shipment")
                        self.secondEmptyBtn.title(title: "Contact us")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                    }
                    
                    // MARK: - Third step for Seller in Delivery
                case .third:
                    
                    self.stepCountLbl.text = "Step 3"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep3")
                    
                    self.headingLbl.text = "Your item has been delivered at \(data.buyerName ?? "" )’s place"
                    
                    self.messageDisplayLbl.text = "The money will be transfer to your bank account in the next few days Thanks for choosing GOODZ !"
                    self.messageDisplayLbl.font(font: .semibold, size: .size14)
                    
                    self.firstFillBtn.title(title: "Add another item")
                    self.secondEmptyBtn.title(title: "Check my wallet")
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = false
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.messageBackView.isHidden = false
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                default:
                    return
                }
                
                // MARK: - Seller in Pickup
            case.Pickup:
                switch stepCount {
                    
                    // MARK: - First step for seller in Pickup
                case .first:
                    
                    self.stepCountLbl.text = "Step 1"
                    self.stepCountImageView.image = UIImage(named: "DeliveryStep1")
                    
                    if status == .confirmAvailability {
                        self.headingLbl.text = "Please, confirm the availability of your product"
                        
                        self.infoSymbolImageView.image = UIImage(named: "Clock")
                        let hours = 96
                        let boldPart = "\(hours) hours left"
                        let fullText = "You have \(boldPart) to confirm that your product is still available to buy !"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }

                        self.infoDetailLbl.attributedText = attributedText
                        
                        self.firstFillBtn.title(title: "Confirm availability")
                        self.secondEmptyBtn.title(title: "Cancel sale")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    } else if status == .availabilityConfirm {
                        
                        self.headingLbl.text = "Please, confirm the availability of your product"
                        
                        self.actionStatusBackView.backgroundColor = .themeBG
                        self.actionStatusLbl.text = "The availability has been confirm"
                        self.actionStatusLbl.textColor = .black
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 3
                                                                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                        
                    } else if status == .declined {
                        
                        self.headingLbl.text = "Please, confirm the availability of your product"
                        self.headingBackView.isHidden = true
                        self.actionStatusBackView.backgroundColor = .themeStepRedBG
                        self.actionStatusLbl.text = "The sale has been cancel"
                        self.actionStatusLbl.textColor = .themeRedStepFG
                        self.actionStatusLbl.font(font: .medium, size: .size14)
                        self.actionStatusBackView.cornerRadius = 3
                        
                        self.headingBackView.isHidden = true
                        self.productDetailBackView.isHidden = false
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = false
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = true
                        self.firstFillBtn.isHidden = true
                        self.secondEmptyBtn.isHidden = true
                    }
                    
                    // MARK: - Second step for seller in Pickup
                case .second:
                    
                    self.stepCountLbl.text = "Step 2"
                    self.stepCountImageView.image = UIImage(named: "PickupStep2")
                    
                    if status == .ChoosePickupData {
                        
                        self.headingLbl.text = "Please, choose pickup dates."
                        
                        self.infoSymbolImageView.image = UIImage(named: "Calendar")
                        self.infoDetailLbl.text = "You’ll have to choose 3 different time slots, so the buyer can choose the one that suits him best"
                        self.infoDetailLbl.font(font: .light, size: .size14)
                        
                        self.firstFillBtn.title(title: "Choose pick up dates")
                        self.secondEmptyBtn.title(title: "Contact us ")
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = true
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = false
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = true
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    } else if status == .thanksForChoosing {
                        
                        
                        
                        let boldPart = data.buyerName?.capitalized ?? ""
                        let fullText = "Now wait for \(boldPart) to choose the slots that suits him best"

                        let attributedText = NSMutableAttributedString(string: fullText,
                                                                       attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                        if let range = fullText.range(of: boldPart) {
                            let nsRange = NSRange(range, in: fullText)
                            attributedText.addAttribute(.font,
                                                        value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                         range: nsRange)
                        }
                        
                        self.messageDisplayLbl.attributedText = attributedText
                        
                        self.headingLbl.text = "You selected the following pick up slots."
                       
                        //self.messageDisplayLbl.text = "Now wait for \(buyerName ?? "") to choose the slots that suits him best"
                      //  self.messageDisplayLbl.font(font: .light, size: .size14)
                        
                        self.firstFillBtn.title(title: "Change the slots")
                        self.secondEmptyBtn.title(title: "Contact us ")
                        
                        self.slotsCollectionView.reloadData()
                        
                        self.headingBackView.isHidden = false
                        self.productDetailBackView.isHidden = true
                        self.collectionBackView.isHidden = false
                        self.actionStatusBackView.isHidden = true
                        self.infoProviderBackView.isHidden = true
                        self.addressBackView.isHidden = true
                        self.messageBackView.isHidden = false
                        self.btnStackView.isHidden = false
                        self.firstFillBtn.isHidden = false
                        self.secondEmptyBtn.isHidden = false
                        
                    }
                    
                    // MARK: - Third step for seller in Pickup
                case .third:
                    
                    self.stepCountLbl.text = "Step 3"
                    self.stepCountImageView.image = UIImage(named: "PickupStep3")
                    
                    self.headingLbl.text = "The time for the buyer to pick up your item is close"
                    
                    self.infoSymbolImageView.image = UIImage(named: "Calendar")
                    let prodcut  = data.productDetails
                    
                    //let date = "14/May/2025"
                    //let time = "12:00 pm to 5:00 pm"
                    
                    let date = prodcut?.choosen_pickup_slot?.choosen_pickup_date ?? "" //"14/May/2025"
                    let time = prodcut?.choosen_pickup_slot?.choosen_pickup_time ?? ""//"12:00 pm to 5:00 pm"
                    
                    let boldPart = "\(date) between \(time)"
                    let fullText = "Your appointment for the buyer to get his item is on \(boldPart)"

                    let attributedText = NSMutableAttributedString(string: fullText,
                                                                   attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                    if let range = fullText.range(of: boldPart) {
                        let nsRange = NSRange(range, in: fullText)
                        attributedText.addAttribute(.font,
                                                    value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                     range: nsRange)
                    }

                    self.infoDetailLbl.attributedText = attributedText
                    
                    self.firstFillBtn.title(title: "Change my address")
                    
                    let addressPickUpModel = prodcut?.addressPickUpModel
                    self.cityAddressLbl.text = (addressPickUpModel?.city ?? "" ) + ", " + (addressPickUpModel?.area ?? "" )
                    self.flatNoAddressLbl.text = (addressPickUpModel?.floor ?? "" ) + ", " + (addressPickUpModel?.street_address ?? "" )
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = true
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = false
                    self.addressBackView.isHidden = false
                    self.messageBackView.isHidden = true
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = true
                    
                    let dateString = date
                    if dateString.isTodayOrPastDate() {
                        print("It's today or a past date.")
                        self.firstFillBtn.tag = 801
                        self.secondEmptyBtn.tag = 802
                        setUpUI(.ChoosePickupData, .fourth, .Seller, .Pickup, data: data)
                        
                    } else {
                        print("It's a future date.")
                    }
                    
                    
                    // MARK: - Fourth step for seller in Pickup
                case .fourth:
                    
                    self.stepCountLbl.text = "Step 4"
                    self.stepCountImageView.image = UIImage(named: "PickupStep4")
                    
                    let boldPart = data.productDetails?.byuer_name ?? ""
                    let fullText = "You’ve pick up your article at \(boldPart)"

                    let attributedText = NSMutableAttributedString(string: fullText,
                                                                   attributes: [.font: UIFont(name: "Poppins-Regular", size: 14) ?? .systemFont(ofSize: 14)])

                    if let range = fullText.range(of: boldPart) {
                        let nsRange = NSRange(range, in: fullText)
                        attributedText.addAttribute(.font,
                                                    value: UIFont(name: "Poppins-SemiBold", size: 14) ?? .systemFont(ofSize: 14),
                                                     range: nsRange)
                    }

                    
                    
                    self.headingLbl.attributedText = attributedText
                    //"You’ve pick up your article at [buyer's name]"
                    
                    self.firstFillBtn.title(title: "Confirm pick up")
                    self.secondEmptyBtn.title(title: "Something is wrong")
                    
                    self.headingBackView.isHidden = false
                    self.productDetailBackView.isHidden = false
                    self.collectionBackView.isHidden = true
                    self.actionStatusBackView.isHidden = true
                    self.infoProviderBackView.isHidden = true
                    self.addressBackView.isHidden = true
                    self.messageBackView.isHidden = true
                    self.btnStackView.isHidden = false
                    self.firstFillBtn.isHidden = false
                    self.secondEmptyBtn.isHidden = false
                    
                default:
                    return
                }
            default:
                return
            }
        default:
            return
        }
    }
}

enum UserTypeChat {
    case Buyer
    case Seller
}

enum StepCount: Int {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
}

enum DeliveryType {
    case Delivery
    case Pickup
}


enum OrderStatusDeli  {
    case thanksForChoosing
    case ontheway
    case arrangePickUp
    case availabilityConfirm
    case confirmAvailability
    case ChoosePickupData
    case declined
    case waitingtoconfirmavailability
    case Pickup
    case confirmedAvailability
     
}

 

extension SellStepView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pickup_slots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as StepSlotsCVC
        let dic =  self.pickup_slots?[indexPath.row]
        cell.dateLbl.text = dic?.date ?? ""
        cell.timeLbl.text = dic?.time_slot ?? ""
        
        // Set selection state based on index tracking
            cell.selectedSlotCell = (selectedPickupSlots?.time_slot == ( (dic?.time_slot ?? "")) && (selectedPickupSlots?.date == (dic?.date ?? "")) )

        
        cell.setSelected()
        
        // Prevent duplicate gestures by removing existing ones
        cell.backView.gestureRecognizers?.forEach { cell.backView.removeGestureRecognizer($0) }
        
        // Add tap gesture for backView
       // cell.backView.isUserInteractionEnabled = true
       // cell.backView.tag = indexPath.row
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slotSelected(_:)))
       // cell.backView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 400
        let height = 100
        return CGSize(width: 100, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if let dic =  self.pickup_slots?[indexPath.row]{
            selectedPickupSlots=(dic)
        }
        collectionView.reloadData()
    }
    
   /* @objc func slotSelected(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let index = view.tag

        if selectedPickupSlots.contains(index) {
            selectedPickupSlots.remove(index)
        } else {
            selectedPickupSlots.insert(index)
        }

        UIView.performWithoutAnimation {
            self.slotsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }*/
}



import Foundation

extension String {
    func isTodayOrPastDate(format: String = "yyyy-MM-dd") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current

        guard let inputDate = dateFormatter.date(from: self) else {
            return false // Invalid date string
        }

        // Get today's date with time stripped
        let today = Calendar.current.startOfDay(for: Date())
        let inputDay = Calendar.current.startOfDay(for: inputDate)

        return inputDay <= today
    }
}

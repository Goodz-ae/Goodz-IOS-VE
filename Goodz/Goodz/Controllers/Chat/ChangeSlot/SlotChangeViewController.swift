//
//  SlotChangeViewController.swift
//  Goodz
//
//  Created by Dipesh Sisodiya on 28/05/25.
//

import UIKit

class SlotChangeViewController: BaseVC {
    @IBOutlet weak var titleLab :  UILabel!
    @IBOutlet weak var secondButtonL  :  UILabel!
    @IBOutlet weak var collectinView :  UICollectionView!
    
    @IBOutlet weak var collectionViewHeight :  NSLayoutConstraint!
    var completion: ((Pickup_slots?) -> Void)?
    var pickup_slots : [Pickup_slots]?
    
    @IBOutlet weak var saveButton :  UIButton!
    @IBOutlet weak var moreButton :  UIButton!
    var selectedPickupSlots : Pickup_slots?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectinView.delegate = self
        self.collectinView.dataSource = self
        self.collectinView.registerReusableCell(StepSlotsCVC.self)
        uiUpdate()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectinView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        DispatchQueue.main.async {
            self.collectinView.reloadData()
             
        }
        
    }
    
    func uiUpdate(){
        self.titleLab.font(font: .bold, size: .size14)
        
        self.saveButton.font(font: .medium, size: .size16)
        self.saveButton.color(color: .themeGreen)

        secondButtonL.font(font: .medium, size: .size16)
        self.moreButton.font(font: .medium, size: .size16)
        self.moreButton.color(color: .themeGreen)
        //secondButtonL.color(color: .themeGreen)
    }
    
    @IBAction func saveAction(_ sender : UIButton! ){
        if selectedPickupSlots == nil {
            self.showSimpleAlert(Message: "Please select slots")
            return
        }
        completion?(selectedPickupSlots )
        self.coordinator?.dismissVC()
    }
    
    @IBAction func chooseMore(_sender : UIButton! ){
         
         
        
    }
    
    @IBAction func cancelA(_sender : UIButton! ){
        
        self.coordinator?.dismissVC()
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let collectionView = object as? UICollectionView {
            if collectionView == self.collectinView {
                self.collectionViewHeight.constant = self.collectinView.contentSize.height
                view.layoutIfNeeded()
            }
        }
        
    }
    
    // --------------------------------------------
    
    override func viewWillDisappear(_ animated: Bool) {
        self.collectinView.removeObserver(self, forKeyPath: "contentSize")
       
    }
}
extension SlotChangeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pickup_slots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as StepSlotsCVC
        let dic =  self.pickup_slots?[indexPath.row]
        cell.dateLbl.text = dic?.date ?? ""
        cell.timeLbl.text = dic?.time_slot ?? ""
        
        // Set selection state based on index tracking
        cell.selectedSlotCell = ((selectedPickupSlots?.id == (dic?.id ?? 0) ) && (selectedPickupSlots?.date == (dic?.date ?? "")  ) )

        
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
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
            return 10
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
            return 5
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*let width = 400
         let height = 100
         return CGSize(width: width, height: height)
         */
        let wid = (collectionView.frame.size.width) // Default width
        
        return CGSize(width: (wid/2)-10, height:   70)
        
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

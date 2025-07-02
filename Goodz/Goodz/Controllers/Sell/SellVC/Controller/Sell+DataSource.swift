//
//  Sell+DataSource.swift
//  Goodz
//
//  Created by Priyanka Poojara on 15/12/23.
//

import UIKit

// MARK: CollectionView DataSource Methods
extension SellVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clvAddPhoto:
            return arrMedia.count
        case clvTypeOfDelivery:
            return self.viewModel.numberOfDeliveryType()
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case clvAddPhoto:
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
            let cell = collectionView.dequeueReusableCell(for: indexPath) as DocumentCell
            let data = arrMedia[indexPath.row]
            
            if data.mediaType == "" || data.mediaType == nil {
                cell.viewCover.isHidden = true
                //if indexPath.row == 0 {     cell.imgFirst.image = .ivAddPhoto } else {cell.imgFirst.image = UIImage(named: data.dymyImg ?? "" )}
                cell.imgFirst.image = UIImage(named: data.dymyImg ?? "" )
                cell.ivDocument.border(borderWidth: 0, borderColor: .clear)
                cell.ivCross.isHidden = true
                cell.ivDocument.isHidden = true
                cell.imgFirst.isHidden = false
                 
                
            } else {
                cell.viewCover.isHidden = defaultCover == indexPath.row ? false : true
                cell.setMedia(data: data)
            }
            
            
            cell.btnDeleteImage.tag = indexPath.item
            cell.btnDeleteImage.addTarget(self, action: #selector(btnDeleteImageAction), for: .touchUpInside)
            return cell
        case clvTypeOfDelivery:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as DeliveryTypesCell
            let data = self.viewModel.setDeliveryType(row: indexPath.row)
            cell.setData(data: data)
            cell.ivCheck.isHidden = self.selectedDeliveryType == indexPath.row ? false : true
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // Re Order Funcation
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case clvAddPhoto:
            let data = arrMedia[indexPath.row]
            
            if data.mediaType == "" || data.mediaType == nil {
                return false
            }
            return  true
        default :
            return false
        }
    }
    //collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath : IndexPath , to destinationIndexPath : IndexPath){
        switch collectionView {
        case clvAddPhoto:
            
            
            let data = arrMedia[destinationIndexPath.row]
            
            if data.mediaType == "" || data.mediaType == nil {
                collectionView.reloadData()
            }else {
                let item  = arrMedia.remove(at: sourceIndexPath.row)
                arrMedia.insert(item, at: destinationIndexPath.row )
            }
            break;
        default : break
        }
    }
    
    @objc func btnDeleteImageAction(_ sender : UIButton) {
        if sender.tag == 0 || sender.tag >= self.arrMedia.count {
            return
        }
        notifier.showLoader()
        let data = self.arrMedia[sender.tag]
        let progressBlock: progressBlock = { progress in
            print("Upload progress: \(progress * 100)%")
        }
        
        let completion: completionBlockBool = { isSuccess, msg, error in
            if let isSuccess = isSuccess {
                if isSuccess {
                    // Success
                    if let msg = msg {
                        print("Success: \(msg)")
                    } else {
                        print("Success")
                    }
                    DispatchQueue.main.async {
                        print(sender.tag)
                        print(self.arrMedia.count)
                        self.arrMedia.remove(at: sender.tag)
                        self.toAddDummy(at_delete: sender.tag)
                        self.clvAddPhoto.reloadData()
                        notifier.hideLoader()
                    }
                } else {
                    // Failure
                    notifier.hideLoader()
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("Unknown error")
                    }
                }
            } else {
                notifier.hideLoader()
                print("Unknown result")
            }
        }
        let type : FileType = data.mediaType == "1" ? .image : .video
        if let url = data.productMediaURL {
            API_S3.delete(strUrl: url, folder: .productImage, contentType: type, progress: progressBlock, completion: completion)
        }
        
       /* self.viewModel.sellItemDeleteMediaAPI(mediaType: data.mediaType ?? "", mediaName: data.productMediaName ?? "") { isDone in
            if isDone {
                self.arrMedia.remove(at: sender.tag)
                self.clvAddPhoto.reloadData()
            }
        }*/
    }
    
    func toAddDummy(at_delete index : Int){
        if (0...5).contains(index) {
            
            let dummys = [SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "" ),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "" , dymyImg: "imgFront"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgBack"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "img34"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgDegault"),SellItemUploadMediaModel(productMediaURL: "", productMediaName: "", mediaType: "", dymyImg: "imgSide")]
            arrMedia.insert(dummys[index], at: index)
            clvAddPhoto.reloadData()
        }
    }
}

// MARK: TableView DataSource Methods
extension SellVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tbvProductInfo:
            return arrCategoryItems.count
        case tbvDeliveryMethods:
            return self.viewModel.numberOfRows()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        switch tableView {
        case tbvProductInfo:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MyAccountCell
            let data = arrCategoryItems[indexPath.row]
            let row = self.arrCategoryItems.count
            cell.selectionStyle = .none
            
            switch data {
            case .brand:
                cell.lblDescription.text = self.brand?.brandTitle ?? ""
            case .condition:
                cell.lblDescription.text = self.condition?.conditionTitle ?? ""
            case .category:
                let main = self.categoryMain?.categoriesMainTitle ?? ""
                let sub = self.categorySub?.categoriesSubTitle ?? ""
                let collection = self.categoryCollection?.categoryCollectionTitle ?? ""
                if main.isEmpty && sub.isEmpty && collection.isEmpty {
                    cell.lblDescription.text = ""
                } else {
                    cell.lblDescription.text = "\(main)/\(sub)/\(collection)"
                }
            }
            
            cell.setProductTypeData(data: data, lastRow: row, currentRow: indexPath.row)
            return cell
        case tbvDeliveryMethods:
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as DeliveryMethodViewCell
            let data = self.viewModel.setCondition(row: indexPath.row)
            cell.selectionStyle = .none
//            cell.ivCheckBox.image = self.selectedDeliveryMethod == indexPath.row ? .icCheckboxSqr : .iconUncheckBox
            cell.lblDeliveryMethod.text = data.title
            
            let commonId = Set(self.viewModel.arrDeliveryMethods.compactMap { $0.deliveryMethodID })
                .intersection(Set(self.arrSelectedDeliveryMethod.compactMap { $0.deliveryMethodID }))
            if let categoriesSubId = data.deliveryMethodID, commonId.contains(categoriesSubId) {
                cell.ivCheckBox.image = .icCheckboxSqr.withRenderingMode(.alwaysTemplate)
                if indexPath.row == 0 {
                    cell.ivCheckBox.tintColor = .themeGray
                }else{
                    cell.ivCheckBox.tintColor = .themeGreen
                }
            } else {
                cell.ivCheckBox.image = .iconUncheckBox
            }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

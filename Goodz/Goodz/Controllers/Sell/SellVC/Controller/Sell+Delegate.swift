//
//  Sell+Delegate.swift
//  Goodz
//
//  Created by Priyanka Poojara on 15/12/23.
//

import UIKit
import AVFoundation
import FacebookShare
import Photos
import Alamofire
import MobileCoreServices

// MARK: CollectionView Delegate Methods
extension SellVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func fetchImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options) { (image, _) in
            completion(image)
        }
    }
    
    func removeDumyAt0(){
        let index = arrMedia.firstIndex { item in
            item.dymyImg != "ivAddPhoto"  && item.dymyImg != nil && (item.mediaType == "" || item.mediaType == nil)
        }
        if let _ind =  index   {
            arrMedia.remove(at: _ind )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case clvAddPhoto:
            if indexPath.row != 0 {
                defaultCover = indexPath.row
            }
            
            if indexPath.row == 0 {
                let totalCurrentCount = arrMedia.count
                if totalCurrentCount > 10 {
                    notifier.showToast(message: "you can upload to max 10 pictures and videos")
                    return
                } else {
                    
                    AttachmentHandler.shared.showAttachmentActionSheet(type: [.camera, .multpleSelection, .video], vc: self, count: 10 - (totalCurrentCount - 1))
                    AttachmentHandler.shared.imagePickedBlock = { img, url in
                        notifier.showLoader()
                        
                        self.setCameraImageUpload(img: img, url : url)
                        
                    }
                    AttachmentHandler.shared.multiple = { [self] (arrImg) in
                        notifier.showLoader()
                        if arrImg.count > 0 {
                            var imgs = arrImg
                            if totalCurrentCount < 2 {
                                self.backgroundRemove(asset: imgs[0]) { img in
                                    if let imageRo = img {
                                        self.mulitpleImageUpload(img: imageRo)
                                    } else {
                                        self.mulitpleImageUpload(phImg: imgs[0])
                                    }
                                    imgs.remove(at: 0)
                                    
                                    for i  in 0..<imgs.count {
                                        self.mulitpleImageUpload(phImg: imgs[i])
                                    }
                                }
                            } else {
                                for i  in 0..<imgs.count {
                                    self.mulitpleImageUpload(phImg: imgs[i])
                                }
                            }
                        } else {
                            notifier.hideLoader()
                        }
                    }
                    
                    AttachmentHandler.shared.videoPickedBlock = { [self] videoURL in
                        notifier.showLoader()
                        uploadVideo(url: videoURL as URL)
                    }
                }
            }
            collectionView.reloadData()
            
        case clvTypeOfDelivery:
            self.selectedDeliveryType = indexPath.row
            self.clvTypeOfDelivery.reloadData()
        default: break
        }
    }
    
    // --------------------------------------------
    
    func setCameraImageUpload(img : UIImage? = nil, url : URL? = nil) {
        // Define a common progress block
        let progressBlock: progressBlock = { progress in
            print("Upload progress: \(progress * 100)%")
        }
        
        // Define a common completion block
        let completionBlock: completionBlock = { url, fileName, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Upload successful!")
                if let url = url, let fileName = fileName {
                    print("URL: \(url)")
                    print("File Name: \(fileName)")
                    if self.arrMedia.count < 11 {
                        print(self.arrMedia.count, ":::", url)
                         
                        self.removeDumyAt0()
                        self.arrMedia.insert(SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "1"), at: 1)
                        //self.arrMedia.append(SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "1"))
                        DispatchQueue.main.async {
                            self.clvAddPhoto.reloadData()
                        }
                    }
                }
            }
            notifier.hideLoader()
        }
        
        if self.arrMedia.count == 1 {
            // If only one item in the array, remove background and upload
            self.backgroundRemove(img: url?.description ?? "") { removeBG in
                if let img = removeBG {
                    API_S3.uploadImage(image: removeBG ?? UIImage(), folder: .productImage, progress: progressBlock, completion: completionBlock)
                } else {
                    API_S3.uploadImage(image: img ?? UIImage(), folder: .productImage, progress: progressBlock, completion: completionBlock)
                }
            }
        } else {
            // Upload directly
            API_S3.uploadImage(image: img ?? UIImage(), folder: .productImage, progress: progressBlock, completion: completionBlock)
        }
        
    }
    // --------------------------------------------
     
    func uploadVideo(url : URL) {
        let progressBlock: progressBlock = { progress in
            print("Upload progress: \(progress * 100)%")
        }
        
        let completionBlock: completionBlock = { url, fileName, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Upload successful!")
                if let url = url {
                    print("URL: \(url)")
                }
                if let fileName = fileName {
                    print("File Name: \(fileName)")
                }
                
                if self.arrMedia.count < 11 {
                    self.removeDumyAt0()
                    self.arrMedia.insert((SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "2")), at: 1)
                    //self.arrMedia.append(SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "2"))
                    DispatchQueue.main.async {
                        print("Jigz ------------------------------------------------\n")
                        self.clvAddPhoto.reloadData()
                        
                    }
                }
            }
            notifier.hideLoader()
        }
        API_S3.uploadDocument(fileUrl: url, folder: .productImage, progress: progressBlock, completion: completionBlock)
    }
    
    // --------------------------------------------
    
    func mulitpleImageUpload(phImg: PHAsset? = nil, img : UIImage? = nil) {
        let progressBlock: progressBlock = { progress in
            print("Upload progress: \(progress * 100)%")
        }
        
        let completionBlock: completionBlock = { url, fileName, error in
            if let error = error {
                print("Error: \(error)")
                notifier.hideLoader()
            } else {
                print("Upload successful!")
                if let url = url {
                    print("URL: \(url)")
                }
                if let fileName = fileName {
                    print("File Name: \(fileName)")
                }
                
                if self.arrMedia.count < 11 {
                    
                    self.removeDumyAt0()
                    self.arrMedia.insert(SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "1"), at: 1)
                   // self.arrMedia.append(SellItemUploadMediaModel(productMediaURL: url, productMediaName: fileName, mediaType: "1"))
                }
                
                DispatchQueue.main.async {
                    notifier.hideLoader()
                    print("Jigz ------------------------------------------------\n")
                    self.clvAddPhoto.reloadData()
                }
            }
            
        }
        if let img = phImg {
            self.fetchImage(for: img) { image in
                guard let image = image else {
                    print("Failed to retrieve image from PHAsset")
                    return
                }
                print("🟪🟪🟪🟪" + self.arrMedia.count.description)
                // Upload directly
                API_S3.uploadImage(image: image, folder: .productImage, progress: progressBlock, completion: completionBlock)
            }
        } else {
            if let photo = img {
                API_S3.uploadImage(image: photo, folder: .productImage, progress: progressBlock, completion: completionBlock)
            }
        }
        
    }
    
    // --------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case clvAddPhoto:
            let size = (self.clvAddPhoto.frame.size.width / 3) - 10
            return CGSize(width: size, height: size)
        case clvTypeOfDelivery:
            return CGSize(width: 100, height: 100)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func convertHEICtoJPEG(heicURL: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: heicURL) else {
            return nil
        }
        guard let ciImage = CIImage(data: imageData), let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func backgroundRemove(img: String?, completion: @escaping (UIImage?) -> Void) {
        guard let url = img else {
            completion(nil)
            return
        }
        print(img)
        AF.upload(multipartFormData: { multipartFormData in
            if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl) {
                multipartFormData.append(imageData, withName: "image_file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
        }, to: "https://api.remove.bg/v1.0/removebg", headers: ["X-Api-Key": bgRemoverKey])
        .responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
   
    func backgroundRemove(asset: PHAsset?, completion: @escaping (UIImage?) -> Void) {
        guard let asset = asset else {
            completion(nil)
            return
        }
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true // Make sure to load the image synchronously
        
        imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions) { (image, info) in
            if let image = image,
               let imageData = image.jpegData(compressionQuality: 1.0) { // Convert image to JPEG data
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData, withName: "image_file", fileName: "image.jpg", mimeType: "image/jpeg")
                }, to: "https://api.remove.bg/v1.0/removebg", headers: ["X-Api-Key": bgRemoverKey])//
                .responseData { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            completion(image)
                        } else {
                            completion(nil)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }


    
    
    func saveImageToFile(image: UIImage) -> String? {
        // Get the documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Generate a unique filename
        let filename = UUID().uuidString
        
        // Append filename to documents directory
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        // Convert image to JPEG format and write to file
        do {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try data.write(to: fileURL)
                return fileURL.path
            }
        } catch {
            print("Error saving image: \(error)")
        }
        
        return nil
    }
    
    func assetToLocalURL(asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true // Allow access even if the asset is stored in iCloud
        
        if asset.mediaType == .image {
            PHImageManager.default().requestImageData(for: asset, options: nil) { (data, _, _, _) in
                guard let imageData = data else {
                    completion(nil)
                    return
                }
                let temporaryDirectory = FileManager.default.temporaryDirectory
                let imageURL = temporaryDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
                do {
                    try imageData.write(to: imageURL)
                    completion(imageURL)
                } catch {
                    completion(nil)
                }
            }
        } else if asset.mediaType == .video {
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
                guard let avAsset = avAsset as? AVURLAsset else {
                    completion(nil)
                    return
                }
                completion(avAsset.url)
            }
        } else {
            completion(nil)
        }
    }
    
}

// MARK: TableView Delegate Methods
extension SellVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tbvProductInfo:
            let data = arrCategoryItems[indexPath.row]
            switch data {
            case .brand:
                self.coordinator?.navigateToBrands(selectedBrands: [], isMultipleSelection: false, id: self.brand?.brandID ?? "") { brands in
                    self.brand = brands?.first
                    self.tbvProductInfo.reloadData()
                }
            case .condition:
                self.coordinator?.navigateToCondition(selectedConditions: [], isMultipleSelection: false, id: self.condition?.conditionID ?? "") { condition in
                    self.condition = condition?.first
                }
            case .category:
                self.coordinator?.navigateToSuperCategoryList(openType: .comeFromSell, title: Labels.categories) { [self] categoryMainData, categorySubData, categoryCollectionData in
                    self.categoryMain = categoryMainData
                    self.categorySub = categorySubData
                    self.categoryCollection = categoryCollectionData
                    self.tbvProductInfo.reloadData()
                }
            }
            
        case tbvDeliveryMethods:
            let selectedRow = self.viewModel.setCondition(row: indexPath.row)
            if let index = self.arrSelectedDeliveryMethod.firstIndex(where: { $0.deliveryMethodID == selectedRow.deliveryMethodID }) {
                if index != 0 {
                    self.arrSelectedDeliveryMethod.remove(at: index)
                }
            } else {
                self.arrSelectedDeliveryMethod.append(selectedRow)
            }
            self.tbvDeliveryMethods.reloadData()
            
        default: break
        }
    }
}

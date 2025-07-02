//
//  PHImagePickerVC.swift
//  Goodz
//
//  Created by Akruti on 14/05/24.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import PDFKit
import QuickLookThumbnailing
import PhotosUI

class PhotoLibraryCell : UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
class PHImagePickerVC: UIViewController {
    
    // --------------------------------------------
    // MARK: - Outlets
    // --------------------------------------------
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var colImages: UICollectionView!
    
    // --------------------------------------------
    // MARK: - Custom variables
    // --------------------------------------------
    
    var delegate: PHImagePickerControllerDelegate?
    var selectedAssets: [PHAsset] = []
    var allowsMultipleSelection: Bool = false
    var assetsFetchResult: PHFetchResult<PHAsset>?
    var imageManager: PHCachingImageManager?
    
    // --------------------------------------------
    // MARK: - Life cycle methods
    // --------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
    }
    
    // --------------------------------------------
    // MARK: - Cutom methods
    // --------------------------------------------
    
    func applyStyle() {
        
        self.colImages.delegate = self
        self.colImages.dataSource = self
        self.colImages.backgroundColor = .white
        
        self.btnNext.setTitle("Next", for: .normal)
        self.btnCancel.setTitle("Cancel", for: .normal)
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.setupPhotoLibrary()
                } else {
                    self.dismiss()
                }
            }
        }
        
    }
    
    // --------------------------------------------
    
    private func setupPhotoLibrary() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.assetsFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        self.imageManager = PHCachingImageManager()
        DispatchQueue.main.async {
            self.colImages.reloadData()
        }
        
    }
    
    // --------------------------------------------
    
    func didSelectAsset(_ asset: PHAsset) {
        selectedAssets.append(asset)
    }
    
    // --------------------------------------------
    
    func finishSelection() {
        delegate?.imagePickerController(self, didFinishPickingAssets: selectedAssets)
    }
    
    // --------------------------------------------
    
    func clearSelection() {
        selectedAssets.removeAll()
    }
    
    // --------------------------------------------
    // MARK: - Actions
    // --------------------------------------------
    
    @IBAction func btnCancleTapped(_ sender: Any) {
        self.dismiss()
    }
    @IBAction func btnNextTapped(_ sender: Any) {
        finishSelection()
        self.dismiss()
    }
    
}

extension PHImagePickerVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetsFetchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCell", for: indexPath) as! PhotoLibraryCell
        
        if let asset = assetsFetchResult?[indexPath.item] {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            cell.img?.backgroundColor = .red
            imageManager?.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions, resultHandler: { image, _ in
                cell.img?.image = image
            })
            if selectedAssets.contains(asset) {
                cell.imgSelect.image = .iconCheckSquare
                print("select")
            } else {
                cell.imgSelect.image = UIImage()
                print("deselect")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = assetsFetchResult?[indexPath.item] {
                    if selectedAssets.contains(asset) {
                        if let index = selectedAssets.firstIndex(of: asset) {
                            selectedAssets.remove(at: index)
                        }
                    } else {
                        if selectedAssets.count < 10 {
                            selectedAssets.append(asset)
                        }
                    }
                }
        self.colImages.reloadData()
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


protocol PHImagePickerControllerDelegate: AnyObject {
        func imagePickerController(_ picker: PHImagePickerVC, didFinishPickingAssets assets: [PHAsset])
}

//
//  AttachmentHandler.swift
//  Goodz
//
//  Created by Priyanka Poojara on 18/12/23.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import PDFKit
import QuickLookThumbnailing
import PhotosUI
import BSImagePicker


class AttachmentHandler: NSObject, PHImagePickerControllerDelegate {
    func imagePickerController(_ picker: PHImagePickerVC, didFinishPickingAssets assets: [PHAsset]) {
        multiple?(assets)
        
    }
    
    
    
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    
    // MARK: Internal Properties
    var imagePickedBlock: ((UIImage,URL?) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((FileType, URL, UIImage?) -> Void)?
    var multiple : (([PHAsset]) -> Void)?
    var delegate: PHImagePickerControllerDelegate?
    var arrAttachType : [AttachType] = [.camera, .phoneLibrary, .video, .file, .multpleSelection]
    var arrFileType : [FileType] = [.pdf]
    var isMultiple : Bool = false
    enum AttachmentType: String {
        
        case camera, video, photoLibrary
    }
    
    // MARK: Constants
    struct Constants {
        
        static let actionFileTypeHeading : String = Labels.addAFile
        static let actionFileTypeDescription : String = Labels.chooseAfiletypeToAdd
        static let camera : String = Labels.camera
        static let phoneLibrary : String  = Labels.phoneLibrary
        static let video : String = Labels.video
        static let file : String = Labels.file
        static let alertForPhotoLibraryMessage : String =  Labels.appDoesNotHaveAccessToYourPhotosToEnableAccessTapSettingsAndTurnOnPhotoLibraryAccess
        static let alertForCameraAccessMessage : String  = Labels.AppDoesNotHaveAccessToYourCameraToEnableAccessTapSettingsAndTurnOnCamera
        
        static let alertForVideoLibraryMessage : String  = Labels.AppDoesNotHaveAccessToYourVideoToEnableAccessTapSettingsAndTurnOnVideoLibraryAccess
        static let settingsBtnTitle : String  = Labels.settings
        static let cancelBtnTitle : String  = Labels.cancel
        
    }
    
    // MARK: showAttachmentActionSheet
    //  This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(type: [AttachType], vc: UIViewController, count: Int? = nil) {
        print(type)
        currentVC = vc
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: IS_IPAD ? .alert : .actionSheet)
        
        if type.contains(.camera) {
            actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
            }))
        }
        
        if type.contains(.phoneLibrary) {
            self.isMultiple = false
            actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
            }))
        }
        
        if type.contains(.video) {
            
            actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
                
            }))
        }
        
        if type.contains(.file) {
            
            actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
                self.documentPicker()
            }))
        }
        
        if type.contains(.multpleSelection) {
            self.isMultiple = true
            actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!, count: count)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        actionSheet.popoverPresentationController?.sourceView = vc.view
        DispatchQueue.main.async {
            vc.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showAttachmentCameraAction(vc: UIViewController) {
        
        currentVC = vc
        self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
    }
    
    func showAttachmentPhotoLibraryAction(vc: UIViewController) {
        
        currentVC = vc
        self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
    }
    
    func showAttachmentVideoAction(maxDurationSecond: Int? = nil, vc: UIViewController) {
        
        currentVC = vc
        self.maxDurationSecond = maxDurationSecond
        self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
    }
    
    func showAttachmentFileAction(type: [FileType], vc: UIViewController) {
        
        self.arrFileType = type
        
        currentVC = vc
        self.documentPicker()
    }
    
    //  MARK: Authorisation Status
    //  This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    //  if the user gives access, then we can import the data safely
    //  if not show them alert to access from settings.
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController, count: Int? = nil) {
        
        currentVC = vc
        
        if attachmentTypeEnum == .camera {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch status {
            case .authorized:
                
                DispatchQueue.main.async {
                    self.openCamera()
                }
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("Permission Not Determined")
                
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                    if status {
                        //  photo library access given
                        print("access given")
                        
                        DispatchQueue.main.async {
                            self.openCamera()
                        }
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
                
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        } else if attachmentTypeEnum == .video {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch status {
            case .authorized:
                
                DispatchQueue.main.async {
                    self.videoLibrary()
                }
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("Permission Not Determined")
                
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                    if status {
                        //  photo library access given
                        print("access given")
                        
                        DispatchQueue.main.async {
                            self.videoLibrary()
                        }
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
                
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        } else if attachmentTypeEnum == .photoLibrary {
            
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                
                DispatchQueue.main.async {
                    if let count = count {
                        self.showBSImagePicker(vc: self.currentVC!, count: count)
                    }else{
                        self.photoLibrary()
                    }
                }
                
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("Permission Not Determined")
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        //  photo library access given
                        print("access given")
                        DispatchQueue.main.async {
                            if let count = count {
                                self.showBSImagePicker(vc: self.currentVC!, count: count)
                            }else{
                                self.photoLibrary()
                            }
                        }
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                })
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        }
        
    }
    
    func getAttachmentPermissionStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController, completion: @escaping (Bool) -> ()) {
        
        currentVC = vc
        
        if attachmentTypeEnum == .camera {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch status {
            case .authorized:
                
                completion(true)
                
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("Permission Not Determined")
                
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                    if status {
                        //  photo library access given
                        print("access given")
                        
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
                
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        } else if attachmentTypeEnum == .video {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch status {
            case .authorized:
                
                completion(true)
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
            case .notDetermined:
                print("Permission Not Determined")
                
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                    if status {
                        //  photo library access given
                        print("access given")
                        
                        completion(true)
                        
                    } else {
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
                
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        } else if attachmentTypeEnum == .photoLibrary {
            
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                
                completion(true)
                
            case .denied:
                print("permission denied")
                self.addAlertForSettings(attachmentTypeEnum)
                
            case .notDetermined:
                print("Permission Not Determined")
                PHPhotoLibrary.requestAuthorization({ (status) in
                    
                    if status == PHAuthorizationStatus.authorized {
                        //  photo library access given
                        print("access given")
                        
                        completion(true)
                        
                    } else {
                        
                        print("restriced manually")
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                })
            case .restricted:
                print("permission restricted")
                self.addAlertForSettings(attachmentTypeEnum)
            default:
                break
            }
            
        }
        
    }
    
    // MARK: CAMERA PICKER
    // This function is used to open camera from the iphone and
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            DispatchQueue.main.async {
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.isEditing = true
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: PHOTO PICKER
    func photoLibrary() {
        // Check the authorization status for accessing the photo library
        if isMultiple {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                // If authorization is granted, present the photo picker
                DispatchQueue.main.async {
                    let picker = PHImagePickerVC()
                    // Configure the picker delegate
                    picker.delegate = self
                    // Present the picker with multiple selection enabled
                    self.currentVC?.present(picker, animated: true, completion: nil)
                }
            case .notDetermined:
                // If authorization status is not determined, request authorization
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        // If authorization is granted, present the photo picker
                        DispatchQueue.main.async {
                            let picker = PHImagePickerVC()
                            // Configure the picker delegate
                            picker.delegate = self
                            // Present the picker with multiple selection enabled
                            self.currentVC?.present(picker, animated: true, completion: nil)
                        }
                    } else {
                        // Handle denied or restricted authorization
                    }
                }
            case .denied, .restricted:
                // Handle denied or restricted authorization
                // You can show an alert or take appropriate action here
                break
            @unknown default:
                // Handle other unknown cases if needed
                break
            }
        } else {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                DispatchQueue.main.async {
                    
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = .photoLibrary
                    myPickerController.allowsEditing = false
                    self.currentVC?.present(myPickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: VIDEO PICKER
    var maxDurationSecond: Int? = nil
    func videoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            DispatchQueue.main.async {
                
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                myPickerController.allowsEditing = true
                myPickerController.videoMaximumDuration = 10.0
                
                if self.maxDurationSecond != nil && self.maxDurationSecond! > 0 {
                    myPickerController.videoMaximumDuration = TimeInterval(self.maxDurationSecond!)
                }
                
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: FILE PICKER
    func documentPicker() {
        
        DispatchQueue.main.async {
            
            var arrFinalFileType = [String]()
            
            if !(arrFinalFileType.contains(String(UTType.pdf.identifier))) && (self.arrFileType.contains(.pdf)) {
                arrFinalFileType.append(String(UTType.pdf.identifier))
            }
            
            if !(arrFinalFileType.contains(String("com.microsoft.word.doc"))) && (self.arrFileType.contains(.document)) {
                arrFinalFileType.append(String("com.microsoft.word.doc"))
            }
            
            if !(arrFinalFileType.contains(String(UTType.audio.identifier))) && self.arrFileType.contains(.audio) {
                arrFinalFileType.append(String(UTType.audio.identifier))
            }
            
            if !(arrFinalFileType.contains(String("com.pkware.zip-archive"))) && self.arrFileType.contains(.zip) {
                arrFinalFileType.append(String("com.pkware.zip-archive"))
            }
            
            if !(arrFinalFileType.contains(String(UTType.archive.identifier))) && self.arrFileType.contains(.rar) {
                arrFinalFileType.append(String(UTType.archive.identifier))
            }
            
            if (!(arrFinalFileType.contains(String(UTType.plainText.identifier))) && self.arrFileType.contains(.txt)) || (!(arrFinalFileType.contains(String(UTType.text.identifier))) && (self.arrFileType.contains(.text))) {
                arrFinalFileType.append(String(UTType.plainText.identifier))
                arrFinalFileType.append(String(UTType.text.identifier))
            }
            
            if !(arrFinalFileType.contains(String(UTType.rtf.identifier))) && (self.arrFileType.contains(.rtf)) {
                arrFinalFileType.append(String(UTType.rtf.identifier))
            }
            
            let importMenu = UIDocumentPickerViewController(documentTypes: arrFinalFileType, in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .fullScreen
            importMenu.modalTransitionStyle = .crossDissolve
            self.currentVC?.present(importMenu, animated: true, completion: nil)
        }
    }
    
    // MARK: SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera {
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary {
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video {
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        
        DispatchQueue.main.async {
            
            let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
            cameraUnavailableAlertController .addAction(cancelAction)
            cameraUnavailableAlertController .addAction(settingsAction)
            self.currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
    
    //MARK: - BSImagePicker
    func showBSImagePicker(vc: UIViewController, count: Int) {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = count
        imagePicker.settings.selection.unselectOnReachingMax = true
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        vc.presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset.
        }, deselect: { (asset) in
            // User deselected an asset.
        }, cancel: { (assets) in
            // User canceled.
        }, finish: { (assets) in
            // User finished selection.
            self.getImages(from: assets, completion: { images, urls in
                self.multiple?(assets)
                
            })
        })
    }
    
    func getImages(from assets: [PHAsset], completion: @escaping ([UIImage], [URL]?) -> Void) {
        var images: [UIImage] = []
        var urls: [URL] = []
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        let dispatchGroup = DispatchGroup()
        
        for asset in assets {
            dispatchGroup.enter()
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: options) { (image, _) in
                if let image = image {
                    images.append(image)
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            
            let resourceOptions = PHContentEditingInputRequestOptions()
            resourceOptions.isNetworkAccessAllowed = true
            asset.requestContentEditingInput(with: resourceOptions) { (contentEditingInput, _) in
                if let fileURL = contentEditingInput?.fullSizeImageURL {
                    urls.append(fileURL)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(images, urls.isEmpty ? nil : urls)
        }
    }
}

// MARK: IMAGE PICKER DELEGATE
//  This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let image = info[.originalImage] as? UIImage ?? info[.originalImage] as? UIImage {
            if let imageURL = info[.imageURL] as? URL {
                self.imagePickedBlock?(image, imageURL)
                print("fileUrl.lastPathComponent", imageURL.lastPathComponent) //  get file Name
                print("fileUrl.pathExtension", imageURL.pathExtension)
            } else {
                // Create a URL for the image
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let uniqueFilename = UUID().uuidString + ".jpg"
                    let fileURL = documentsURL.appendingPathComponent(uniqueFilename)
                    
                    do {
                        try imageData.write(to: fileURL)
                        self.imagePickedBlock?(image, fileURL)
                    } catch {
                        print("Error writing image to file URL:", error)
                    }
                }
            }
        }
        // Handle video
        if let videoUrl = info[.mediaURL] as? URL {
            print("videourl: ", videoUrl)
            // trying compression of video
            let data = try! Data(contentsOf: videoUrl)
            print("File size before compression: \(Double(data.count / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl as NSURL)
        } else {
            // print("Something went wrong in  video")
        }
        currentVC?.dismiss(animated: true, completion: nil)
    }

    
    // MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
                
            default:
                break
            }
        }
    }
    
    //  Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        
        exportSession.exportAsynchronously { () -> Void in
            
            handler(exportSession)
        }
    }
}

// MARK: FILE IMPORT DELEGATE
extension AttachmentHandler: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        
        DispatchQueue.main.async {
            
            self.currentVC?.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        
        let strExt: String = (URL(fileURLWithPath: url.absoluteString).pathExtension)
        // let strExtWithDot: String = "." + (URL(fileURLWithPath: url.absoluteString).pathExtension)
        
        var thumbImage: UIImage? = nil
        let fileType = FileType(rawValue: strExt) ?? .none
        
        if fileType == .pdf {
            thumbImage = self.getPdfThumbnail(url: url)
        } else if fileType == .document {
            thumbImage = self.getDocThumbnail(url: url)
        }
        
        self.filePickedBlock?(fileType ?? .document, url, thumbImage)
    }
    
    // Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getDocThumbnail(url: URL) -> UIImage? {
        
        let controller = UIDocumentInteractionController(url: url)
        
        return controller.icons.first
    }
    
    func getPdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        
        guard let data = try? Data(contentsOf: url), let page = PDFDocument(data: data)?.page(at: 0) else {
            return nil
        }
        
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = width / pageSize.width
        
        //  Apply if you're displaying the thumbnail on screen
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale, height: pageSize.height * scale)
        
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }
}

//
//  AWSS3Helper.swift
//
//
//  Created by vtadmin on 10/01/22.
//

import Foundation
import UIKit
import AVFoundation
import AWSS3
 
let API_S3 = AWSS3Manager.shared

enum S3_Folder : String {
     case productImage
     case none
     var title: String {
          switch self {
          case .productImage:
               return "upload/product/"
          case .none:
               return "none"
          }
     }
}


class AWSS3Manager {
    
    // REMOVE THIS only =    +++++++-----
    
    //    let s3_URL : String = "https://goodzstag.s3.eu-west-2.amazonaws.com/"
    let S3_BUCKET_NAME : String = "" //"good+++++++-----zstag"
    //    let S3_ACCESS_KEY : String = "AKIAYQY+++++++-----UBGM74MHOII4I"
    //    let S3_ACCESS_KEY : String = "AKIAYQYU+++++++-----BGM76KLFBB3U"
    let S3_ACCESS_KEY : String = ""//"AKIAYQYUBGM7+++++++-----SSESOYFT"
    //    let S3_SECRET_KEY : String = "+C9AWf5xkpusg+++++++-----7wlpkdWUq4MWVWPwXPfjTT5+6yl"
    //    let S3_SECRET_KEY : String = "BRq7r4ipeS7OCuf3+++++++-----9EMWxK3yxCFYxLOP9A9FNpJG"
    let S3_SECRET_KEY : String = ""//"UwsJP+s1MAnosB4x2m+++++++-----RHBlHtVKOuxUMoiXgz9eZe"  +++++++-----
    let S3_REGION_TYPE : AWSRegionType = .EUWest2
    
    static let shared = AWSS3Manager()
    private init() { }
    
    func initializeS3() {
        let credentialProvider = AWSStaticCredentialsProvider(accessKey: self.S3_ACCESS_KEY, secretKey: self.S3_SECRET_KEY)
        let awsConfiguration = AWSServiceConfiguration(region: self.S3_REGION_TYPE, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awsConfiguration
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    // Upload image using UIImage object
    func uploadImage(image: UIImage, fileName: String = "", folder: S3_Folder, progress: progressBlock?, completion: completionBlock?) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, nil,error.localizedDescription)
            return
        }
        
        var strName = ""
        let gid = generateCurrentTimeStamp()
        let tmpPath = NSTemporaryDirectory() as String
        if strName == "" {
            strName = "\(fileName)" + gid + (".jpeg")
        }
        
        let filePath = tmpPath + "/" + strName
        let fileUrl = URL(fileURLWithPath: filePath)
        
        do {
            try imageData.write(to: fileUrl)
            self.uploadfile(fileUrl: fileUrl, fileName: strName, folder: folder, contenType: .image, progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, nil, error.localizedDescription)
        }
    }
    
    
    // Upload Document using UIImage object
    func uploadDocument(fileUrl: URL, fileName: String = "", folder: S3_Folder, progress: progressBlock?, completion: completionBlock?) {
        
        var strName = ""
        let gid = generateCurrentTimeStamp()
        let tmpPath = NSTemporaryDirectory() as String
        
        let strExtension = fileUrl.pathExtension
        
        if strName == "" {
            strName = "\(fileName)" + gid + (".\(strExtension)")
        }
        self.uploadfile(fileUrl: fileUrl, fileName: strName, folder: folder, contenType: FileType(rawValue: strExtension) ?? .document, progress: progress, completion: completion)
    }
    
    
    func delete(strUrl: String, folder: S3_Folder, contentType: FileType, progress: progressBlock?, completion: completionBlockBool?) {
        if let url = URL(string: strUrl.replacingOccurrences(of: " ", with: "%20")){
            let fileName = url.lastPathComponent
            self.deleteFile( fileName: fileName, folder: folder, contenType: contentType, progress: progress, completion: completion)
        }
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    
    private func uploadfile(fileUrl: URL, fileName: String, folder: S3_Folder, contenType: FileType, progress: progressBlock?, completion: completionBlock?) {
        
        let newKey = ((folder == .none) ? "" : folder.title) + fileName
        
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            
            guard let uploadProgress = progress else { return }
            
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.S3_BUCKET_NAME).appendingPathComponent(newKey)
                    
                    debugPrint("S3 UPLOADED URL 🏞️ 🏞️ 🏞️ 🏞️ 🏞️:- \(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, fileName, nil)
                    } else {
                        debugPrint("issue is here.. ❌ ❌ ❌ ❌ ❌")
                    }
                    
                } else {
                    
                    if let completionBlock = completion {
                        completionBlock(nil, nil, error?.localizedDescription)
                    } else {
                        debugPrint("issue is here.. ❌ ❌ ❌ ❌ ❌")
                    }
                }
            })
        }
        
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        
        awsTransferUtility.uploadFile(fileUrl, bucket: self.S3_BUCKET_NAME, key: newKey, contentType: contenType.rawValue, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            
            if let error = task.error {
                debugPrint("S3 ERROR:- ❌ ❌ ❌ ❌ ❌ : \(error.localizedDescription)")
            }
            if let res = task.result {
                // your uploadTask
                
                debugPrint(res)
                
            }
            return nil
        }
    }
    
    private func deleteFile(fileName: String, folder: S3_Folder, contenType: FileType, progress: progressBlock?, completion: completionBlockBool?) {
        
        let awsS3 = AWSS3.default()
        guard let deleteRequest = AWSS3DeleteObjectRequest() else {
            return
        }
        
        deleteRequest.bucket = S3_BUCKET_NAME
        deleteRequest.key = String(format: "%@%@", folder.title , fileName)
        
        awsS3.deleteObject(deleteRequest).continueWith { (task:AWSTask) -> Any? in
            if let error = task.error {
                debugPrint("Error occurred: \(error)")
                return completion?(false,error.localizedDescription,error.localizedDescription)
            }else{
                debugPrint("🧰 🧰 🧰 🧰 🧰 Deleted successfully.")
                return completion?(true,"😈😈😈😈😈Deleted successfully","")
            }
        }
        
    }
    
    
    private func uploadVideofile(fileUrl: URL, fileName: String, videoFolder: S3_Folder, videoThumbFolder: S3_Folder, contenType: FileType, progress: progressVideoBlock?, completion: completionVideoBlock?) {
        
        let newKey = ((videoFolder == .none) ? "" : videoFolder.title) + fileName
        
        func finalUploadVideo(fileUrl: URL, fileName: String, videoFolder: S3_Folder, thumbFileName: String?, contenType: FileType, vidProgress: progressVideoBlock?, vidCompletion: completionVideoBlock?) {
            
            // Upload progress block
            let expression = AWSS3TransferUtilityUploadExpression()
            expression.progressBlock = {(task, awsProgress) in
                
                guard let uploadProgress = vidProgress else { return }
                
                DispatchQueue.main.async {
                    uploadProgress(.Video, awsProgress.fractionCompleted)
                }
            }
            
            // Completion block
            var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
            completionHandler = { (task, error) -> Void in
                
                DispatchQueue.main.async(execute: {
                    
                    if error == nil {
                        
                        let url = AWSS3.default().configuration.endpoint.url
                        let publicURL = url?.appendingPathComponent(self.S3_BUCKET_NAME).appendingPathComponent(newKey)
                        
                        debugPrint("S3 UPLOADED URL 🌄 🌄 🌄 🌄 🌄 :- \(String(describing: publicURL))")
                        if let completionBlock = vidCompletion {
                            completionBlock(publicURL?.absoluteString, fileName, thumbFileName, nil)
                        }
                        
                    } else {
                        
                        if let completionBlock = vidCompletion {
                            completionBlock(nil, nil, nil, error?.localizedDescription)
                        }
                    }
                })
            }
            
            // Start uploading using AWSS3TransferUtility
            let awsTransferUtility = AWSS3TransferUtility.default()
            
            awsTransferUtility.uploadFile(fileUrl, bucket: self.S3_BUCKET_NAME, key: newKey, contentType: contenType.rawValue, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
                
                if let error = task.error {
                    debugPrint("S3 ERROR:-: \(error.localizedDescription)")
                }
                if let _ = task.result {
                    // your uploadTask
                }
                return nil
            }
        }
        
        self.getVideoThumbFromUrl(fileUrl: fileUrl) { (thumbImage) in
            if thumbImage == nil {
                finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: nil, contenType: contenType, vidProgress: progress, vidCompletion: completion)
            } else {
                API_S3.uploadImage(image: thumbImage!, folder: videoThumbFolder, progress: { (progressImage) in
                    debugPrint("S3 UPLOAD THUMB:- ",Float(progressImage))
                    guard let uploadProgress = progress else { return }
                    DispatchQueue.main.async {
                        uploadProgress(.VideoThumb, progressImage)
                    }
                }, completion: { (uploadedFileUrl, uploadedFileName, error) in
                    if let thumbFileUrl = uploadedFileUrl, let thumbFileName = uploadedFileName {
                        debugPrint("S3 UPLOADED THUMB URL:- ",thumbFileUrl)
                        debugPrint("S3 UPLOADED THUMB NAME:- ",thumbFileName)
                        finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: thumbFileName, contenType: contenType, vidProgress: progress, vidCompletion: completion)
                    } else {
                        debugPrint("S3 UPLOAD THUMB ERROR:- ",error ?? "ERROR THUMB")
                        finalUploadVideo(fileUrl: fileUrl, fileName: fileName, videoFolder: videoFolder, thumbFileName: nil, contenType: contenType, vidProgress: progress, vidCompletion: completion)
                    }
                })
            }
        }
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL, contentType: FileType) -> String {
        
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        
        var head = ""
        switch contentType {
            
        case .image:
            head = "IMAGE_"
            break;
        case .audio:
            head = "AUDIO_"
            break;
        case .video:
            head = "VIDEO_"
            break;
        case .document:
            head = "DOC_"
            break;
        case .pdf:
            head = "PDF_"
            break;
        case .zip:
            head = "ZIP_"
            break;
        case .rar:
            head = "RAR_"
            break;
        case .txt:
            head = "TXT_"
            break;
        case .text:
            head = "TEXT_"
            break;
        case .rtf:
            head = "RTF_"
            break;
        default:
            head = "FILE_"
            break;
        }
        
        let stamp = Int(TimeInterval(Date().timeIntervalSince1970))
        return (head+"\(stamp)" + (strExt))
    }
    
    
    func getVideoThumbFromUrl(fileUrl: URL, completion: @escaping ((_ thumbImage: UIImage?)->Void)) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: fileUrl)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMakeWithSeconds(1, preferredTimescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    debugPrint("THUMBNAIL:- DONE")
                    completion(thumbImage)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    debugPrint("THUMBNAIL:- FAILED")
                    completion(nil)
                }
            }
        }
    }
}


typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlockBool = (_ IsSuccess : Bool?, _ msg : String?, _ error: String?) -> Void
typealias completionBlock = (_ url: String?, _ fileName: String?, _ error: String?) -> Void
typealias progressVideoBlock = (_ progressType: ProgressType, _ progress: Double) -> Void
typealias completionVideoBlock = (_ url: String?, _ fileName: String?, _ thumbfileName: String?, _ error: String?) -> Void

enum ProgressType : String {
     
     case VideoThumb = "VideoThumb"
     case Video = "Video"
}


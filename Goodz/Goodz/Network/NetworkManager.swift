//
//   NetworkManager.swift
//   Goodz
//
//   Created by Priyanka Poojara on 25/09/23.
//

import UIKit
import Alamofire
import Network

final class NetworkManager {
    
    //  Making the Class Singleton
    private init() {
        
    }
    
    /// Defining the session manager object with session configurations for the HTTP session
    private static let manager: Session = { () -> Session in
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        //  configuration.httpAdditionalHeaders = Session.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Session(configuration: configuration)
        //  let requestRet = NetworkRequestRetrier()
        //  sessionManager.retrier = requestRet
        return sessionManager
    }()
    
}

extension NetworkManager : NetworkProtocol {
    
    //  Confroming and providing definition of first protocol containing codable type of result
    static func dataRequest<T>(with request: RouterProtocol, responseModel: T.Type, isGetIpAddress: Bool = false, completionHandler: @escaping (Swift.Result<(T?), NetworkError>) -> Void) where T : Decodable {
        
        // Check if device is connected to network or not
        if !(NetworkReachabilityManager()!.isReachable) {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.internetError)))
            return
        }
        
        // Get Request object of the Given Router
        do {
            _ = try request.asURLRequest()
        } catch {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
            return
        }
        
        var apiURL : String {
            if let queryParams = request.queryParameters {
                
                var str = ""
                for key in queryParams.keys {
                    if str.isEmpty {
                        str = "?\(key)=\(queryParams[key]!)"
                    } else {
                        str += "&\(key)=\(queryParams[key]!)"
                    }
                }
                return  isGetIpAddress ? request.ipAddressBaseUrlString : (request.baseUrlString + request.endpoint + str)
            } else {
                return isGetIpAddress ? request.ipAddressBaseUrlString :  (request.baseUrlString + request.endpoint)
            }
            
        }
        print("APIURL", apiURL)
        AF.request(apiURL, method: request.method, parameters: request.parameters, encoding: JSONEncoding.prettyPrinted, headers: HTTPHeaders(request.headers ?? [:])).responseData { (response) in
            
            let req = response.request
            print("\n--------------☘️☘️☘️", request.endpoint.capitalized,"☘️☘️☘️--------------")
            print("API CALLED 🌏: ", req?.url?.absoluteString ?? "")
            print("Parameters 🧰 : ", request.parameters ?? "")
            print("\n------------------------------")
            let resp = response.response
            let result = response.result
            //            _ = String(data: response.data!, encoding: .utf8)
            let error = response.error as NSError?
            
            let finalResponseData: Data? = response.data
            
            // Checking if response data is not null
            if let data = finalResponseData {
                
                // Decode the response if status code is 200
                if response.response?.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        
                        // decoding the response data in define model
                        let decodedValue = try decoder.decode(responseModel, from: data)
                        
                        let responseValue = try? decoder.decode([ResponseModelOne].self, from: data)
                        if responseValue?.first?.code == "-2" || responseValue?.first?.code == "-3" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: appLANG.retrive(label: responseValue?.first?.message ?? ""), okAction: { _ in
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                        } else if responseValue?.first?.code == "-4" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: Labels.somethingWentWrongPleaseLoginAgain, okAction: { _ in
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                        } else {
                            print("VALID TOKEN")
                            completionHandler(.success((decodedValue)))
                        }
                        
                        
                        print("---------------DECODED-RESPONSE---------------\n")
                        
                        if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data ?? Data()) as? [[String:Any]] {
                            if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data!) as? [[String:Any]] {
                                print("RESPONSE Json Data:- ", jsonDictionary)
                            } else {
                                print("RESPONSE JSON Data:- ", response.response)
                            }
                            
                        } else {
                            print("RESPONSE:- \(response.debugDescription)")

                        }
                        
                    } catch let err {
                        
                        // complete the request with error if decoding is failed
                        print("Error 😡: \(err)")
                        completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.invalidDataFormat)))
                    }
                } else {
                    
                    do {
                        let decoder = JSONDecoder()
                        print("---Failed HTTP Request----")
                        print(request.arrayParameters as Any)
                        print(request.headers as Any)
                        print(response.response as Any)
                        // decoding the response data in define model
                        let decodedValue = try decoder.decode(Response<JSONNull>.self, from: data)
                        print(decodedValue)
                        completionHandler(.failure(.requestError(errorMessage: decodedValue.message)))
                        
                    } catch _ {
                        
                        // Status code is not 200 complete the block with status code error
                        completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkManager.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0))))
                    }
                    
                }
                
            } else {
                
                // Status code is not 200 complete the block with status code error
                completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.networkTimeout)))
            }
        }
        
    }
    
    static func rawDataRequest<T>(with request: RouterProtocol, rawData: Data?, responseModel: T.Type, completionHandler: @escaping (Swift.Result<(T?), NetworkError>) -> Void) where T : Decodable {
        
        // Check if device is connected to network or not
        if !(NetworkReachabilityManager()!.isReachable) {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.internetError)))
            return
        }
        
        // Get Request object of the Given Router
        do {
            _ = try request.asURLRequest()
        } catch {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
            return
        }
        
        var apiURL : String {
            if let queryParams = request.queryParameters {
                
                var str = ""
                for key in queryParams.keys {
                    if str.isEmpty {
                        str = "?\(key)=\(queryParams[key]!)"
                    } else {
                        str += "&\(key)=\(queryParams[key]!)"
                    }
                }
                return request.baseUrlString + request.endpoint + str
            } else {
                return request.baseUrlString + request.endpoint
            }
        }
        
        guard var urlreq = try? URLRequest(url: apiURL, method: request.method, headers: HTTPHeaders(request.headers ?? [:])) else {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
            return
        }
        
        urlreq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlreq.httpBody = rawData
        
        AF.request(urlreq).responseData { (response) in
//        AF.request(apiURL, method: request.method, parameters: request.parameters, encoding: JSONEncoding.prettyPrinted, headers: HTTPHeaders(request.headers ?? [:])).responseData { (response) in
        
            
            let req = response.request
            print("\n--------------☘️☘️☘️", request.endpoint.capitalized,"☘️☘️☘️--------------")
            print("API CALLED 🌏: ", req?.url?.absoluteString ?? "")
            print("Parameters 🧰 : ", request.parameters ?? "")
            print("\n------------------------------")
            let resp = response.response
            let result = response.result
            //            _ = String(data: response.data!, encoding: .utf8)
            let error = response.error as NSError?
            
            let finalResponseData: Data? = response.data
            
            // Checking if response data is not null
            if let data = finalResponseData {
                
                // Decode the response if status code is 200
                if response.response?.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        
                        // decoding the response data in define model
                        let decodedValue = try decoder.decode(responseModel, from: data)
                        
                        let responseValue = try? decoder.decode([ResponseModelOne].self, from: data)
                        if responseValue?.first?.code == "-2" || responseValue?.first?.code == "-3" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: appLANG.retrive(label: responseValue?.first?.message ?? ""), okAction: { _ in
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                        } else if responseValue?.first?.code == "-4" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: Labels.somethingWentWrongPleaseLoginAgain, okAction: { _ in
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                        } else {
                            print("VALID TOKEN")
                            completionHandler(.success((decodedValue)))
                        }
                        
                        print("---------------DECODED-RESPONSE---------------\n")
                        
                        if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data ?? Data()) as? [[String:Any]] {
                            if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data!) as? [[String:Any]] {
                                print("RESPONSE Json Data:- ", jsonDictionary)
                            } else {
                                print("RESPONSE JSON Data:- ", response.response)
                            }
                            
                        } else {
                            print("RESPONSE:- \(response.debugDescription)")

                        }
                        
                    } catch let err {
                        
                        // complete the request with error if decoding is failed
                        print("Error 😡: \(err)")
                        completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.invalidDataFormat)))
                    }
                } else {
                    
                    do {
                        let decoder = JSONDecoder()
                        print("---Failed HTTP Request----")
                        print(request.arrayParameters as Any)
                        print(request.headers as Any)
                        print(response.response as Any)
                        // decoding the response data in define model
                        let decodedValue = try decoder.decode(Response<JSONNull>.self, from: data)
                        print(decodedValue)
                        completionHandler(.failure(.requestError(errorMessage: decodedValue.message)))
                        
                    } catch _ {
                        
                        // Status code is not 200 complete the block with status code error
                        completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkManager.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0))))
                    }
                    
                }
                
            } else {
                
                // Status code is not 200 complete the block with status code error
                completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.networkTimeout)))
            }
        }
        
    }
    
    static func multiFormDataRequest<T>(with request: RouterProtocol, responseModel: T.Type, completionHandler: @escaping (Swift.Result<(T?), NetworkError>) -> Void) where T : Decodable {
        
        // Check if device is connected to network or not
        if !(NetworkReachabilityManager()!.isReachable) {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.internetError)))
            return
        }
        
        // Get Request object of the Given Router
        do {
            _ = try request.asURLRequest()
        } catch {
            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
            return
        }
        
        var apiURL : String {
            
            if let queryParams = request.queryParameters {
                
                var str = ""
                for key in queryParams.keys {
                    if str.isEmpty {
                        str = "?\(key)=\(queryParams[key]!)"
                    } else {
                        str += "&\(key)=\(queryParams[key]!)"
                    }
                }
                
                if let prettyJsonData = try? JSONSerialization.data(withJSONObject: queryParams, options: [.prettyPrinted]) {
                    print("PARAM:- \(String(data: prettyJsonData, encoding: .utf8)?.toJSON() ?? "-")")
                } else {
                    print("PARAM:- \(queryParams)")
                }
                
                if let request = request.urlRequest?.cURL(pretty: false) {
                    print("Request cURL API: \n" + request)
                }
                
                return request.baseUrlString + request.endpoint + str
            } else {
                return request.baseUrlString + request.endpoint
            }
            
        }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in request.parameters ?? [:] {
                if let image = value as? UIImage {
                    let imageData = image.jpeg(.low)
                    let itemName = String(format: "ios\(Int(NSDate().timeIntervalSince1970)).jpeg")
                    multipartFormData.append(imageData ?? Data(), withName: key, fileName: itemName, mimeType: "image/jpeg")
                    
                } else if let upUrl = value as? URL {
                    
                    do {
                        
                        let upData = try Data(contentsOf: upUrl)
                        let pathExtension = upUrl.pathExtension
                        
                        let itemName = String(format: "ios\(Int(NSDate().timeIntervalSince1970)).\(pathExtension)")
                        multipartFormData.append(upData, withName: key, fileName: itemName, mimeType: "application/\(pathExtension)")
                        
                    } catch {
                        print("Unable to upData data: \(error)")
                    }
                } else {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            
        }, to: URL(string: apiURL)!,
                  usingThreshold: UInt64.init(),
                  method: .post,
                  headers: HTTPHeaders(request.headers ?? [:]),
                  interceptor: nil,
                  fileManager: FileManager.default)
        
        .uploadProgress { progress in
            print("RESPONSE:- Upload Progress: ",progress.fractionCompleted)
        }
        .downloadProgress { progress in
            print("RESPONSE:- Download Progress: ",progress.fractionCompleted)
        }
        .responseData { (response) in
            
            let req = response.request
            
            print("\n--------------☘️☘️☘️", request.endpoint.capitalized,"☘️☘️☘️--------------")
            print("API CALLED 🌏: ", req?.url?.absoluteString ?? "")
            print("Parameters 🧰 : ", request.parameters ?? "")
            print("\n------------------------------")
            
            let resp = response.response
            let result = response.result
            //            _ = String(data: response.data!, encoding: .utf8)
            
            let error = response.error as NSError?
            
            let finalResponseData: Data? = response.data
            
            // Checking if response data is not null
            if let data = finalResponseData {
                
                // Decode the response if status code is 200
                if response.response?.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        
                        // decoding the response data in define model
                        let decodedValue = try decoder.decode(responseModel, from: data)
                        
                        let responseValue = try? decoder.decode([ResponseModelOne].self, from: data)
                        if responseValue?.first?.code == "-2" || responseValue?.first?.code == "-3" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: appLANG.retrive(label: responseValue?.first?.message ?? ""), okAction: { _ in
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                        } else if responseValue?.first?.code == "-4" {
                            print("INVALID TOKEN")
                            
                            AF.cancelAllRequests()
                            notifier.hideLoader()
                            if !appDelegate.isShowInvalidTokenAlert {
                                appDelegate.isShowInvalidTokenAlert = true
                                notifier.showAlert(title: Labels.goodz, message: Labels.somethingWentWrongPleaseLoginAgain, okAction: { _ in
                                    
                                    appDelegate.isShowInvalidTokenAlert = false
                                    UserDefaults.standard.clearUserDefaults()
                                    appDelegate.coordinator?.navigateToLoginVC()
                                    appDelegate.setLogin()
                                })
                            }
                            completionHandler(.success((nil)))
                            
                        } else {
                            print("VALID TOKEN")
                            completionHandler(.success((decodedValue)))
                        }
                        
                        
                        print("---------------DECODED-RESPONSE---------------\n")
                        
                        if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data ?? Data()) as? [String:Any] {
                            print("RESPONSE Data:- ", jsonDictionary)
                        
                            if let jsonDictionary = try? JSONSerialization.jsonObject(with: response.data!) as? [String:Any] {
                                print("RESPONSE Json Data:- ", jsonDictionary)
                            } else {
                                print("RESPONSE JSON Data:- ", response.response)
                            }
                            
                        } else {
                            print("RESPONSE:- \(response.debugDescription)")

                        }
                        
                        } catch let err {
                            
                            // complete the request with error if decoding is failed
                            print("Error 😡: \(err)")
                            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.invalidDataFormat)))
                        }
                    } else {
                        
                        do {
                            let decoder = JSONDecoder()
                            print("---Failed HTTP Request----")
                            print(request.arrayParameters as Any)
                            print(request.headers as Any)
                            print(response.response as Any)
                            // decoding the response data in define model
                            let decodedValue = try decoder.decode(Response<JSONNull>.self, from: data)
                            print(decodedValue)
                            completionHandler(.failure(.requestError(errorMessage: decodedValue.message)))
                            
                        } catch _ {
                            
                            // Status code is not 200 complete the block with status code error
                            completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkManager.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0))))
                        }
                        
                    }
                    
                } else {
                    
                    // Status code is not 200 complete the block with status code error
                    completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.networkTimeout)))
                }
            }
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success:
                        
                        print("RESPONSE URL:- ",response.request?.url ?? "-")
                        
                        let prettyJsonData = try! JSONSerialization.data(withJSONObject: response.value as Any, options: [.prettyPrinted])
                        print("RESPONSE:-")
                        print(String(data: prettyJsonData, encoding: .utf8) ?? "-")
                        
                        //                completion(response.value as AnyObject, response.data)
                        
                    case .failure:
                        
                        print("RESPONSE:- \(response.debugDescription)")
                        //                completion(nil, nil)
                        //                return
                    }
                }
        }
        
        // Confroming and providing definition of first protocol containing codable type of result
        static func formDataRequest<T>(with request: RouterProtocol, responseModel: T.Type, completionHandler: @escaping (Swift.Result<(T?), NetworkError>) -> Void) where T : Decodable {
            
            // Check if device is connected to network or not
            if !(NetworkReachabilityManager()!.isReachable) {
                completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.internetError)))
                return
            }
            
            var urlRequest : URLRequest = URLRequest(url: URL(string: request.baseUrlString)!)
            
            // Get Request object of the Given Router
            do {
                urlRequest = try request.asURLRequest()
            } catch {
                completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
                return
            }
            
            print(urlRequest)
            
            // If query params is passed change the main url and replace it with the embedded query parameteres
            if !(request.queryParameters?.isEmpty ?? true) {
                
                guard let url = urlRequest.url else {
                    completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.urlConversionError)))
                    return
                }
                
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    
                    if let queryParams = request.queryParameters {
                        
                        var queryParameters = [URLQueryItem]()
                        
                        for query in queryParams {
                            queryParameters.append(URLQueryItem(name: query.key, value: query.value))
                        }
                        
                        urlComponents.queryItems = queryParameters
                    }
                    
                    urlRequest.url = urlComponents.url
                }
                
            }
            
            /*
             // Initiating the Network request
             manager.upload(multipartFormData: { (multiPartData) in
             
             // If method is post pass parameters in multiPartData
             if request.method == .post {
             
             var reqParam = request.parameters ?? [String: Any]()
             
             // Pass device info along with the params
             if let deviceInfo = request.deviceInfo {
             reqParam = reqParam.merging(deviceInfo) { (_, new) in new }
             }
             
             // Create data of the given files and pass it to multipart
             if let files = request.files {
             for file in files {
             multiPartData.append(file.data, withName: file.paramKey, fileName: file.fileName, mimeType: file.mimeType)
             }
             }
             
             //  Appending the dev defined paramterers by converting the strings to data
             for (key, value) in reqParam {
             print("\(key) :: \(value)")
             multiPartData.append(((value as? String)?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)!)!, withName: key)
             }
             
             }
             
             }, usingThreshold: MultipartFormData.encodingMemoryThreshold, with: urlRequest) { (encodingResult) in
             switch encodingResult {
             case .success(let upload, _, _):
             
             print("API CALLED : ", upload.request?.url?.absoluteString ?? "")
             
             upload.uploadProgress(closure: { (progress) in
             //  Code here to handle the progress of the request
             })
             
             // fetching the response in Data
             upload.responseData(completionHandler: { (response) in
             _ = response.request
             let resp = response.response
             let result = response.result
             _ = String(data: response.data!, encoding: .utf8)
             let error = result.error as NSError?
             
             let finalResponseData: Data? = response.data
             
             // Checking if response data is not null
             if let data = finalResponseData {
             
             // Decode the response if status code is 200
             if response.response?.statusCode == 200{
             do {
             let decoder = JSONDecoder()
             
             // decoding the response data in define model
             let decodedValue = try decoder.decode(responseModel, from: data)
             
             completionHandler(.success((decodedValue)))
             
             } catch let err {
             
             // complete the request with error if decoding is failed
             print(err)
             completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.INVALID_FORM_OF_DATA)))
             }
             }else{
             
             do {
             let decoder = JSONDecoder()
             
             // decoding the response data in define model
             let decodedValue = try decoder.decode(Response<JSONNull>.self, from: data)
             
             completionHandler(.failure(.requestError(errorMessage: decodedValue.message)))
             
             } catch _ {
             
             // Status code is not 200 complete the block with status code error
             completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkManager.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0))))
             }
             
             }
             
             } else {
             
             // Status code is not 200 complete the block with status code error
             completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.NETWORK_TIMEOUT)))
             }
             })
             case .failure(let error):
             if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
             print("Time Out/Connection Lost Error")
             
             // complete block with connection lost error
             completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.NETWORK_TIMEOUT)))
             
             } else {
             
             completionHandler(.failure(NetworkError.requestError(errorMessage: NetworkAlertMessages.NETWORK_ERROR)))
             
             }
             }
             }
             */
            
            /*
             MARK: UTILI TRADE
             
             
             func api_POST_UPLOAD(task: String, param: [String : String], dictUpload: [String : Any], progressCompletion: @escaping (_ uploadProgress: Double?) -> Void, completion: @escaping (_ json: AnyObject?, _ data: Data?) -> Void) {
             
             let passParam = param
             
             if self.isDebug() {
             print("URL:- ",self.getBaseUrl() + task)
             print("HEADER:- ",self.getHeader())
             print("PARAM:- ",passParam)
             print("UPLOAD:- ",dictUpload)
             
             }
             
             AF.upload(multipartFormData: { (multipartFormData) in
             
             for (key, value) in dictUpload
             {
             let fileType = UploadFileType(rawValue: passParam["file_type"] ?? "") ?? .none
             
             if let upImage = value as? UIImage {
             let imageData = upImage.jpegData(compressionQuality: 1)
             let itemName = String(format: "ios\(Int(NSDate().timeIntervalSince1970)).jpeg")
             multipartFormData.append(imageData ?? Data(), withName: key, fileName: itemName, mimeType: "image/jpeg")
             
             } else if let upImage = value as? [UIImage] {
             for img in upImage {
             if let imageData = img.jpegData(compressionQuality: 1)
             {
             let itemName = String(format: "ios\(Int(NSDate().timeIntervalSince1970)).jpeg")
             multipartFormData.append(imageData, withName: key, fileName: itemName, mimeType: "image/jpeg")
             }
             }
             
             } else if fileType == .document, let upUrl = value as? URL {
             
             do {
             
             let upData = try Data(contentsOf: upUrl)
             let pathExtension = upUrl.pathExtension
             
             let itemName = String(format: "ios\(Int(NSDate().timeIntervalSince1970)).\(pathExtension)")
             multipartFormData.append(upData, withName: key, fileName: itemName, mimeType: "application/\(pathExtension)")
             
             } catch {
             print("Unable to upData data: \(error)")
             }
             }
             
             }
             
             for (key, value) in passParam
             {
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }
             
             }, to: URL(string: self.getBaseUrl() + task)!,
             usingThreshold: UInt64.init(),
             method: .post,
             headers: HTTPHeaders(),
             interceptor: nil,
             fileManager: FileManager.default)
             
             .uploadProgress { progress in
             print("RESPONSE:- Upload Progress: ",progress.fractionCompleted)
             progressCompletion(progress.fractionCompleted)
             }
             .downloadProgress { progress in
             print("RESPONSE:- Download Progress: ",progress.fractionCompleted)
             }
             .responseJSON { response in
             
             switch response.result {
             
             case .success:
             
             print("RESPONSE URL:- ",response.request?.url ?? "-")
             
             let prettyJsonData = try! JSONSerialization.data(withJSONObject: response.value as Any, options: [.prettyPrinted])
             print("RESPONSE:-")
             print(String(data: prettyJsonData, encoding: .utf8) ?? "-")
             
             completion(response.value as AnyObject, response.data)
             
             case .failure:
             
             print("RESPONSE:- \(response.debugDescription)")
             completion(nil, nil)
             return
             }
             }
             }
             
             
             
             */
            
        }
        
        static func download(downloadURL : String, completion : @escaping ((Bool,String?,URL?) -> Void)) {
            if let fileUrl = self.getSaveFileUrl(fileName: downloadURL) {
                
                let destination: DownloadRequest.Destination = { _, _ in
                    return (fileUrl, [.removePreviousFile])
                }
                
                AF.download(downloadURL, to:destination)
                    .responseData { (data) in
                        // self.progressLabel.text = "Completed!"
                        
                        if data.error == nil && data.fileURL != nil {
                            completion(true,nil,data.fileURL)
                        } else {
                            completion(false,data.error?.localizedDescription,nil)
                        }
                        
                    }
            }
        }
        
    static func getSaveFileUrl(fileName: String) -> URL? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let nameUrl = URL(string: fileName) else {
            // Failed to create URL from fileName
            return nil
        }
        let fileURL = documentsURL.appendingPathComponent(nameUrl.lastPathComponent)
        NSLog(fileURL.absoluteString)
        return fileURL
    }

    
    }
    
    // MARK: - Error Class
    extension NetworkManager {
        
        // /This function will return the string message based on the error code
        class func errorMessageBasedOnStatusCode(_ code : Int) -> String {
            let afilepath = Bundle.main.path(forResource: "ErrorCode", ofType: "plist") // Getting error codes from plist file
            
            var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml // Format of the Property List.
            
            let plistXML = FileManager.default.contents(atPath: afilepath!)!
            
            var plistData: [String: Any] = [:] // Our data
            
            do {
                
                // convert the data to a dictionary and handle errors.
                plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:Any]
                
                var message = ""
                if let aRoot = plistData["ErrorCode"] as? [[String: Any]] {
                    if let error = aRoot.first(where: { $0["Code"] as? Int == code }) {
                        message = error["Message"] as? String ?? ""
                    }
                }
                
                handlerBasedOnStatusCode(code)
                
                return message
                
            } catch {
                print("error")
            }
            print("Error While Creating a Error message from status code")
            return NetworkAlertMessages.defaultError
        }
        
        // /This function will return the string message based on the error code
        class func handlerBasedOnStatusCode(_ code : Int) {
            switch code {
            case 401:
                print("[NetworkManager.swift 309] Unauthorised Request! Write Block to Logout the user directly.")
            default:
                break
            }
        }
        
    }

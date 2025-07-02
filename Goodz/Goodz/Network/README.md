# NetworkManager
NetworkManager is a Lightweight and Powerful networking library written in Swift Language. and builds on the top of Alamofire which will help you to reduce your time and efforts given in coding the same lines again and again for the Network HTTP API Calls for the app.

### USAGE
To properly use the Network manager you have to define the request by creating an `enum` conforming to `RouterProtocol`. by conforming to it you have to add all the protocol stubs which are needed to create a proper request.

##### Making a Request using Router
below is shown an example of creating the HTTP request by conforming to `RouterProtocol`
``` swift
enum SampleRouter : RouterProtocol {
    
    //return the base url string here for this router
    var baseUrlString: String{
        // return www.google.com/api/v1/user/
        return AppConstants.AppEnvironment.SERVER_URL + AppConstants.AppEnvironment.SERVER_VERSION
    }
    
    //Apis provided by the router
    case apiFunction1
    case apiFunction2(_ param1 : String, _ param2 : String) //API with parameter

    //define method for API
    var method: HTTPMethod{
        switch self {
        case .apiFunction1:
            return .get
        case .apiFunction2:
            return .post
        }
    }
    
    //define the service-name/endpoint of api
    var path: String{
        switch self {
        case .apiFunction1:
            return "func1"
        case .apiFunction2:
            return "func2"
        }
    }
    
    //define parameters to be passed with request
    var parameters: [String : Any]?{
        switch self{
        case .apiFunction1:
            return nil
        case .apiFunction2(let para1, let para2):
            return [
                "aPara1" : para1,
                "aPara2" : para2
            ]
        }
    }
    
    //This should be default as
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.httpBody
    }
    
    //define the headers need to be passed with request
    var headers: [String : String]?{
        return [
            "Accept":"application/json",
        ]
    }
    
    //Files to upload with the request
    var files: [MultiPartData]?{
        return nil
    }
    
    //This should be default in case of passing device info to apis
    var deviceInfo: [String : Any]?{
        return APIDeviceInfo.aDeviceInfo
    }
    
}

```

##### Making a HTTP API call
Now we will use the router we created to make the API call.

**Syntax**:
```swift
    /// Make a HTTP Request and Get HTTP Response
    /// - parameter request : provide an enum case confroming to RouterProtocol
    /// - parameter responseModel : provide class or structure with model of type Codable
    /// - parameter completionHandler : This is a completion block of the request once the request is completed and response is recieved this block will be called.
    /// - Note : Completion Handler : This block will return a Result Type. This Result type will have two cases
    /// 1. success : This case will return the response decoded in model provided
    /// 2. failure : This case will return the Network Error containig error message describing the error
    NetworkManager.dataRequest(with: <#T##RouterProtocol#>, responseModel: <#T##Decodable.Protocol#>, completionHandler: <#T##(Result<(Decodable?), NetworkError>) -> Void#>)
```
**Example**:
```swift
NetworkManager.dataRequest(with: SampleRouter.apiFunction1, responseModel: Response<Datum>.self) { (Result) in
            
            switch Result{
            case .success(let response):
                print(response!)
                
            case .failure(let err):
                print(err.erroMessage())
                
            }
            
        }
```

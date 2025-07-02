//
//  NetworkRequestRetrier.swift
//  Goodz
//
//  Created by Priyanka Poojara on 06/11/23.
//

import Foundation
import Alamofire

/*
public protocol RequestInterceptor: RequestAdapter, RequestRetrier {}

extension RequestInterceptor {
    
}
*/

/*
class NetworkRequestRetrier: RequestRetrier {

    let retry = 3 // set the count for number of retries
    
    // [Request url: Number of times retried]
    private var retriedRequests: [String: Int] = [:]
    
    func should(_ manager: Session, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        
        guard
            request.task?.response == nil,
            let url = request.request?.url?.absoluteString
            else {
                removeCachedUrlRequest(url: request.request?.url?.absoluteString)
                completion(false, 0.0) // don't retry
                return
        }
        
        let  errorGenerated = error as NSError
        switch errorGenerated.code {
        case -1001, -1005 :
            guard let retryCount = retriedRequests[url] else {
                retriedRequests[url] = 1
                completion(true, 0.5) // retry after 0.5 second
                return
            }
            
            if retryCount < retry { // check remaining retries available
                retriedRequests[url] = retryCount + 1
                completion(true, 0.5) // retry after 0.5 second
            } else {
                removeCachedUrlRequest(url: url)
                completion(false, 0.0) // don't retry
            }
            
        default:
            removeCachedUrlRequest(url: url)
            completion(false, 0.0)
        }
    }
    
    // removes requests completed
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
}
*/

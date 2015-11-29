//
//  QiitaAPI.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

let QiitaBaseURL = "http://qiita.com/"

class QiitaAPI {
    
    class func call<T: RequestProtocol>(request: T, completion: Result<T.ResponseType, NSError> -> Void) {
        
        Alamofire.request(request.method, request.URLString, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
            .progress { progress -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            .validate()
            .response(queue: nil, responseSerializer: request.responseSerializer) { response -> Void in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let successValue = response.result.value where response.result.isSuccess {
                    completion(.Success(successValue))
                    return
                }
                
                completion(.Failure(response.result.error!))
                
            }
        
    }
    
}

protocol RequestProtocol {
    
    typealias ResponseType
    
    var method: Alamofire.Method { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: AnyObject]? { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var cachePolicy: NSURLRequestCachePolicy { get }
    var responseSerializer: ResponseSerializer<ResponseType, NSError> { get }
    
}

extension RequestProtocol {
    
    var method: Alamofire.Method {
        return .GET
    }
    
    var baseURL: String {
        return QiitaBaseURL
    }
    
    var URLString: String {
        return baseURL + path
    }
    
    var encoding: ParameterEncoding {
        return .URL
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var cachePolicy: NSURLRequestCachePolicy {
        return .ReloadIgnoringLocalCacheData
    }
    
    var URLRequest: NSURLRequest {
        let request = NSMutableURLRequest()
        request.HTTPMethod = method.rawValue
        request.URL = NSURL(string: URLString)
        request.cachePolicy = cachePolicy
        encoding.encode(request, parameters: parameters)
        setHeaders(request, headers: headers)
        return request
    }
    
    private func setHeaders(mutableURLRequest: NSMutableURLRequest, headers: [String: String]?) {
        guard let headers = headers else {
            return
        }
        for (field, value) in headers {
            mutableURLRequest.setValue(value, forKey: field)
        }
    }
    
}

extension RequestProtocol where ResponseType: Mappable {
    
    var responseSerializer: ResponseSerializer<ResponseType, NSError> {
        
        return ResponseSerializer<ResponseType, NSError> { request, response, data, error -> Result<ResponseType, NSError> in
            
            let resultJson = Alamofire.Request.JSONResponseSerializer().serializeResponse(request, response, data, error)
            if let error = resultJson.error {
                return .Failure(error)
            }
            guard let object = Mapper<ResponseType>().map(resultJson.value) else {
                return .Failure(NSError(domain: "com.hachinobu.qiitaclient", code: -1000, userInfo: [NSLocalizedFailureReasonErrorKey: "Mapping Error"]))
            }
            
            return .Success(object)
            
        }
        
    }
    
}



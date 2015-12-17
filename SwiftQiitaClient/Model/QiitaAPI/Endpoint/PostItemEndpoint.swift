//
//  PostItemEndpoint.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension QiitaAPI {
    
    class AllPostItemList: RequestProtocol {
        
        typealias ResponseType = AllPostItemListModel
        var path: String = "/api/v2/items"
        var parameters: [String: AnyObject]?
        
        init(parameters: [String: AnyObject]?) {
            self.parameters = parameters
        }
        
        var responseSerializer: ResponseSerializer<ResponseType, NSError> {
            
            return ResponseSerializer<ResponseType, NSError> { request, response, data, error -> Result<ResponseType, NSError> in
                
                let resultJson = Alamofire.Request.JSONResponseSerializer().serializeResponse(request, response, data, error)
                if let error = resultJson.error {
                    return .Failure(error)
                }
                
                guard let object = Mapper<PostItemModel>().mapArray(resultJson.value) else {
                    return .Failure(NSError(domain: "com.hachinobu.qiitaclient", code: -1000, userInfo: [NSLocalizedFailureReasonErrorKey: "Mapping Error"]))
                }
                
                let postItemList = AllPostItemListModel(postItems: object)
                return .Success(postItemList)
                
            }
            
        }
        
    }
    
    class PostItemDetail: RequestProtocol {
        
        typealias ResponseType = PostItemModel
        var path: String = "/api/v2/items/"
        
        init(itemId: String) {
            path += itemId
        }
        
    }
    
    
}
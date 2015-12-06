//
//  StockEndpoint.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

extension QiitaAPI {
    
    class GetStockers: RequestProtocol {
        
        typealias ResponseType = UserListModel
        var path: String
        
        init(itemId: String) {
            path = "/api/v2/items/\(itemId)/stockers"
        }
        
        var responseSerializer: ResponseSerializer<ResponseType, NSError> {
            
            return ResponseSerializer<ResponseType, NSError> { request, response, data, error -> Result<ResponseType, NSError> in
                
                let resultJson = Alamofire.Request.JSONResponseSerializer().serializeResponse(request, response, data, error)
                if let error = resultJson.error {
                    return .Failure(error)
                }
                
                guard let object = Mapper<UserModel>().mapArray(resultJson.value) else {
                    return .Failure(NSError(domain: "com.hachinobu.qiitaclient", code: -1000, userInfo: [NSLocalizedFailureReasonErrorKey: "Mapping Error"]))
                }
                
                let userList = UserListModel(userModels: object)
                return .Success(userList)
                
            }
            
        }
        
    }
    
    class StockOperation: RequestProtocol {
        
        typealias ResponseType = Bool
        var method: Alamofire.Method
        var path: String
        var isAccessToken: Bool = true
        
        init(method: Alamofire.Method, itemId: String) {
            self.method = method
            path = "/api/v2/items/\(itemId)/stock"
        }
        
        var responseSerializer: ResponseSerializer<ResponseType, NSError> {
            
            return ResponseSerializer<ResponseType, NSError> { request, response, data, error -> Result<ResponseType, NSError> in
                return .Success(true)
            }
            
        }
        
    }
    
}
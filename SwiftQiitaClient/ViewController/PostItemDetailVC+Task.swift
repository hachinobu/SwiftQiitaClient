//
//  PostItemDetailVC+Task.swift
//  SwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2015/12/17.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import SwiftTask

extension PostItemDetailVC {
    
    typealias TaskType = Task<Void, Bool, NSError>
    
    func fetchStockStatusTask() -> TaskType {
        
        return TaskType { (progress, fulfill, reject, configure) -> Void in
            
            QiitaAPI.call(QiitaAPI.CheckStock(itemId: self.itemId)) { result -> Void in
                
                if let error = result.error {
                    return reject(error)
                }
                return fulfill(true)
                
            }
            
        }
        
    }
    
    func fetchPostItemDetailTask() -> TaskType {
        
        return Task { (_, fulfill, reject, configure) -> Void in
            
            QiitaAPI.call(QiitaAPI.PostItemDetail(itemId: self.itemId)) { [weak self] result -> Void in
                
                guard let object = result.value else {
                    return reject(result.error!)
                }
                self?.itemVM = PostItemCellVM(postItemModel: object)
                return fulfill(true)
                
            }
            
        }
        
    }
    
    func fetchStockersTask() -> TaskType {
        
        return Task { (_, fulfill, reject, configure) -> Void in
            
            QiitaAPI.call(QiitaAPI.GetStockers(itemId: self.itemId)) { [weak self] result -> Void in
                
                guard let object = result.value else {
                    return reject(result.error!)
                }
                self?.stockUserListVM = UserListVM(baseModel: object)
                return fulfill(true)
                
            }
            
        }
        
    }
    
    
}
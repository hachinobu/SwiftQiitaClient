//
//  PostItemDetailVC+API.swift
//  SwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2015/12/17.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import SwiftTask
import Alamofire

extension PostItemDetailVC {
    
    func fetchPostItemDetailInfo() {
        
        let tasks = [fetchPostItemDetailTask(), fetchStockersTask()]
        Task.all(tasks).success { [weak self] results -> Void in
            
            self?.fetchStockStatusTask().success { [weak self] _ -> Void in
                self?.itemVM.updateStockStatus(true)
                }.failure { [weak self] _ -> Void in
                    self?.itemVM.updateStockStatus(false)
                }.then { [weak self] _ -> Void in
                    self?.tableView.reloadData()
            }
            
            }.failure { (error, isCancelled) -> Void in
                print(error?.localizedDescription)
        }
        
    }
    
}
//
//  PostItemListVC+API.swift
//  SwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2015/12/17.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation

extension PostItemListVC {
    
    func fetchAllPostItem() {
        QiitaAPI.call(QiitaAPI.AllPostItemList(parameters: ["per_page": 100])) { result -> Void in
            
            self.refresh.endRefreshing()
            guard let object = result.value else {
                return
            }
            self.postItemListVM = AllPostItemListVM(baseModel: object)
            self.bindUI()
            
        }
    }
    
}
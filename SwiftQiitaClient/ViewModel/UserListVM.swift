//
//  UserListVM.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Bond

struct UserListVM {
    
    let stockCount = Observable<Int?>(0)
    var stockCountInfo: EventProducer<String> {
        
        return stockCount.map { count -> String in
            guard let count = count else {
                return "0ストック"
            }
            if count >= 100 {
                return "100以上ストック"
            }
            return "\(count)ストック"
        }
        
    }
    
    init() {
        
    }
    
    init(baseModel: UserListModel) {
        setupObservableValue(baseModel)
    }
    
    func setupObservableValue(baseModel: UserListModel) {
        stockCount.next(baseModel.userModels?.count)
    }
    
}
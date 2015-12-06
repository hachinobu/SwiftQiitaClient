//
//  AllPostItemListVM.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/05.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Bond

struct AllPostItemListVM {
    
    var postItemCellViewModels: ObservableArray<PostItemCellVM>
    
    init(baseModel: AllPostItemListModel?) {
        postItemCellViewModels = ObservableArray([])
        generatePostItemViewModels(baseModel)
    }
    
    private func generatePostItemViewModels(baseModel: AllPostItemListModel?) {
        
        guard let postItems = baseModel?.postItems else {
            return
        }
        
        let postItemVMList = postItems.map { PostItemCellVM(postItemModel: $0) }
        postItemCellViewModels.extend(postItemVMList)
        
    }
    
}
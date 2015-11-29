//
//  PostItemCellVM.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Bond

struct PostItemCellVM {
    
    let name = Observable<String?>("")
    let profileImage = Observable<UIImage?>(nil)
    var profileImageURL: String? = ""
    let title = Observable<String?>("")
    let tags = Observable<String>("")
    let itemURL = Observable<String?>("")
    let updatedAt = Observable<String?>("")
    let createdAt = Observable<String?>("")
    
    var userPost: EventProducer<String> {
        
        return combineLatest(name, updatedAt).map{ (userValue, updatedAtValue) in
            guard let userValue = userValue, updatedAtValue = updatedAtValue else {
                return ""
            }
            return userValue + " が" + updatedAtValue + "前に投稿しました"
        }
        
    }
    
    init(postItemModel: PostItemModel) {
        profileImageURL = postItemModel.user?.profileImageUrl
        setupObservableValue(postItemModel)
    }
    
    private func setupObservableValue(postItemModel: PostItemModel) {
        name.next(postItemModel.user?.name)
        title.next(postItemModel.title)
        itemURL.next(postItemModel.url)
        updatedAt.next(postItemModel.updatedAt)
        createdAt.next(postItemModel.createdAt)
        
        guard let tagList = postItemModel.tags else {
            return
        }
        var tagNames: [String] = []
        tagList.flatMap { $0.name }.forEach { tagNames.append($0) }
        tags.next(tagNames.joinWithSeparator(","))
        
        
        
    }
    
}
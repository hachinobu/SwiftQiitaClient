//
//  PostItemCellVM.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import Foundation
import Bond
import Timepiece
import Kingfisher

struct PostItemCellVM {
    
    let id = Observable<String?>("")
    let profileImage = Observable<UIImage?>(nil)
    var profileImageURL: String? = ""
    let title = Observable<String?>("")
    let tags = Observable<String>("")
    let itemURL = Observable<String?>("")
    let updatedAt = Observable<String?>("")
    let createdAt = Observable<String?>("")
    
    var postedInfo: EventProducer<String?> {
        return combineLatest(id, updatedAt).map{ (idValue, createdAtValue) in
            guard let idValue = idValue, createdAtValue = createdAtValue else {
                return ""
            }
            return idValue + " が " + self.fetchTimeDifference(createdAtValue) + "前に投稿しました"
        }
    }
    
    init(postItemModel: PostItemModel) {
        setupValue(postItemModel)
    }
    
    private mutating func setupValue(postItemModel: PostItemModel) {
        profileImageURL = postItemModel.user?.profileImageUrl
        setupObservableValue(postItemModel)
    }
    
    private func setupObservableValue(postItemModel: PostItemModel) {
        id.next(postItemModel.user?.id)
        title.next(postItemModel.title)
        itemURL.next(postItemModel.url)
        updatedAt.next(postItemModel.updatedAt)
        createdAt.next(postItemModel.createdAt)
        
        guard let tagList = postItemModel.tags else {
            return
        }
        tags.value = tagList.flatMap { $0.name }.joinWithSeparator(",")
    }
    
    private func fetchTimeDifference(ISO8601String: String) -> String {
        
        guard let date = ISO8601String.dateFromFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ") else {
            return ""
        }
        let diff = NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: date, toDate: NSDate(), options: [])
        
        if diff.year > 0 {
            return "\(diff.year)年"
        }
        
        if diff.month > 0 {
            return "\(diff.month)ヶ月"
        }
        
        if diff.day > 0 {
            return "\(diff.day)日"
        }
        
        if diff.hour > 0 {
            return "\(diff.hour)時間"
        }
        
        if diff.minute > 0 {
            return "\(diff.minute)分"
        }
        
        if diff.second > 0 {
            return "\(diff.second)秒"
        }
        
        return ""
        
    }
    
    private func changeProfileImage(image: UIImage) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.profileImage.next(image)
        })
    }
    
    func downloadProfileImage() {
        
        guard let profileImageURL = profileImageURL, url = NSURL(string: profileImageURL) else {
            return
        }
        
        KingfisherManager.sharedManager.retrieveImageWithResource(Resource(downloadURL: url), optionsInfo: nil, progressBlock: nil) { (image, error, cacheType, imageURL) -> () in
            
            let imageValue = image ?? UIImage()
            self.changeProfileImage(imageValue)
            
        }
        
    }
    
}
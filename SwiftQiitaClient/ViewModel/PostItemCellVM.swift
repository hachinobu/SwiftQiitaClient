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
    let userId = Observable<String?>("")
    let profileImage = Observable<UIImage?>(nil)
    var profileImageURL: String?
    var renderedBody: String?
    let title = Observable<String?>("")
    let tags = Observable<String>("")
    let itemURL = Observable<String?>("")
    let updatedAt = Observable<String?>("")
    let createdAt = Observable<String?>("")
    let hasStock = Observable<Bool>(false)
    
    var postedInfo: EventProducer<String?> {
        return combineLatest(userId, updatedAt).map{ (idValue, createdAtValue) in
            guard let idValue = idValue else {
                return ""
            }
            return idValue + " が投稿しました"
        }
    }
    
    typealias IndicatorStatus = (isAnimation: Observable<Bool>, isHidden: Observable<Bool>)
    var indicatorStatusInfo: EventProducer<IndicatorStatus> {
        return profileImage.map { image -> IndicatorStatus in
            if image == nil {
                return (isAnimation: Observable<Bool>(true), isHidden: Observable<Bool>(false))
            }
            return (isAnimation: Observable<Bool>(false), isHidden: Observable<Bool>(true))
        }
    }
    
    typealias StockButtonStatus = (backgroundColor: Observable<UIColor>, textColor: UIColor, title: Observable<String>)
    var stockButtonInfo: EventProducer<StockButtonStatus> {
        return hasStock.map { isStock -> StockButtonStatus in
            if isStock {
                return (backgroundColor: Observable<UIColor>(UIColor.greenColor()), textColor: UIColor.whiteColor(), title: Observable<String>("ストック済"))
            }
            return (backgroundColor: Observable<UIColor>(UIColor.whiteColor()), textColor: UIColor.blackColor(), title: Observable<String>("ストックする"))
        }
    }
    
    init() {
        
    }
    
    init(postItemModel: PostItemModel) {
        setupValue(postItemModel)
    }
    
    private mutating func setupValue(postItemModel: PostItemModel) {
        profileImageURL = postItemModel.user?.profileImageUrl
        renderedBody = postItemModel.renderedBody
        setupObservableValue(postItemModel)
    }
    
    private func setupObservableValue(postItemModel: PostItemModel) {
        id.next(postItemModel.id)
        userId.next(postItemModel.user?.id)
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
    
    func updateStockStatus(isStock: Bool) {
        hasStock.next(isStock)
    }
    
    func displayRenderBody() -> String {
        return renderedBody ?? ""
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
    
    private func createStockItem(itemId: String) -> (endPoint: QiitaAPI.StockOperation, result: Bool) {
        return (endPoint: QiitaAPI.ToStock(itemId: itemId), result: true)
    }
    
    private func deleteStockItem(itemId: String) -> (endPoint: QiitaAPI.StockOperation, result: Bool) {
        return (endPoint: QiitaAPI.DeleteStock(itemId: itemId), result: false)
    }
    
    private func updateStockItem(stockInfo: (endPoint: QiitaAPI.StockOperation, result: Bool)) {
        
        QiitaAPI.call(stockInfo.endPoint) { result -> Void in
            
            if result.error != nil {
                return
            }
            self.updateStockStatus(stockInfo.result)
            
        }
        
    }
    
    func updateStockItem() {
        
        guard let itemId = id.value else {
            return
        }
        if hasStock.value {
            updateStockItem(deleteStockItem(itemId))
            return
        }
        updateStockItem(createStockItem(itemId))
        
    }
    
}
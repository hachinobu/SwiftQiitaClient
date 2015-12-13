//
//  PostItemDetailVC.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit
import SwiftTask
import Alamofire

class PostItemDetailVC: UITableViewController {

    typealias TaskType = Task<Void, Bool, NSError>
    
    var itemId: String!
    var itemVM: PostItemCellVM = PostItemCellVM()
    var stockUserListVM = UserListVM()
    var webViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "詳細"
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchPostItemDetailInfo()
        fetchStockStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchPostItemDetailInfo() {
        
        let tasks = [fetchPostItemDetail(), fetchStockers()]
        Task.all(tasks).success { [weak self] results -> Void in
            
            self?.fetchStockStatus().success { [weak self] _ -> Void in
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
    
    func fetchStockStatus() -> TaskType {
        
        return TaskType { (progress, fulfill, reject, configure) -> Void in
            
            QiitaAPI.call(QiitaAPI.CheckStock(itemId: self.itemId)) { result -> Void in
                
                if let error = result.error {
                    return reject(error)
                }
                return fulfill(true)
                
            }
            
        }
        
    }

    func fetchPostItemDetail() -> TaskType {
        
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
    
    func fetchStockers() -> TaskType {
        
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
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.itemDetailTopCell, forIndexPath: indexPath)!
            itemVM.title.bindTo(cell.titleLabel.bnd_text).disposeIn(cell.bnd_bag)
            itemVM.tags.bindTo(cell.tagLabel.bnd_text).disposeIn(cell.bnd_bag)
            itemVM.profileImage.bindTo(cell.profileImageView.bnd_image).disposeIn(cell.bnd_bag)
            itemVM.postedInfo.bindTo(cell.postInfoLabel.bnd_text).disposeIn(cell.bnd_bag)
            stockUserListVM.stockCountInfo.bindTo(cell.stockCountLabel.bnd_text).disposeIn(cell.bnd_bag)
            itemVM.downloadProfileImage()
            itemVM.stockButtonInfo.observe { (status) -> Void in
                status.backgroundColor.bindTo(cell.stockButton.bnd_backgroundColor).disposeIn(cell.bnd_bag)
                status.title.bindTo(cell.stockButton.bnd_title).disposeIn(cell.bnd_bag)
                cell.stockButton.setTitleColor(status.textColor, forState: .Normal)
            }
            cell.stockButton.bnd_controlEvent.filter { $0 == .TouchUpInside }.observeNew { [unowned self] event -> Void in
                self.itemVM.updateStockItem()
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.itemDetailBodyCell, forIndexPath: indexPath)!
        //sampleなので一旦レンダリングコスト気にせずで。。
        cell.loadRenderedBody(itemVM.displayRenderBody())
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        return webViewHeight
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        return webViewHeight
    }

}

extension PostItemDetailVC: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let height = webView.scrollView.contentSize.height
        if webViewHeight == height {
            return
        }
        webViewHeight = height
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
        
    }
    
}


//
//  PostItemDetailVC.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit
import SwiftTask

class PostItemDetailVC: UITableViewController {
    
    var itemId: String!
    var itemVM: PostItemCellVM = PostItemCellVM()
    var stockUserListVM = UserListVM()
    var webViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "詳細"
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchPostItemDetailInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                cell.stockButton.backgroundColor = status.backgroundColor
                cell.stockButton.setTitle(status.title, forState: .Normal)
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


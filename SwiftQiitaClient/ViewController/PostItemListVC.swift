//
//  PostItemListVC.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/11/29.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit
import Bond
import Kingfisher

class PostItemListVC: UITableViewController {

    let refresh = UIRefreshControl()
    var postItemListVM: AllPostItemListVM = AllPostItemListVM(baseModel: nil)
    var dataSource: ObservableArray<ObservableArray<PostItemCellVM>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAllPostItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.title = "すべての投稿"
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: Selector("refreshPostData"), forControlEvents: .ValueChanged)
    }
    
    func bindUI() {
        dataSource = postItemListVM.postItemCellViewModels.lift()
        dataSource.bindTo(tableView) { (indexPath, dataSource, tableview) -> UITableViewCell in
            
            let cellVM = dataSource[indexPath.section][indexPath.row]
            let cell = tableview.dequeueReusableCellWithIdentifier(R.reuseIdentifier.postItemListCell, forIndexPath: indexPath)!
            cellVM.profileImage.bindTo(cell.profileImageView.bnd_image).disposeIn(cell.bnd_bag)
            cellVM.indicatorStatusInfo.observe { status in
                status.isAnimation.bindTo(cell.imageLoadIndicator.bnd_animating).disposeIn(cell.bnd_bag)
                status.isHidden.bindTo(cell.imageLoadIndicator.bnd_hidden).disposeIn(cell.bnd_bag)
            }
            
            cellVM.postedInfo.bindTo(cell.postedInfoLabel.bnd_text).disposeIn(cell.bnd_bag)
            cellVM.title.bindTo(cell.titleLabel.bnd_text).disposeIn(cell.bnd_bag)
            cellVM.tags.bindTo(cell.tagLabel.bnd_text).disposeIn(cell.bnd_bag)
            cellVM.downloadProfileImage()
            
            return cell
            
        }
    }
    
    func refreshPostData() {
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
        fetchAllPostItem()
    }
    
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let itemId = dataSource[indexPath.section][indexPath.row].id.value else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        let detailVC = R.storyboard.postItemDetail.initialViewController!
        detailVC.itemId = itemId
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }

}

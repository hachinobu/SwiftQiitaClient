//
//  ItemDetailBodyCell.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit

class ItemDetailBodyCell: UITableViewCell {

    @IBOutlet weak var htmlWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        htmlWebView.scrollView.scrollEnabled = false
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadRenderedBody(renderedBody: String) {
        htmlWebView.loadHTMLString(renderedBody, baseURL: nil)
    }

}

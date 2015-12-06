//
//  ItemCell.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/05.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit
import Bond

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postedInfoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bnd_bag.dispose()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

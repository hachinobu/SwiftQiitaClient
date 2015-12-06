//
//  ItemDetailTopCell.swift
//  SwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2015/12/06.
//  Copyright © 2015年 hachinobu. All rights reserved.
//

import UIKit

class ItemDetailTopCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postInfoLabel: UILabel!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var stockButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        stockButton.layer.cornerRadius = 4.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bnd_bag.dispose()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

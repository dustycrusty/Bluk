//
//  MainFeedTableViewCell.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit
import RSMasterTableViewKit
class MainFeedTableViewCell: RSTableViewCell {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

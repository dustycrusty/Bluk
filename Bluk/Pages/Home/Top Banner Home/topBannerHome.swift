//
//  topBannerHome.swift
//  Bluk
//
//  Created by 이승윤 on 28/06/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit

class topBannerHome:UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    
    init(frame: CGRect, banners: [Banner]?){
        super.init(frame: frame)
        commonInit()
    }
    
   
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("topBannerHome", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}



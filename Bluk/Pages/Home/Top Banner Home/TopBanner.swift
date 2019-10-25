//
//  TopBanner.swift
//  Bluk
//
//  Created by 이승윤 on 01/07/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit

class TopBanner {
    
    var duration = 2
    var bannerObj:topBannerHome!
    var banners:[Banner] = []{
        willSet(newVal){
            animateChange(newVal)
        }
    }
    
    init(banners:[Banner]?, bannerObject: topBannerHome){
        self.bannerObj = bannerObject
        if banners != nil {
             self.banners = banners!
        }
        else{
            self.banners = []
        }
        animateChange(banners)
    }
    
    
    private func setTextAndImageBackground(_ banner: Banner){
        bannerObj.mainTitle.text = banner.title
        bannerObj.subTitle.text = banner.subtitle
        bannerObj.contentView.backgroundColor = banner.color
    }
    
    private func animateChange(_ banners: [Banner]?){
        print("in here")
        if let bans = banners{
            setTextAndImageBackground(bans[0])
            print("in banners")
            var index = 1
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: true) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.setTextAndImageBackground(bans[index])
                })
                if index == bans.count - 1{
                    index = 0
                }
                else{
                    index += 1
                }
            }
        }
        
    }
}

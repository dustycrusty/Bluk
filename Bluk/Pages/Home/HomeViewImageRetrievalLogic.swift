//
//  HomeViewImageRetrievalLogic.swift
//  Bluk
//
//  Created by 이승윤 on 02/07/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct feedImagesList {
    var first: UIImageView
    var second: UIImageView
}

class HomeViewImageRetrievalLogic {
    
    var noticeViews: feedImagesList!
    var mainFeedViews: feedImagesList!
    var notices: [MainFeedObject]?
    var mainFeeds: [MainFeedObject]?
    var API:HomeAPI!
    var parent: FeedView!
    var vc: UIViewController!
    
    init(noticeViews: feedImagesList, mainFeedViews: feedImagesList, API:HomeAPI, parent: FeedView, vc: UIViewController){
        self.noticeViews = noticeViews
        self.mainFeedViews = mainFeedViews
        self.API = API
        self.parent = parent
        self.vc = vc
    }
    
    
    func updateHome(){
        let dg = DispatchGroup()
        vc.showSpinner(onView: vc.view)
        manageUserInteraction_imageView(false)
        dg.enter()
        API.getFirstTwoFeeds_Main { (objs, _) in
            if let objs = objs{
                self.mainFeeds = objs
                dg.leave()
            }
            else{
                self.mainFeeds = []
                dg.leave()
            }
        }
        dg.enter()
        API.getFirstTwoFeeds_Notice { (objs, _) in
            if let objs = objs{
                self.notices = objs
                dg.leave()
            }
            else{
                self.notices = []
                dg.leave()
            }
        }
        
        dg.notify(queue: .main) {
            self.manageUserInteraction_imageView(true)
            self.setImagesToViews(typeOfFeed: .mainFeed)
            self.setImagesToViews(typeOfFeed: .notice)
            self.setGestureRecognizer()
            self.vc.removeSpinner()
        }
    }
    fileprivate func setGestureRecognizer(){
        let n1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped_notice_first))
        let n2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped_notice_second))
        let f1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped_mf_first))
        let f2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped_mf_second))
        
        noticeViews.first.addGestureRecognizer(n1)
        noticeViews.second.addGestureRecognizer(n2)
        mainFeedViews.first.addGestureRecognizer(f1)
        mainFeedViews.second.addGestureRecognizer(f2)

        
        
    }
    
    @objc fileprivate func imageTapped_notice_first(){
        if let notices = notices{
            if notices.count >= 1{
             parent.fromHomeToSingleFeed(obj: notices[0])
            }
        }
    }
    
    @objc fileprivate func imageTapped_notice_second(){
        if let notices = notices{
            if notices.count > 1{
                parent.fromHomeToSingleFeed(obj: notices[1])
            }
        }
    }
    
    @objc fileprivate func imageTapped_mf_first(){
        if let mf = mainFeeds{
            if mf.count >= 1{
                parent.fromHomeToSingleFeed(obj: mf[0])
            }
        }
    }
    
    @objc fileprivate func imageTapped_mf_second(){
        if let mf = mainFeeds{
            if mf.count > 1{
                parent.fromHomeToSingleFeed(obj: mf[1])
            }
        }
    }
    
    
    
    enum feedType{
        case mainFeed, notice
    }
    
    
    fileprivate func setImagesToViews(typeOfFeed:feedType){
        var views: feedImagesList!
        var feeds: [MainFeedObject]!
        
        if typeOfFeed == .mainFeed {
            views = mainFeedViews
            feeds = mainFeeds
        }
        else{
            views = noticeViews
            feeds = notices
        }
        
        if feeds.count > 1{
            getFirstImageFromFeed(feeds[0]) { (image) in
                views.first.image = image
            }
            getFirstImageFromFeed(feeds[1]) { (image) in
                views.second.image = image
            }

        }
        if feeds.count == 1 {
            getFirstImageFromFeed(feeds[0]) { (image) in
                views.first.image = image
            }
        }
        
    }
    
    fileprivate func getFirstImageFromFeed(_ mainFeed: MainFeedObject, completion: @escaping ((UIImage) -> ()) ){
        if var imgArr = mainFeed.mainImages {
            if imgArr.count > 1 {
                imgArr.sort(by: { (x, y) -> Bool in
                    return x.id! < y.id!
                })
            }
            if let path = imgArr[0].file?.fullPath{
                let ref = Storage.storage().reference(withPath: path)
                ref.getData(maxSize: .max) { (data, error) in
                    if error != nil || data == nil{
                        completion(UIColor.gray.as1ptImage())
                    }
                    else{
                        completion(UIImage(data: data!) ?? UIColor.gray.as1ptImage())
                    }
                }
            }
            else{
                completion(UIColor.gray.as1ptImage())
            }
        }
    }
    
    fileprivate func manageUserInteraction_imageView(_ boolean: Bool){
        noticeViews.first.isUserInteractionEnabled = boolean
        noticeViews.second.isUserInteractionEnabled = boolean
        mainFeedViews.first.isUserInteractionEnabled = boolean
        mainFeedViews.second.isUserInteractionEnabled = boolean
    }
}


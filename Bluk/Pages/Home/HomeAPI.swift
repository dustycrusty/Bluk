//
//  HomeAPI.swift
//  Bluk
//
//  Created by 이승윤 on 28/06/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit
import Ballcap

class HomeAPI {
    
    typealias bannerCompletionBlock = ([Banner]?, Error?) -> ()
    
    init(){
        
    }
    //Upload
    
    func uploadTestBanners() {
        
        var banner1 = BannerModel()
        let hex1 = "A2DB7A"
        banner1.title = "r34r32342134"
        banner1.subtitle = "asdasfasf"
        banner1.color = hex1
        let bannerObj = Banners()
        bannerObj.data = banner1
        bannerObj.save()
        
        var banner2 = BannerModel()
        let hex2 = "DBD57A"
        banner2.title = "asdasdfas"
        banner2.subtitle = "this shit doesnt  end"
        banner2.color = hex2
        let bannerObj2 = Banners()
        bannerObj2.data = banner2
        bannerObj2.save()
        
        var banner3 = BannerModel()
        let hex3 = "7AD3DD"
        banner3.title = "me"
        banner3.subtitle = "please do"
        banner3.color = hex3
        let bannerObj3 = Banners()
        bannerObj3.data = banner3
        bannerObj3.save()
        
        var banner4 = BannerModel()
        let hex4 = "#DB7A7A"
        banner4.title = "OMG"
        banner4.subtitle = "IT never ENDS"
        banner4.color = hex4
        let bannerObj4 = Banners()
        bannerObj4.data = banner4
        bannerObj4.save()
        
    }
    
    //Download
    
    //**Banners
    
    func getAllBannerss(completion: @escaping bannerCompletionBlock){
        Banners.collectionReference.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            }
            else{
                if (snapshot?.documents.isEmpty)!{
                    completion([], nil)
                }
                else{
                    var banners: [Banner] = []
                    for doc in snapshot?.documents ?? []{
                        if let banner = Banners(snapshot: doc)?.data{
                            banners.append(self.BannersToBanner(bobj: banner))
                        }
                    }
                    completion(banners, nil)
                }
            }
        }
    }
    
    //**First Two feeds
    func getFirstTwoFeeds_Main(completion: @escaping ([MainFeedObject]?, Error?) -> ()){
        MainFeedAPI.download_two_MainFeedObject(isNotice: false) { (objects, error) in
            completion(objects, error)
        }
    }
    //**First two notices
    
    func getFirstTwoFeeds_Notice(completion: @escaping ([MainFeedObject]?, Error?) -> ()){
        MainFeedAPI.download_two_MainFeedObject(isNotice: true) { (objects, error) in
            completion(objects, error)
        }
    }
    
    //Converter
    
    func BannersToBanner(bobj: BannerModel) -> Banner{
        let title = bobj.title
        let subtitle = bobj.subtitle
        let color = UIColor().hexStringToUIColor(hex: bobj.color ?? "#000000")
        
        return Banner(title: title ?? "", subtitle: subtitle ?? "" , color: color)
    }
    
    
    
}

struct Banner {
    var title:String
    var subtitle:String
    var color:UIColor
}

struct BannerModel: Modelable & Codable {
    init() {}
    var title: String?
    var subtitle: String?
    var color: String?
}



class Banners: Object, DataRepresentable {
    var data: BannerModel?
    
    
}




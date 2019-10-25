//
//  _MainFeedObject.swift
//  Bluk
//
//  Created by 이승윤 on 27/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit
import Ballcap


struct _MainFeedObject: Modelable & Codable {
    init() {}
    
    var isNotice:Bool = false
    var views:IncrementableInt = 0
    var mainText:String?
    var title:String?
    var subtitle:String?
    var date: Date?
//    var mainImages:[File]?
}

struct _FeedDetailObject: Modelable & Codable {
    init() {
        
    }
    var views:IncrementableInt = 0
    var brand: String?
    var price: String?
    var image: File?
    var link: URL?
}

struct _imageFileObject: Modelable & Codable {
    init(){}
    
    var id: Int?
    var file: File?
}

struct MainFeedObject {
    
//    var isNotice:Bool = false
    var views:Int?
    var id: String?
    var mainText:String?
    var title:String?
    var subtitle:String?
    var date: Date?
    var mainImages:[imageFileObject]?
    var feedDetails:[FeedDetailObject]?
}

struct FeedDetailObject {
    var brand: String?
    var price: String?
    var image: File?
    var link: URL?
}

struct imageFileObject {
    var id: Int?
    var file: File?
}


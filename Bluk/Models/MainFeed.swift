//
//  MainFeed.swift
//  Bluk
//
//  Created by 이승윤 on 27/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Ballcap
import UIKit

class MainFeed: Object, DataRepresentable & HierarchicalStructurable {
    
    var data:_MainFeedObject?
    var feedDetails:[FeedDetail] = []
    var mainImages:[imageFile] = []
    
    enum CollectionKeys: String {
        case feedDetails
        case mainImages
    }
}

class FeedDetail: Object, DataRepresentable  {
   
    var data: _FeedDetailObject?
}

class imageFile: Object, DataRepresentable {
    
    var data: _imageFileObject?
    
}


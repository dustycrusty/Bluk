//
//  slideShowSetup.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import ImageSlideshow

class slideShowSetup {
    
    var slideShow:ImageSlideshow!
    
    init(_ show: ImageSlideshow){
        self.slideShow = show
        activityIndicatorSetup()
        //pageIndicatorSetup()
        //*******소영찡 물어보기*******
    }
    
    func pageIndicatorSetup(){
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        slideShow.pageIndicator = pageIndicator
        
        slideShow.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customUnder(padding: 15))
        
    }
    
    func activityIndicatorSetup(){
        slideShow.activityIndicator = DefaultActivityIndicator()
        
        
    }
    
    func setInput(_ sources:[InputSource]){
        slideShow.setImageInputs(sources)
    }
}

//
//  HomeView.swift
//  Bluk
//
//  Created by 이승윤 on 28/06/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

    @IBOutlet weak var monthlyUpdateImageView: UIImageView!
    
    @IBOutlet weak var feed1: UIImageView!
    @IBOutlet weak var feed2: UIImageView!
    @IBOutlet weak var notice1: UIImageView!
    @IBOutlet weak var notice2: UIImageView!
    
    @IBOutlet weak var banner: topBannerHome!
    
    var API: HomeAPI!
    var ViewLogic: HomeViewImageRetrievalLogic!
    var parentRef: FeedView!
    
    fileprivate func updateHome() {
        ViewLogic.updateHome()
        setupBanner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API = HomeAPI()
        let noticeViews = feedImagesList(first: notice1, second: notice2)
        let feedViews = feedImagesList(first: feed1, second: feed2)
        ViewLogic = HomeViewImageRetrievalLogic(noticeViews: noticeViews, mainFeedViews: feedViews, API: API, parent: parentRef, vc: self)
        
        
        updateHome()
        
//        API.uploadTestBanners()
        // Do any additional setup after loading the view.
    }
    
    
    
    func setupBanner(){
        
        API.getAllBannerss { (banners, error) in
            if let error = error {
                print(error)
            }
            else{
                let _ = TopBanner(banners: banners, bannerObject: self.banner)
            }
        }
        
    }
    
    @IBAction func feed_moreTapped(_ sender: Any) {
        parentRef.segmentControl.setIndex(1, animated: true)
        parentRef.tableView.alpha = 1
        parentRef.containerView_home.alpha = 0
        
        if parentRef.tableView.tag != 1{
            parentRef.tableView.tag = 1
            parentRef.tableView.dataSource = parentRef.config.datasource
            parentRef.tableView.reloadData()
        }
    }
    
    @IBAction func notice_moreTapped(_ sender: Any) {
        parentRef.segmentControl.setIndex(2, animated: true)
        
        parentRef.tableView.alpha = 1
        parentRef.containerView_home.alpha = 0
        
        if parentRef.tableView.tag != 2{
            parentRef.tableView.tag = 2
            parentRef.tableView.dataSource = parentRef.config.noticeDatasource
            parentRef.tableView.reloadData()
        }
        
    }
    
    
    
//    private func exampleBanner() -> [Banner]{
//        let banner1 = Banner(title: "This is main Title", subtitle: "This is Subtle", color: UIColor().hexStringToUIColor(hex: "#FFC0CB"))
//        let banner2 = Banner(title: "This is main Title2", subtitle: "This is Subtitle2", color: UIColor().hexStringToUIColor(hex: "#3B5998"))
//        let banner3 = Banner(title: "This is main Title", subtitle: "This is Subtitle", color: UIColor().hexStringToUIColor(hex: "#50C878"))
//        return [banner1, banner2, banner3]
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

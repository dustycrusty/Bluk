//
//  FeedView.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit
import RSMasterTableViewKit
import BetterSegmentedControl
import NotificationBannerSwift

class FeedView: UIViewController {
    
    @IBOutlet weak var tableView:RSTableView!
    @IBOutlet weak var containerView_home: UIView!
    
    
    var datasource: RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>?
    var config:FeedSetup!
    var API: MainFeedAPI!
    @IBOutlet weak var segmentControl: BetterSegmentedControl!
    
    
    let reachability = Reachability()!
    
    var homeObj: MainFeedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "blutinLogo3")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
    
        self.navigationItem.titleView = imageView
        
        self.hero.isEnabled = true
        
        API = MainFeedAPI()
//        var isNotice = true
//        for i in 1...25{
//
//            API.upload_TestFeed(i, isNotice: isNotice)
//
//            if isNotice{
//                isNotice = false
//            }
//            else{
//                isNotice = true
//            }
//        }
        
        self.tableView.tag = 1
        
        config = FeedSetup(tableView, api: API, datasource: datasource, control: segmentControl)
        tableView.backgroundView?.backgroundColor = .white
        config.start()
        
        tableView.dataSource = config.datasource
        segmentedControlSetup()
                
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.homeObj = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: Notification.Name("reachabilityChanged"), object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        var banner: StatusBarNotificationBanner!
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none{
            banner = StatusBarNotificationBanner(title: "You are online.", style: .success)
            banner.show()
        }else{
            banner = StatusBarNotificationBanner(title: "You are offline.", style: .danger)
            banner.show()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reachabilityChanged"), object: reachability)
        
    }
    
    func segmentedControlSetup(){
        segmentControl.segments = LabelSegment.segments(withTitles: ["Home", "All", "Notices"],
        normalFont: UIFont(name: "Asap", size: 14.0)!,
        normalTextColor: .lightGray,
        selectedFont: UIFont(name: "Asap-Bold", size: 14.0)!,
        selectedTextColor: .white)
//
        segmentControl.addTarget(self, action: #selector(self.segmentTapped), for: .valueChanged)
    }
    
    @objc func segmentTapped(){
        
        
       
        
        
        if segmentControl.index == 0 {
           tableView.alpha = 0
            containerView_home.alpha = 1
            
        }
            
        else if segmentControl.index == 1 {
            tableView.alpha = 1
            containerView_home.alpha = 0
            
            if tableView.tag != 1{
                self.tableView.tag = 1
                self.tableView.dataSource = config.datasource
               
                    if config.feeds.count > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
                    }
                
                tableView.reloadData()
            }
        }
            //SEGMENT 2
        else{
            tableView.alpha = 1
            containerView_home.alpha = 0

            if tableView.tag != 2{
                self.tableView.tag = 2
                self.tableView.dataSource = config.noticeDatasource
               
                    if config.notices.count > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
                    }
                
                tableView.reloadData()
            }
        }
    }
    
    fileprivate func heroSegue(_ segue: UIStoryboardSegue, _ obj: MainFeedObject?) {
        if let nextVC = segue.destination as? SingleFeedView{
            nextVC.feed = obj
            
            nextVC.hero.isEnabled = true
            nextVC.hero.modalAnimationType = .selectBy(presenting: .pull(direction: .left), dismissing: .slide(direction: .down))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHomeView"{
            if let nextVC = segue.destination as? HomeView{
                nextVC.parentRef = self
            }
        }
        if segue.identifier == "toSingleFeed"{
            var obj:MainFeedObject!
            let index = tableView.indexPathForSelectedRow
            if segmentControl.index == 1 {
                obj = config.feeds[index!.row]
                 heroSegue(segue, obj)
            }
            else if segmentControl.index == 2{
                obj = config.notices[index!.row]
                 heroSegue(segue, obj)
            }
            else{
                obj = homeObj
                if let nextVC = segue.destination as? SingleFeedView{
                    nextVC.feed = obj
                    nextVC.hero.isEnabled = true
                    nextVC.hero.modalAnimationType = .auto
                }
            }
            
           
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension FeedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toSingleFeed", sender: self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedView {
    func fromHomeToSingleFeed(obj:MainFeedObject){
        self.homeObj = obj
        self.performSegue(withIdentifier: "toSingleFeed", sender: self)
    }
}

//
//  FeedSetup.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit
import RSMasterTableViewKit
import Firebase
import BetterSegmentedControl

class FeedSetup {
    
    var tableView:RSTableView!
    var api: MainFeedAPI!
    var datasource: RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>?
    var noticeDatasource: RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>?
    var feeds:[MainFeedObject] = []
    var notices:[MainFeedObject] = []
    var lo_all: QueryDocumentSnapshot?
    var lo_notice: QueryDocumentSnapshot?
    var control: BetterSegmentedControl!
    
    init(_ tableView: RSTableView, api: MainFeedAPI, datasource: RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>?, control: BetterSegmentedControl) {
        
        self.control = control
        self.tableView = tableView
        self.api = api
        self.datasource = datasource
        
        datasourceSetup("FeedCell")
        pullToRefresh_dataSetup()
        pullToRefresh_appearanceSetup()
        EmptyDatasetSetup()
        paginationSetup()
        
    }
    
    func start_AllFeeds(completion: @escaping ()->()){
        
        tableView.showIndicator()
        self.lo_all = nil
        self.datasource?.clearData()
        self.feeds.removeAll()
        MainFeedAPI().download_initial_MainFeedObject { (lo, obj, error) in
            print(lo, obj, error)
            if let error = error {
                //Show error
                print("errored")
                print(error.localizedDescription)
                self.tableView.hideIndicator()
                self.datasource?.setData(data: [])
                completion()
            }
            else{
                print("not erroed")
                self.lo_all = lo
                self.datasource?.setData(data: obj ?? [])
                self.feeds = obj ?? []
                self.tableView.hideIndicator()
                completion()

            }
        }
    }
    
    func start(){
        
        self.control.isUserInteractionEnabled = false
        
        let dg = DispatchGroup()
        
        
        dg.enter()
        start_AllFeeds {
            dg.leave()
        }
        dg.enter()
        start_notices {
            dg.leave()
        }
        
        dg.notify(queue: .main) {
            self.control.isUserInteractionEnabled = true
        }
    }
    
    func start_notices(completion: @escaping ()->()){
        
        
        self.lo_notice = nil
        self.datasource?.clearData()
        self.notices.removeAll()
        tableView.showIndicator()
        MainFeedAPI().download_initial_NoticeObject{ (lo, obj, error) in
            print("test : ", lo , obj, error)
            if let error = error {
                //Show error
                print(error.localizedDescription)
                self.tableView.hideIndicator()
                self.noticeDatasource?.setData(data: [])
                
                completion()

            }
            else{
                self.lo_notice = lo
                self.noticeDatasource?.setData(data: obj ?? [])
                self.notices = obj ?? []
                self.tableView.hideIndicator()


                completion()
            }
        }
    }
    
    private func datasourceSetup(_ id: String ){
        
        self.datasource = RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>(tableView: tableView, identifier: id, cellConfiguration: { (cell, mainFeed, indexPath) in
            
            cell.mainTitle.text = mainFeed.title
            cell.subTitle.text = mainFeed.subtitle
            cell.date.text = mainFeed.date?.toStringFormat_Feed()
            if var imgArr = mainFeed.mainImages {
                if imgArr.count > 1 {
                    imgArr.sort(by: { (x, y) -> Bool in
                        return x.id! < y.id!
                    })
                }
                if let path = imgArr[0].file?.fullPath{
                    let ref = Storage.storage().reference(withPath: path)
                    ref.downloadURL(completion: { (url, _) in
                        if let url = url {
                            cell.mainImage.af_setImage(withURL: url)
                        }
                    })
                }
            }
        })
        
        self.noticeDatasource = RSTableViewDataSource<MainFeedTableViewCell, MainFeedObject>(tableView: tableView, identifier: id, cellConfiguration: { (cell, mainFeed, indexPath) in
            
            cell.mainTitle.text = mainFeed.title
            cell.subTitle.text = mainFeed.subtitle
            cell.date.text = mainFeed.date?.toStringFormat_Feed()
            if var imgArr = mainFeed.mainImages {
                if imgArr.count > 1 {
                    imgArr.sort(by: { (x, y) -> Bool in
                        return x.id! < y.id!
                    })
                }
                if let path = imgArr[0].file?.fullPath{
                    let ref = Storage.storage().reference(withPath: path)
                    ref.downloadURL(completion: { (url, _) in
                        if let url = url {
                            cell.mainImage.af_setImage(withURL: url)
                        }
                    })
                }
            }
        })
    }
    
    private func pullToRefresh_dataSetup(){
        
        tableView.addPullToRefresh {
            self.tableView.showIndicator()
            if self.tableView.tag == 1 {
                DispatchQueue.global().asyncAfter(deadline: .now()+2, execute: {
                    MainFeedAPI().download_initial_MainFeedObject { (lo, obj, error) in
                        if let error = error {
                            //Show error
                            print(error.localizedDescription)
                            self.tableView.hideIndicator()

                        }
                        else{
                            self.lo_all = lo!
                            self.datasource?.clearData()
                            self.datasource?.setData(data: obj!)
                            self.feeds.removeAll()
                            self.feeds = obj!
                            self.tableView.hideIndicator()

                            self.tableView.reloadData()
                        }
                    }
                })
            }
            else{
                DispatchQueue.global().asyncAfter(deadline: .now()+2, execute: {
                    MainFeedAPI().download_initial_NoticeObject{ (lo, obj, error) in
                        if let error = error {
                            //Show error
                            print(error.localizedDescription)
                            self.tableView.hideIndicator()

                        }
                        else{
                            self.lo_notice = lo!
                            self.noticeDatasource?.clearData()
                            self.noticeDatasource?.setData(data: obj!)
                            self.notices.removeAll()
                            self.notices = obj!
                            self.tableView.hideIndicator()

                            self.tableView.reloadData()
                        }
                    }
                })
            }
            
        }
    }
    
    private func pullToRefresh_appearanceSetup(){
        tableView.setPullToRefresh(tintColor: UIColor.darkGray, attributedText: nil)
    }

    private func EmptyDatasetSetup(){
        tableView.setEmptyDataView(title: NSAttributedString(string: "There is nothing posted yet!"), description: NSAttributedString(string: "If you think this is an error, please try reloading."))
    }
    
    private func paginationSetup(){
        tableView.addPagination { (page) in
            
            if self.tableView.tag == 1 {
                self.api.download_pagination_MainFeedObject(lastObj: self.lo_all, completion: { (lo, objs, _) in
                    if let objs = objs {
                        self.datasource?.appendData(data: objs)
                        self.feeds.append(contentsOf: objs)
                    }
                })
            }
            else{
                self.api.download_pagination_NoticeObject(lastObj: self.lo_notice, completion: { (lo, objs, _) in
                    if let objs = objs {
                        self.noticeDatasource?.appendData(data: objs)
                        self.notices.append(contentsOf: objs)
                    }
                })
            }
            
        }
    }
}

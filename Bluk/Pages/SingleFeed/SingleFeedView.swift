//
//  SingleFeedView.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit
import ImageSlideshow
import SafariServices
import AlamofireImage
import Firebase
import Hero

struct indexedSource {
    var source:AlamofireSource!
    var index: Int!
}
class SingleFeedView: UIViewController {
    
    @IBOutlet weak var slideShow: ImageSlideshow!
   
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var mainText: UILabel!
    
    var feed:MainFeedObject!
    var config:slideShowSetup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config = slideShowSetup(slideShow)
        setupView()
        setupSlideShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let id = feed.id{
            MainFeedAPI().upload_incrementOneFeed_View(id: id)
        }
    }
    
    
   
    func setupView(){
        mainText.text = feed.mainText
        dateLabel.text = feed.date?.toStringFormat_Feed()
        subTitle.text = feed.subtitle
        mainTitle.text = feed.title
        views.text = String(feed.views ?? 0) + " views"

    }
    
    func setupSlideShow(){
        var indexedArr:[indexedSource] = []
        let group = DispatchGroup()
        let images = feed!.mainImages?.sorted(by: { (x, y) -> Bool in
            return x.id! < y.id!
        })
        
        images?.forEach({ (x) in
            group.enter()
            let ref = Storage.storage().reference(withPath: x.file!.fullPath)
            ref.downloadURL(completion: { (url, _) in
                if let url = url{
//                    sources.append(AlamofireSource(url: url))
                    indexedArr.append((indexedSource(source: AlamofireSource(url: url), index: x.id)))
                    group.leave()
                }
                else{
                    group.leave()
                }
            })
        })
        group.notify(queue: .main) {
            self.config.setInput(indexedArr.sorted(by: { (x, y) -> Bool in
                return x.index < y.index
            }).map({ (source) -> AlamofireSource in
                return source.source
            })
            )
        }
       
    }
}

extension SingleFeedView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.feedDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedDetailCell", for: indexPath) as! FeedDetailCollectionCell
        cell.configure(with: (feed.feedDetails?[indexPath.row])!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
//        collectionView.deselectItem(at: indexPath, animated: true)
        if let url = (feed.feedDetails?[indexPath.row])!.link {
            print("url exists!")
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
        else{
            //LINK UNAVAILABLE
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
    }
}

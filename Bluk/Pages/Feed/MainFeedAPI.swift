//
//  MainFeedAPI.swift
//  Bluk
//
//  Created by 이승윤 on 27/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import Ballcap
import RSMasterTableViewKit
import Firebase

class MainFeedAPI {
    
    fileprivate let testStringVal = "Te nec dicit aliquam, ei has rebum consul, soleat salutandi id mea. Ne purto duis pri, ea sea zril vitae. Pri omnium accusata ei, sit cu oporteat concludaturque. Eam ne oporteat torquatos eloquentiam, altera option ne mei. Ius alia dicat appellantur et.\n\nEum ne idque facilisi accusata, eu nonumy putent fastidii nec, cu mundi nemore commune his. Inani everti nam eu. Ei his facer apeirian, te usu vero iuvaret pertinacia, ne idque molestie oportere quo. Tale aperiri eu eam, qui at timeam intellegam, dolorem oporteat contentiones usu eu.\n\nVix doming officiis volutpat cu. Sed at nonumes sententiae, tibique mentitum consetetur no sit, eum vitae virtute argumentum no. Ea cum convenire consulatu. Duo dicta liber splendide in, nec ne alia decore perpetua, tation noster reprimique ut vel. At dicant urbanitas elaboraret duo, ut has nulla vituperatoribus.\n\nPro ei deleniti expetenda assentior. Ne iisque corpora mnesarchum mea. Duis expetendis definiebas in est. Quo in vide urbanitas, legere theophrastus ius ne. Porro inani possim sit cu."
    
    // *******Upload Functions*******
    func upload_incrementOneFeed_View(id:String){
        let currentFeed = MainFeed(id: id)
        currentFeed.data?.views = .increment(1)
        let b = Batch()
        b.update(currentFeed)
        b.commit()
    }
    
    func upload_TestFeed(_ no: Int, isNotice: Bool){
        let feed = MainFeed()
        var obj = _MainFeedObject()
        obj.views = 0
        obj.mainText = testStringVal
        obj.title = "This is a test title " + String(no)
        obj.subtitle = "This s a test subtitle " + String(no)
        obj.isNotice = isNotice
        let storRef = feed.storageReference

        let am = File(storRef, data: (UIImage(named: "139-500x400")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let bm = File(storRef, data: (UIImage(named: "337-500x400")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let cm = File(storRef, data: (UIImage(named: "400-500x400")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let dm = File(storRef, data: (UIImage(named: "524-500x400")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)

        let fivexfourArr = [am, bm, cm, dm]

        let storBatch = StorageBatch()
        storBatch.save(fivexfourArr)
        
        let batch = Batch()
        
        let imageCol = feed.collection(path: .mainImages)
        let sequence = stride(from: 0, to: fivexfourArr.count, by: 1)
        
        for element in sequence{
            var a = _imageFileObject()
            a.file = fivexfourArr[element]
            a.id = element
            let A = imageFile()
            A.data = a
            batch.save(A, to: imageCol)
        }
        
       

        let b1 = FeedDetail()
        let c1 = FeedDetail()
        let d1 = FeedDetail()
        let e1 = FeedDetail()
        let f1 = FeedDetail()


        let ai = File(b1.storageReference, data: (UIImage(named: "426-500x500")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let bi = File(c1.storageReference, data: (UIImage(named: "837-500x500")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let ci = File(d1.storageReference, data: (UIImage(named: "910-500x500")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let di = File(e1.storageReference, data: (UIImage(named: "910-500x500")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)
        let ei = File(f1.storageReference, data: (UIImage(named: "910-500x500")?.jpegData(compressionQuality: 1))!, mimeType: .jpeg)

        var B1 = _FeedDetailObject()
        B1.brand = "Maison Margiela"
        B1.price = "153"
        B1.image = ai
        b1.data = B1

        var C1 = _FeedDetailObject()
        C1.brand = "Gucci"
        C1.price = "213"
        C1.image = bi
        C1.link = URL(string: "https://facebook.com")
        c1.data = C1

        var D1 = _FeedDetailObject()
        D1.brand = "Balenciaga"
        D1.price = "313"
        D1.image = ci
        d1.data = D1

        var E1 = _FeedDetailObject()
        E1.brand = "Thom Browne"
        E1.price = "313"
        E1.image = di
        e1.data = E1

        var F1 = _FeedDetailObject()
        F1.brand = "Louis Vuitton"
        F1.price = "700"
        F1.image = ei
        f1.data = F1

        storBatch.save([ai, bi, ci, di, ei])
        let collection = feed.collection(path: .feedDetails)

        batch.save(f1, to: collection)
        batch.save(e1, to: collection)
        batch.save(d1, to: collection)
        batch.save(c1, to: collection)
        batch.save(b1, to: collection)

        feed.data = obj
        feed.feedDetails = [c1, d1, e1, f1, b1]
        
         batch.save(feed)

        storBatch.commit()
        batch.commit()
    }
    
    // *******Download Functions*******
    
    var numberOfFeeds = 20
    
    typealias feedDetailCallback = ([FeedDetailObject]?, Error?) -> ()
    typealias singleMainFeedCallback = (MainFeedObject?, Error?) -> ()
    typealias MainFeedsCallback = ([MainFeedObject]?, Error?) -> ()
    typealias updateLastObjCallback = (QueryDocumentSnapshot?, [MainFeedObject]?, Error?) -> ()
    typealias MainImagesCallback = ([imageFileObject]?, Error?) -> ()
    
    class func download_two_MainFeedObject(isNotice:Bool, completion: @escaping ([MainFeedObject]?, Error?) -> ()){
         MainFeed.order(by: "createdAt", descending: true)
            .where("isNotice", isEqualTo: isNotice)
            .limit(to: 2).get { (snapshot, error) in
                if let error = error {
                    completion(nil, error)
                }
                else{
                    if snapshot?.documents.count == 0 || snapshot!.isEmpty{
                        print("isEmpty two mf")
                        completion([], nil)
                    }
                    else{
                        print("exists?")
                       
                        var objs:[MainFeedObject] = []
                        
                        let group = DispatchGroup()
                        
                        for doc in snapshot!.documents{
                            group.enter()
                            let feed = MainFeed(snapshot: doc)
                            MainFeedAPI().convertToMainFeedObject(feed, completion: { (object, error) in
                                if let error = error{
                                    completion(nil, error)
                                    group.leave()
                                }
                                else{
                                    objs.append(object!)
                                    group.leave()
                                }
                            })
                        }
                        group.notify(queue: .main, execute: {
                            if objs.count > 1 {
                                let x = objs.sorted(by: { (obj1, obj2) -> Bool in
                                    obj1.date?.compare(obj2.date!) == ComparisonResult.orderedDescending
                                })
                                completion(x, nil)
                            }
                            else{
                                completion(objs, nil)
                            }
                        })
                        
                    }
                }
        }
    }
    
    
    
    func download_initial_MainFeedObject(completion: @escaping updateLastObjCallback){
        var lobj: QueryDocumentSnapshot?
        MainFeed.order(by: "createdAt", descending: true).limit(to: numberOfFeeds).get { (snapshot, error) in
           
            if let error = error {
                completion(nil, [], error)
            }
            else{
                if snapshot?.documents.count == 0 || snapshot!.isEmpty{
                    print("isEmpty mf")
                    completion(nil, [], nil)
                }
                else{
                    print("exists?")
                    lobj = snapshot?.documents.last
                    print("lobj:", lobj!.exists)
                    var objs:[MainFeedObject] = []
                    
                    let group = DispatchGroup()
                    
                    for doc in snapshot!.documents{
                        group.enter()
                        let feed = MainFeed(snapshot: doc)
                        self.convertToMainFeedObject(feed, completion: { (object, error) in
                            if let error = error{
                                completion(nil, nil, error)
                                group.leave()
                            }
                            else{
                                objs.append(object!)
                                group.leave()
                            }
                        })
                    }
                    group.notify(queue: .main, execute: {
                        print("notified!")
                        if objs.count > 1 {
                            let x = objs.sorted(by: { (obj1, obj2) -> Bool in
                                obj1.date?.compare(obj2.date!) == ComparisonResult.orderedDescending
                            })
                            completion(lobj, x, nil)
                        }
                        else{
                            completion(lobj, objs, nil)
                        }
                    })
                    
                }
            }
        }
    }
    
    func download_pagination_MainFeedObject(lastObj:QueryDocumentSnapshot?, completion: @escaping updateLastObjCallback){
        var newlo:QueryDocumentSnapshot?
        if let obj = lastObj{
            MainFeed.order(by: "createdAt", descending: true).start(afterDocument: obj).limit(to: numberOfFeeds).get { (snapshot, error) in
                if let error = error {
                    completion(nil, nil, error)
                }
                else{
                    if snapshot?.documents.count == 0 || snapshot!.isEmpty{
                        completion(nil, [], nil)
                    }
                    else{
                        newlo = snapshot?.documents.last
                        var objs:[MainFeedObject] = []
                        let group = DispatchGroup()
                        for doc in snapshot!.documents{
                            group.enter()
                            let feed = MainFeed(snapshot: doc)
                            self.convertToMainFeedObject(feed, completion: { (object, error) in
                                if let error = error{
                                    completion(nil, nil, error)
                                    group.leave()
                                }
                                else{
                                    objs.append(object!)
                                    group.leave()
                                }
                            })
                        }
                        
                        group.notify(queue: .main, execute: {
                            completion(newlo, objs, nil)
                        })
                    }
                }
            }
        }
        else{
            completion(lastObj, [], nil)
        }
    }
    
  
    
    func download_single_MainFeedObject(id:String, completion: @escaping singleMainFeedCallback){
        MainFeed.get(id: id) { (feed, error) in
            if let error = error {
                completion(nil, error)
            }
            else{
                self.convertToMainFeedObject(feed, completion: { (obj, error) in
                    completion(obj, error)
                })
            }
        }
    }
    
    private func download_All_feedDetailObject(_ colRef: CollectionReference, completion: @escaping feedDetailCallback){
        colRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            }
            else{
                
                var res:[FeedDetailObject] = []
                //POSSIBLE GCD?
                for doc in snapshot!.documents{
                   
                    
                    var obj = FeedDetailObject()
                    let fd = FeedDetail(snapshot: doc)
                    
                    obj.brand = fd?.data?.brand
                    obj.image = fd?.data?.image
                    obj.link = fd?.data?.link
                    obj.price = fd?.data?.price
                    
                    res.append(obj)
              
                }
                
                completion(res, nil)
            }
        }
    }
    
    private func download_All_MainImageObject(_ colRef: CollectionReference, completion: @escaping MainImagesCallback){
        colRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            }
            else{
                
                var res:[imageFileObject] = []
                //POSSIBLE GCD?
                for doc in snapshot!.documents{
                    
                    
                    var obj = imageFileObject()
                    let imgf = imageFile(snapshot: doc)
                    
                    obj.file = imgf?.data?.file
                    obj.id = imgf?.data?.id
                    
                    res.append(obj)
                    
                }
                
                completion(res, nil)
            }
        }
    }
    
    func download_initial_NoticeObject(completion: @escaping updateLastObjCallback){
        var lobj: QueryDocumentSnapshot?
        MainFeed.where("isNotice", isEqualTo: true).order(by: "createdAt", descending: true).limit(to: numberOfFeeds).get { (snapshot, error) in
            
            if let error = error {
                completion(nil, [], error)
            }
            else{
                if snapshot?.documents.count == 0 || snapshot!.isEmpty {
                    print("isEmpty")
                    completion(nil, [], nil)
                }
                else{
                    print("exists?")
                    lobj = snapshot?.documents.last
                    print("lobj:", lobj!.exists)
                    var objs:[MainFeedObject] = []
                    
                    let group = DispatchGroup()
                    
                    for doc in snapshot!.documents{
                        group.enter()
                        let feed = MainFeed(snapshot: doc)
                        self.convertToMainFeedObject(feed, completion: { (object, error) in
                            if let error = error{
                                completion(nil, nil, error)
                                group.leave()
                            }
                            else{
                                objs.append(object!)
                                group.leave()
                            }
                        })
                    }
                    group.notify(queue: .main, execute: {
                        if objs.count > 1 {
                            let x = objs.sorted(by: { (obj1, obj2) -> Bool in
                                obj1.date?.compare(obj2.date!) == ComparisonResult.orderedDescending
                            })
                            completion(lobj, x, nil)
                        }
                        else{
                            completion(lobj, objs, nil)
                        }
                    })
                    
                }
            }
        }
    }
    
    func download_pagination_NoticeObject(lastObj:QueryDocumentSnapshot?, completion: @escaping updateLastObjCallback){
        var newlo:QueryDocumentSnapshot?
        if let obj = lastObj{
            MainFeed.where("isNotice", isEqualTo: true).order(by: "createdAt", descending: true).start(afterDocument: obj).limit(to: numberOfFeeds).get { (snapshot, error) in
                if let error = error {
                    completion(nil, nil, error)
                }
                else{
                    if snapshot?.documents.count == 0 || snapshot!.isEmpty{
                        completion(nil, [], nil)
                    }
                    else{
                        newlo = snapshot?.documents.last
                        var objs:[MainFeedObject] = []
                        let group = DispatchGroup()
                        for doc in snapshot!.documents{
                            group.enter()
                            let feed = MainFeed(snapshot: doc)
                            self.convertToMainFeedObject(feed, completion: { (object, error) in
                                if let error = error{
                                    completion(nil, nil, error)
                                    group.leave()
                                }
                                else{
                                    objs.append(object!)
                                    group.leave()
                                }
                            })
                        }
                        
                        group.notify(queue: .main, execute: {
                            completion(newlo, objs, nil)
                        })
                    }
                }
            }
        }
        else{
            completion(lastObj, [], nil)
        }
    }
    
    //*******Conversion*******
    
    fileprivate func convertToMainFeedObject(_ feed: MainFeed?, completion: @escaping singleMainFeedCallback) {
        let data = feed?.data
        var oerror:Error?
        var obj = MainFeedObject()
        obj.date = feed?.createdAt.dateValue()
        obj.views = (data?.views).map { Int($0.rawValue) }
        obj.mainText = data?.mainText
        obj.subtitle = data?.subtitle
        obj.title = data?.title
        obj.id = feed?.id
        
        let group = DispatchGroup()
        
        group.enter()
        if let imageReference = feed?.collection(path: .mainImages){
            self.download_All_MainImageObject(imageReference) { (imgs, error) in
                if let err = error {
                    oerror = err
                    group.leave()
                }
                else{
                    obj.mainImages = imgs
                    group.leave()
                }
            }
        }
        
        group.enter()
        if let collectionReference = feed?.collection(path: .feedDetails){
            self.download_All_feedDetailObject(collectionReference, completion: { (objs, error) in
                if let err = error {
                    oerror = err
                    group.leave()
                }
                else{
                    obj.feedDetails = objs
                    group.leave()
                }
            })
        }
        
        group.notify(queue: .main) {
            completion(obj, oerror)
        }
        
    }
    
}

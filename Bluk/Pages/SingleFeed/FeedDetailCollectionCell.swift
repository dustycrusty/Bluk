//
//  FeedDetailCollectionCell.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

class FeedDetailCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: FeedDetailObject) {
        if let b = model.brand{
            brand.text = b
        }
        if let p = model.price{
            price.text = "$" + p
        }
        if let path = model.image?.fullPath{
            let ref = Storage.storage().reference(withPath: path)
            ref.downloadURL(completion: { (url, error) in
                if let url = url{
                    self.image.af_setImage(withURL: url)
                    }
                if let error = error{
                    print(error.localizedDescription)
                }
            })
        }
        else{
            print("path was unavailable")
        }
    }
}

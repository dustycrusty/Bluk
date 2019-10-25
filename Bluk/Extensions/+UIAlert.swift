//
//  +UIAlert.swift
//  Bluk
//
//  Created by 이승윤 on 17/06/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    
    convenience init(title:String, message: String){
        self.init(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive)
        self.addAction(action)
    }
    
}

//
//  +Date.swift
//  Bluk
//
//  Created by 이승윤 on 30/05/2019.
//  Copyright © 2019 Dustin Lee. All rights reserved.
//

import Foundation
import Firebase
extension Date {
    func toStringFormat_Feed() -> String{
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        f.locale = Locale(identifier: "en_US")
        return "- " + f.string(from: self)
    }
}


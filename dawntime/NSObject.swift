//
//  NSObject.swift
//  dawntime
//
//  Created by PW486 on 31/12/2017.
//  Copyright © 2017 peaktime. All rights reserved.
//

import Foundation

extension NSObject{
    static var reuseIdentifier: String{
        return String(describing: self)
    }
}

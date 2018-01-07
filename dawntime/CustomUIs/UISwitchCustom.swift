//
//  UISwitchCustom.swift
//  dawntime
//
//  Created by PW486 on 05/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}

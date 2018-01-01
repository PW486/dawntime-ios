//
//  UIViewExtension.swift
//  dawntime
//
//  Created by PW486 on 01/01/2018.
//  Copyright © 2018 peaktime. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func removeAllSublayers() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}

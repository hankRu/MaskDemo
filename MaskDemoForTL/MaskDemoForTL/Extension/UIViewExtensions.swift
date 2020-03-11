//
//  UIViewExtensions.swift
//  MaskDemoForTL
//
//  Created by Hank Lu on 2020/3/11.
//  Copyright © 2020 Minhan Ru. All rights reserved.
//

import UIKit

extension UIView {
    func dialogViewLayer(cornerRadius: CGFloat) {
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    static var className: String {
        return String(describing: self)
    }
    
    var allSubviews: [UIView] {
        return self.subviews.reduce([UIView]()) { $0 + [$1] + $1.allSubviews }
    }
}

//
//  UITableView_Extension.swift
//  TWLifeInfo
//
//  Created by Frost on 2015/10/19.
//  Copyright © 2015年 Frost Chen. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func FCReloadSingleCellWithIndex(index:Int) {
        var updateIndexPaths:[IndexPath] = []
        
        let indexPath:IndexPath = IndexPath(row: index, section: 0)
        updateIndexPaths.append(indexPath)
        
        self.beginUpdates()
        self.reloadRows(at: updateIndexPaths, with: UITableView.RowAnimation.automatic)
        self.endUpdates()
    }
    
    func FCScrollToTop()  {
        if(self.cellForRow(at: IndexPath(row: 0, section: 0)) != nil) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 22)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

}

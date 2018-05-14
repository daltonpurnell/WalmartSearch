//
//  TableViewHelper.swift
//  WalmartSearch
//
//  Created by Dalton on 5/14/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {
    
    class func EmptyMessage(message:String, tableView:UITableView) {
        let rect = CGRect(origin: CGPoint(x: tableView.frame.origin.x,y :tableView.frame.origin.y), size: CGSize(width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let messageLabel = H1Label(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = Constants.Colors.lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel;
    }
}

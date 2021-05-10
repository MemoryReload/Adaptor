//
//  MyCell.swift
//  Adaptor_Example
//
//  Created by HePing on 2021/5/3.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Adaptor

class MyCell: UITableViewCell
{
    
}

extension TableCellViewHolder where T == MyCell {
    var cellHeight: CGFloat {
        return 20
    }
    
    func willDisplayWith(container: UITableView, cell: T, index: IndexPath) { }
}

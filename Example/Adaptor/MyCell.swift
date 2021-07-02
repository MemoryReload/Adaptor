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
    override class func awakeFromNib() {
        print("Dada! it works")
    }
    override func update(data: Any?) {
        self.textLabel?.text = data as? String ?? "-"
    }
}

class MyCollectionCell: UICollectionViewCell
{
    override class func awakeFromNib() {
        print("Dada! it works")
    }
    override func update(data: Any?) {
//        self.textLabel?.text = data as? String ?? "-"
        self.contentView.backgroundColor = .red
    }
}

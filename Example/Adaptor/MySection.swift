//
//  MySection.swift
//  Adaptor_Example
//
//  Created by 何平 on 2021/5/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Adaptor

class MySection: UITableViewHeaderFooterView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        print("Dada! it works")
    }
    
    override func update(data: Any?) {
        titleLabel.text = data as? String
    }
}


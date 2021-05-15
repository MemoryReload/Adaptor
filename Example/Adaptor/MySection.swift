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
    @IBOutlet var content: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        print("Dada! it works")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        Bundle.main.loadNibNamed("MySection", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(data: Any?) {
        titleLabel.text = data as? String
    }
}


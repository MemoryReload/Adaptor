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
    var collapsed: Bool!
    @IBOutlet var content: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
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
    
    override func update(data: Any?, collasped: Bool, count: Int) {
        let headerStr = data as? String ?? ""
        titleLabel.text = "\(headerStr): \(count)"
        self.collapsed = collasped
        let title = self.collapsed ? "展开" : "收起"
        actionButton.setTitle(title, for: .normal)
    }
    
    @IBAction func doAction(_ sender: Any) {
        let event = self.collapsed ? SectionExpandEvent : SectionCollapseEvent
        sendEvent(withName: event)
    }
}


class MyCollectionSection: UICollectionReusableView {
    var collapsed: Bool!
    @IBOutlet var content: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    override func awakeFromNib() {
        print("Dada! it works")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("MySection", owner: self, options: nil)
        addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(data: Any?, collasped: Bool, count: Int) {
        let headerStr = data as? String ?? ""
        titleLabel.text = "\(headerStr): \(count)"
        self.collapsed = collasped
        let title = self.collapsed ? "展开" : "收起"
        actionButton.setTitle(title, for: .normal)
    }
    
    @IBAction func doAction(_ sender: Any) {
        let event = self.collapsed ? SectionExpandEvent : SectionCollapseEvent
        sendEvent(withName: event)
    }
}



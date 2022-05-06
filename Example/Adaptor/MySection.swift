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
import SnapKit

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
    
    override func update(data: Any?, collapsed: Bool, count: Int) {
        let headerStr = data as? String ?? ""
        titleLabel.text = "\(headerStr): \(count)"
        self.collapsed = collapsed
        let title = self.collapsed ? "展开" : "收起"
        actionButton.setTitle(title, for: .normal)
    }
    
    @IBAction func doAction(_ sender: Any) {
        let event = self.collapsed ? SectionExpandEvent : SectionCollapseEvent
        sendEvent(withName: event)
    }
}

class AutoResizeSection: UITableViewHeaderFooterView {
    
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        return tl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(data: Any?, collapsed: Bool, count: Int) {
        let headerStr = data as? String ?? ""
        titleLabel.text = "\(headerStr)-\(count)"
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
    
    override func update(data: Any?, collapsed: Bool, count: Int) {
        let headerStr = data as? String ?? ""
        titleLabel.text = "\(headerStr): \(count)"
        self.collapsed = collapsed
        let title = self.collapsed ? "展开" : "收起"
        actionButton.setTitle(title, for: .normal)
    }
    
    @IBAction func doAction(_ sender: Any) {
        let event = self.collapsed ? SectionExpandEvent : SectionCollapseEvent
        sendEvent(withName: event)
    }
}



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
import SnapKit

class MyCell: UITableViewCell
{
    override func update(data: Any?) {
        self.textLabel?.text = data as? String ?? "-"
    }
}

class MyAutoSizeCell: UITableViewCell {
    
    lazy var nameLabel: UILabel = {
        let l: UILabel = UILabel()
        l.font = UIFont.systemFont(ofSize: 22)
        l.textColor = UIColor.red
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(20)
            maker.top.equalToSuperview().offset(40)
            maker.bottom.equalToSuperview().offset(-40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(data: Any?) {
        self.nameLabel.text = data as? String ?? "-"
    }
}

class MyCollectionCell: UICollectionViewCell
{
    lazy var nameLabel: UILabel = {
        let l: UILabel = UILabel()
        l.font = UIFont.systemFont(ofSize: 22)
        l.textColor = UIColor.darkText
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        backgroundColor = .green
        nameLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func update(data: Any?) {
        self.nameLabel.text = data as? String ?? "-"
    }
}

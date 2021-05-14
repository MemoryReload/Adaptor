//
//  SectionViewModel.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

public class TableSectionViewHolder: SectionViewHolderBaseProtocol {
    
    public var headerData: Any?
    public var headerHeight: CGFloat?
    public var headerViewClass: UITableViewHeaderFooterView.Type?
    
    
    public var footerData: Any?
    public var footerHeight: CGFloat?
    public var footerViewClass: UITableViewHeaderFooterView.Type?
    
    public var cellHodlers: [TableCellViewHolder]?
    public var collapsed: Bool = false
    public var cellCounts: Int {
        get{
            if collapsed {
                return 0
            }
            return cellHodlers?.count ?? 0
        }
    }
    public init() { }
}

extension TableSectionViewHolder: SectionViewHolderEventProtocol {
    
}

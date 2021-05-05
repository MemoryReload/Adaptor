//
//  SectionViewModel.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

typealias ViewHeightClosure = (Any?) -> CGFloat

public struct TableSectionViewHolder<T: CellViewHolderBaseProtocol & CellViewHolderEventProtocol, U: TableCellViewUpdateProtocol > {
    
    var headerData: Any?
    var headerHeight: ViewHeightClosure
    var headerViewClass: U.Type
    
    
    var footerData: Any?
    var footerHeight: ViewHeightClosure
    var footerViewClass: U.Type
    
    var cellHodlers: [T]?
    var collapsed: Bool = false
    var cellCounts: Int {
        get{
            if collapsed {
                return 0
            }
            return cellHodlers?.count ?? 0
        }
    }
}

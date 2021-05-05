//
//  CollectionSectionViewHodler.swift
//  Adaptor
//
//  Created by HePing on 2021/5/3.
//

import Foundation

//typealias ViewHeightClosure = (Any?) -> CGFloat

public struct CollectionSectionViewHolder<T: CellViewHolderBaseProtocol & CellViewHolderEventProtocol, U: CollectionReusableViewUpdateProtocol > {
    
    var headerData: Any?
    var headerViewClass: U.Type
    
    
    var footerData: Any?
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

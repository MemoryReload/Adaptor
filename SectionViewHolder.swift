//
//  SectionViewModel.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

typealias ViewHeightClosure = (Any?) -> CGFloat

protocol ViewUpdateProtocol {
    func update(data:Any?)
}

extension UIView: ViewUpdateProtocol
{
    func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

public struct SectionViewHolder {
    
    var headerData: Any?
    var headerHeight: ViewHeightClosure
    var headerViewClass: UIView.Type
    
    
    var footerData: Any?
    var footerHeight: ViewHeightClosure
    var footerViewClass: UIView.Type
    
    var cellHodlers: [CellViewHolder]?
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

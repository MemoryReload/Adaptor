//
//  SectionViewHolder.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/13.
//

import Foundation

public protocol SectionViewHolderBaseProtocol {
    associatedtype CellHolderClass
    associatedtype SectionViewClass
    
    var headerData: Any? { get set }
    var headerViewClass: SectionViewClass.Type? { get set }
    
    
    var footerData: Any? { get set }
    var footerViewClass: SectionViewClass.Type? { get set }
    
    var cellHodlers: [CellHolderClass]? { get set }
    var collapsed: Bool { get set }
    var cellCounts: Int { get }
}

public protocol SectionViewHolderEventProtocol {
    
}
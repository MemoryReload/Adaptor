//
//  CellViewHolder+UITableView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

public struct TableCellViewHolder<T: UITableViewCell>: CellViewHolderBaseProtocol {
    public typealias CellClass = T
    
    public var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: CellClass.Type
}

extension TableCellViewHolder: CellViewHolderEventProtocol {
    public typealias ContainerClass = UITableView
    
    public func willDisplayWith(container: UITableView, cell: T, index: IndexPath) { }
    public func didEndDisplayWith(container: UITableView, cell: T, index: IndexPath) { }
    
    public func willSelectWith(container: UITableView, cell: T, index: IndexPath) { }
    public func didSelectWith(container: UITableView, cell: T, index: IndexPath) { }
    
    public func willDeselectWith(container: UITableView, cell: T, index: IndexPath) { }
    public func didDeselectWith(container: UITableView, cell: T, index: IndexPath) { }
}

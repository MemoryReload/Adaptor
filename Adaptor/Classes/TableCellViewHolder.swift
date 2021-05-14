//
//  CellViewHolder+UITableView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

open class TableCellViewHolder: CellViewHolderBaseProtocol {
    public typealias CellClass = UITableViewCell
    
    open var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: UITableViewCell.Type?
    
    public init() { }
}

extension TableCellViewHolder: CellViewHolderEventProtocol {
    public typealias ContainerClass = UITableView
    
    @objc public func willDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    @objc public func didEndDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    @objc public func willSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    @objc public func didSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    @objc public func willDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    @objc public func didDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
}

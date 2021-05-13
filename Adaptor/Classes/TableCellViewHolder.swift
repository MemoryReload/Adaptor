//
//  CellViewHolder+UITableView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

public class TableCellViewHolder: CellViewHolderBaseProtocol {
    public typealias CellClass = UITableViewCell
    
    public var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: UITableViewCell.Type?
}

extension TableCellViewHolder: CellViewHolderEventProtocol {
    public typealias ContainerClass = UITableView
    
    public func willDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    public func didEndDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    public func willSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    public func didSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    public func willDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    public func didDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
}

//
//  CellViewHolder+UITableView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

open class TableCellViewHolder: CellViewHolderBaseProtocol {
    public typealias CellClass = UITableViewCell
    
    
    /// If cell is fixed height, assign the proper height for the cell. If nil, the cell
    /// will be auto-dimensioned. Default is nil.
    public var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: UITableViewCell.Type?
    
    public required init() { }
    
    public convenience init(data: Any?, cellClass: UITableViewCell.Type?, cellHeight: CGFloat? = nil) {
        self.init()
        cellData = data
        self.cellClass = cellClass
        self.cellHeight = cellHeight
    }
}

extension TableCellViewHolder: TableCellViewHolderEventProtocol {
    public typealias ContainerClass = UITableView
    
    @objc open func didUpdateWith(container: UITableView, cell: UITableViewCell, index: IndexPath) {
        cell.update(data: cellData)
    }
    
    @objc open func willDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    @objc open func didEndDisplayWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    @objc open func shouldSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) -> Bool { return true }
    @objc open func shouldDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) -> Bool { return true }
    
    @objc open func didSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    @objc open func didDeselectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) { }
    
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UITableView, cell: UITableViewCell, index: IndexPath) { }
}

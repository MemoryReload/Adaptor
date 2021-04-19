//
//  CellViewHolder.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

protocol CellViewHolderProtocol {
    func willDisplayWith(tableView: UITableView, cell: UITableViewCell, index:IndexPath)
    func didEndDisplayWith(tableView: UITableView, cell: UITableViewCell, index:IndexPath)
    
    func willSelectWith(tableView: UITableView,  index:IndexPath)
    func didSelectWith(tableView: UITableView,  index:IndexPath)
    
    func willDeselectWith(tableView: UITableView, index:IndexPath)
    func didDeselectWith(tableView: UITableView, index:IndexPath)
}

struct CellViewHolder {
    var cellData: Any?
    var cellHeight: ViewHeightClosure
    var cellClass: UITableViewCell.Type
}

extension CellViewHolder: CellViewHolderProtocol
{
    func willDeselectWith(tableView: UITableView,  index: IndexPath) { }
    func didDeselectWith(tableView: UITableView,  index: IndexPath) { }
    
    func willSelectWith(tableView: UITableView, index: IndexPath) { }
    func didSelectWith(tableView: UITableView, index: IndexPath) { }
    
    func willDisplayWith(tableView: UITableView, cell: UITableViewCell, index: IndexPath) { }
    func didEndDisplayWith(tableView: UITableView, cell: UITableViewCell, index: IndexPath) { }
}

//
//  UITableView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"

extension Adaptor where T: UITableView {
    //MARK: DataHandling
    public var dataSource:[TableSectionViewHolder<TableCellViewHolder<UITableViewCell>,UITableViewHeaderFooterView>]? {
        get {
            return objc_getAssociatedObject(self, &dataSourceKey) as! [TableSectionViewHolder]?
        }
        set {
            objc_setAssociatedObject(self, &dataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        guard let cellClass = cellHolder?.cellClass else { return UITableViewCell() }
        if let cell = cellClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(cellClass)) {
            cell.update(data: cellHolder?.cellData)
            return cell
        }
        let cell = cellClass.init(style: .default, reuseIdentifier: NSStringFromClass(cellClass))
        cell.update(data: cellHolder?.cellData)
        return cell
    }
    //MARK: ViewDelegate
    //MARK: Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        guard let height = cellHolder?.cellHeight else { return UITableViewAutomaticDimension }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.willDisplayWith(container: tableView, cell: cell, index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.didEndDisplayWith(container: tableView, cell: cell, index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.willSelectWith(container: tableView, cell:cell , index: indexPath)
        return indexPath
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.willDeselectWith(container: tableView, cell: cell, index: indexPath)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.didSelectWith(container: tableView, cell: cell, index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.didDeselectWith(container: tableView, cell: cell, index: indexPath)
    }
    
    //MARK: Section Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource?[section]
        if let heightCallback = sectionHolder?.headerHeight  {
            return heightCallback(sectionHolder?.headerData)
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHolder = dataSource?[section]
        guard let headerViewClass  = sectionHolder?.headerViewClass  else { return nil }
        if let headerView = headerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(headerViewClass)) {
            headerView.update(data: sectionHolder?.headerData)
            return headerView
        }
        let headerView = headerViewClass.init(reuseIdentifier:NSStringFromClass(headerViewClass))
        headerView.update(data: sectionHolder?.headerData)
        return headerView
    }
    
    //MARK: Section Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource?[section]
        if let heightCallback = sectionHolder?.footerHeight  {
            return heightCallback(sectionHolder?.footerData)
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionHolder = dataSource?[section]
        guard let footerViewClass  = sectionHolder?.footerViewClass else { return nil }
        if let footerView = footerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(footerViewClass)) {
            footerView.update(data: sectionHolder?.footerData)
            return footerView
        }
        let footerView = footerViewClass.init(reuseIdentifier:NSStringFromClass(footerViewClass))
        footerView.update(data: sectionHolder?.footerData)
        return footerView
    }
    
}

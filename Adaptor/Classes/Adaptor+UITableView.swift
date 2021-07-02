//
//  UITableView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"

extension TableAdaptor: UITableViewDataSource {
    //MARK: DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        guard let cellClass = cellHolder?.cellClass else { return UITableViewCell() }
        if let cell = cellClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(cellClass)) {
            cell.cellEventHandler = self
            cell.update(data: cellHolder?.cellData)
            return cell
        }
        let cell = cellClass.init(style: .default, reuseIdentifier: NSStringFromClass(cellClass))
        cell.cellEventHandler = self
        cell.update(data: cellHolder?.cellData)
        return cell
    }
}

extension TableAdaptor: UITableViewDelegate {
    //MARK: ViewDelegate
    //MARK: Cell
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        guard let height = cellHolder?.cellHeight else { return UITableViewAutomaticDimension }
        return height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.willDisplayWith(container: tableView, cell: cell, index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didEndDisplayWith(container: tableView, cell: cell, index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        let shouldSelect = cellHolder?.shouldSelectWith(container: tableView, cell: cell, index: indexPath) ?? false
        return shouldSelect ? indexPath : nil
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        let shouldSelect = cellHolder?.shouldDeselectWith(container: tableView, cell: cell, index: indexPath) ?? false
        return shouldSelect ? indexPath : nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didSelectWith(container: tableView, cell: cell, index: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didDeselectWith(container: tableView, cell: cell, index: indexPath)
    }
    //MARK: Section Header
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource?[section]
        if let height = sectionHolder?.headerHeight  {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionHolder = dataSource?[section], let headerViewClass  = sectionHolder.headerViewClass  else { return nil }
        if let headerView = headerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(headerViewClass)) {
            headerView.index = section
            headerView.type = .Header
            headerView.sectionEventHandler = self
            headerView.update(data: sectionHolder.headerData, collasped: sectionHolder.collapsed, count: sectionHolder.cellHolders.count)
            return headerView
        }
        let headerView = headerViewClass.init(reuseIdentifier:NSStringFromClass(headerViewClass))
        headerView.index = section
        headerView.type = .Header
        headerView.sectionEventHandler = self
        headerView.update(data: sectionHolder.headerData, collasped: sectionHolder.collapsed, count: sectionHolder.cellHolders.count)
        return headerView
    }
    
    //MARK: Section Footer
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource?[section]
        if let height = sectionHolder?.footerHeight  {
            return height
        }
        return UITableViewAutomaticDimension
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let sectionHolder = dataSource?[section], let footerViewClass  = sectionHolder.footerViewClass else { return nil }
        if let footerView = footerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(footerViewClass)) {
            footerView.index = section
            footerView.type = .Footer
            footerView.sectionEventHandler = self
            footerView.update(data: sectionHolder.footerData, collasped: sectionHolder.collapsed, count: sectionHolder.cellHolders.count)
            return footerView
        }
        let footerView = footerViewClass.init(reuseIdentifier:NSStringFromClass(footerViewClass))
        footerView.index = section
        footerView.type = .Footer
        footerView.sectionEventHandler = self
        footerView.update(data: sectionHolder.footerData, collasped: sectionHolder.collapsed, count: sectionHolder.cellHolders.count)
        return footerView
    }
}

extension TableAdaptor: ViewCustomEventhandling
{
    typealias CellClass = UITableViewCell
    typealias SectionViewClass = UITableViewHeaderFooterView
    
    func handleEvent(withName name: ViewCustomEventName, cell: UITableViewCell) {
        if handle(cell: cell, event: name) { return }
        guard let table = view, let indexPath = table.indexPath(for: cell) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.handleEvent(withName: name, container: table, cell: cell, index: indexPath)
    }
    
    func handleEvent(withName name: ViewCustomEventName, sectionView: UITableViewHeaderFooterView) {
        guard let table = view, let index = sectionView.index, let type = sectionView.type else { return }
        switch type {
        case .Header:
            if handle(sectionHeader: sectionView, event: name) { return }
            dataSource?[index].handleEvent(withName: name, container: table, header: sectionView, forSection: index)
        case .Footer:
            if handle(sectionFooter: sectionView, event: name) { return }
            dataSource?[index].handleEvent(withName: name, container: table, footer: sectionView, forSection: index)
        }
    }
    
    @objc public func handle(cell: UITableViewCell, event: ViewCustomEventName) -> Bool {
        if event == CellRemovedEvent, let indexPath = self.view?.indexPath(for: cell) {
            self.dataSource?[indexPath.section].cellHolders.remove(at: indexPath.row)
            self.view?.deleteRows(at: [indexPath], with: .automatic)
            return true
        }else {
            return false
        }
    }
    
    @objc public func handle(sectionHeader: UITableViewHeaderFooterView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let index = sectionHeader.index {
            self.dataSource?[index].collapsed = false
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else if event == SectionCollapseEvent, let index = sectionHeader.index {
            self.dataSource?[index].collapsed = true
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else {
            return false
        }
    }
    
    @objc public func handle(sectionFooter: UITableViewHeaderFooterView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let index = sectionFooter.index {
            self.dataSource?[index].collapsed = false
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else if event == SectionCollapseEvent, let index = sectionFooter.index {
            self.dataSource?[index].collapsed = true
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else {
            return false
        }
    }
}

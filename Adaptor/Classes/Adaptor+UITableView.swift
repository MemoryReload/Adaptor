//
//  UITableView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

extension TableAdaptor: UITableViewDataSource {
    //MARK: DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].cellCounts
    }
    
    @objc open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        guard let cellClass = cellHolder.cellClass else { return UITableViewCell() }
        if let cell = cellClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(cellClass)) {
            cell.cellEventHandler = self
            cellHolder.didUpdateWith(container: tableView, cell: cell, index: indexPath)
            return cell
        }
        let cell = cellClass.init(style: .default, reuseIdentifier: NSStringFromClass(cellClass))
        cell.cellEventHandler = self
        cellHolder.didUpdateWith(container: tableView, cell: cell, index: indexPath)
        return cell
    }
}

extension TableAdaptor: UITableViewDelegate {
    //MARK: ViewDelegate
    //MARK: Cell
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        guard let height = cellHolder.cellHeight else { return UITableViewAutomaticDimension }
        return height
    }
    
    @objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.willDisplayWith(container: tableView, cell: cell, index: indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section < dataSource.count, indexPath.row < dataSource[indexPath.section].cellCounts {
            let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
            cellHolder.didEndDisplayWith(container: tableView, cell: cell, index: indexPath)
        }
    }
    
    @objc open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        let shouldSelect = cellHolder.shouldSelectWith(container: tableView, cell: cell, index: indexPath) 
        return shouldSelect ? indexPath : nil
    }

    @objc open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil}
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        let shouldSelect = cellHolder.shouldDeselectWith(container: tableView, cell: cell, index: indexPath) 
        return shouldSelect ? indexPath : nil
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.didSelectWith(container: tableView, cell: cell, index: indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.didDeselectWith(container: tableView, cell: cell, index: indexPath)
    }
    //MARK: Section Header
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource[section]
        if let height = sectionHolder.headerHeight  {
            return height
        }
        return UITableViewAutomaticDimension
    }
    
    @objc open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHolder = dataSource[section]
        guard  let headerViewClass  = sectionHolder.headerViewClass  else { return nil }
        if let headerView = headerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(headerViewClass)) {
            headerView.index = section
            headerView.type = .Header
            headerView.sectionEventHandler = self
            sectionHolder.didUpdateWith(container: tableView, header: headerView, forSection: section)
            return headerView
        }
        let headerView = headerViewClass.init(reuseIdentifier:NSStringFromClass(headerViewClass))
        headerView.index = section
        headerView.type = .Header
        headerView.sectionEventHandler = self
        sectionHolder.didUpdateWith(container: tableView, header: headerView, forSection: section)
        return headerView
    }
    
    @objc open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let sectionViewHolder = dataSource[section]
        sectionViewHolder.willDisplayWith(container: tableView, header: view as! UITableViewHeaderFooterView, forSection: section)
    }
    
    @objc open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section < dataSource.count {
            let sectionViewHolder = dataSource[section]
            sectionViewHolder.didEndDisplayWith(container: tableView, header: view as! UITableViewHeaderFooterView, forSection: section)
        }
    }
    
    //MARK: Section Footer
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionHolder = dataSource[section]
        if let height = sectionHolder.footerHeight  {
            return height
        }
        return UITableViewAutomaticDimension
    }

    @objc open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionHolder = dataSource[section]
        guard let footerViewClass  = sectionHolder.footerViewClass else { return nil }
        if let footerView = footerViewClass.dequeue(from: tableView, withIdentifier: NSStringFromClass(footerViewClass)) {
            footerView.index = section
            footerView.type = .Footer
            footerView.sectionEventHandler = self
            sectionHolder.didUpdateWith(container: tableView, footer: footerView, forSection: section)
            return footerView
        }
        let footerView = footerViewClass.init(reuseIdentifier:NSStringFromClass(footerViewClass))
        footerView.index = section
        footerView.type = .Footer
        footerView.sectionEventHandler = self
        sectionHolder.didUpdateWith(container: tableView, footer: footerView, forSection: section)
        return footerView
    }
    
    @objc open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let sectionViewHolder = dataSource[section]
        sectionViewHolder.willDisplayWith(container: tableView, footer: view as! UITableViewHeaderFooterView, forSection: section)
    }
    
    @objc open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if section < dataSource.count {
            let sectionViewHolder = dataSource[section]
            sectionViewHolder.didEndDisplayWith(container: tableView, footer: view as! UITableViewHeaderFooterView, forSection: section)
        }
    }
}

extension TableAdaptor: ViewCustomEventhandling
{
    typealias CellClass = UITableViewCell
    typealias SectionViewClass = UITableViewHeaderFooterView
    
    func handleEvent(withName name: ViewCustomEventName, cell: UITableViewCell) {
        if handle(cell: cell, event: name) { return }
        guard let table = view, let indexPath = table.indexPath(for: cell) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.handleEvent(withName: name, container: table, cell: cell, index: indexPath)
    }
    
    func handleEvent(withName name: ViewCustomEventName, sectionView: UITableViewHeaderFooterView) {
        guard let table = view, let index = sectionView.index, let type = sectionView.type else { return }
        switch type {
        case .Header:
            if handle(sectionHeader: sectionView, event: name) { return }
            dataSource[index].handleEvent(withName: name, container: table, header: sectionView, forSection: index)
        case .Footer:
            if handle(sectionFooter: sectionView, event: name) { return }
            dataSource[index].handleEvent(withName: name, container: table, footer: sectionView, forSection: index)
        }
    }
    
    /// Handle event emitted by cell.
    /// - Parameters:
    ///   - cell: The cell which emits the specified event
    ///   - event: event name
    /// - Returns: The adaptor successfully handled the event or not
    /// - Note: If the event isn't handled by the adaptor, it will be forwarded to the cell holder
    /// for further processing. for subclassing, you should call super  if you want the default
    /// event handling behaviour.
    @objc open func handle(cell: UITableViewCell, event: ViewCustomEventName) -> Bool {
        if event == CellRemovedEvent, let indexPath = self.view?.indexPath(for: cell) {
            self.dataSource[indexPath.section].cellHolders.remove(at: indexPath.row)
            self.view?.deleteRows(at: [indexPath], with: .automatic)
            return true
        }else {
            return false
        }
    }
    
    /// Handle event emitted by sectionHeader.
    /// - Parameters:
    ///   - sectionHeader: The sectionHeader which emits the specified event
    ///   - event: event name
    /// - Returns: The adaptor successfully handled the event or not
    /// - Note: If the event isn't handled by the adaptor, it will be forwarded to the section view holder
    /// for further processing. for subclassing, you should call super  if you want the default
    /// event handling behaviour.
    @objc open func handle(sectionHeader: UITableViewHeaderFooterView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let index = sectionHeader.index {
            self.dataSource[index].collapsed = false
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else if event == SectionCollapseEvent, let index = sectionHeader.index {
            self.dataSource[index].collapsed = true
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else {
            return false
        }
    }
    
    /// Handle event emitted by sectionFooter.
    /// - Parameters:
    ///   - cell: The sectionFooter which emits the specified event
    ///   - event: event name
    /// - Returns: The adaptor successfully handled the event or not
    /// - Note: If the event isn't handled by the adaptor, it will be forwarded to the section view holder
    /// for further processing. for subclassing, you should call super  if you want the default
    /// event handling behaviour.
    @objc open func handle(sectionFooter: UITableViewHeaderFooterView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let index = sectionFooter.index {
            self.dataSource[index].collapsed = false
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else if event == SectionCollapseEvent, let index = sectionFooter.index {
            self.dataSource[index].collapsed = true
            self.view?.reloadSections([index], with: .automatic)
            return true
        }else {
            return false
        }
    }
}



extension  TableAdaptor {
    public convenience init(section:TableSectionViewHolder? = nil , datas:[Any], cellClass: UITableViewCell.Type, cellHeight: CGFloat? = nil) {
        self.init()
        appendToLast(section: section, datas: datas, cellClass: cellClass, cellHeight: cellHeight)
    }
    
    @discardableResult
    public func append(toSection sectionIndex: Int, withDatas datas:[Any], cellClass: UITableViewCell.Type, cellHeight: CGFloat? = nil) -> Bool {
        if sectionIndex < dataSource.count {
            let section = dataSource[sectionIndex]
            for data in datas {
                let cellHolder = TableCellViewHolder(data: data, cellClass: cellClass, cellHeight: cellHeight)
                section.cellHolders.append(cellHolder)
            }
            return true
        }
        return false
    }
    
    @discardableResult
    public func clear(section sectionIndex: Int) -> Bool {
        if sectionIndex < dataSource.count {
            let section = dataSource[sectionIndex]
            section.cellHolders.removeAll()
            return true
        }
        return false
    }
    
    @discardableResult
    public func set(section sectionIndex: Int, withDatas datas:[Any], cellClass: UITableViewCell.Type, cellHeight: CGFloat? = nil) -> Bool {
        if clear(section: sectionIndex) {
            return append(toSection: sectionIndex, withDatas: datas, cellClass: cellClass)
        }
        return false
    }
    
    public func appendToLast(section:TableSectionViewHolder? = nil, datas:[Any], cellClass: UITableViewCell.Type, cellHeight: CGFloat? = nil) {
        if let _section = section {
            dataSource.append(_section)
        }else{
            if dataSource.count == 0 {
                let  singleSection = TableSectionViewHolder()
                singleSection.headerHeight = 0
                singleSection.footerHeight = 0
                dataSource.append(singleSection)
            }
        }
        append(toSection: dataSource.count - 1, withDatas: datas, cellClass: cellClass)
    }
}


extension TableAdaptor {
    func getSectionHolder(withHeaderData headerData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (Int?, TableSectionViewHolder?) {
        for (index, section) in dataSource.enumerated() {
            if comparisonHandler(headerData,section.headerData) {
                return (index, section)
            }
        }
        return (nil, nil)
    }
    
    func getSectionHolder(withFooterData footerData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (Int?, TableSectionViewHolder?) {
        for (index, section) in dataSource.enumerated() {
            if comparisonHandler(footerData,section.footerData) {
                return (index, section)
            }
        }
        return (nil, nil)
    }
    
    func getCellHolder(withCellData cellData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (IndexPath?, TableCellViewHolder?) {
        for (sIndex, section) in dataSource.enumerated() {
            for (cIndex, cell) in section.cellHolders.enumerated() {
                if comparisonHandler(cellData, cell.cellData) {
                    return (IndexPath(item: cIndex, section: sIndex), cell)
                }
            }
        }
        return (nil, nil)
    }
}

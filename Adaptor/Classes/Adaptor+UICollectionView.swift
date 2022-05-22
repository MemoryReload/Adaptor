//
//  UICollectionView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

extension CollectionAdaptor: UICollectionViewDataSource{
    //MARK: DataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].cellCounts
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        guard let cellClass = cellHolder.cellClass else { return UICollectionViewCell() }
        let cell = cellClass.dequeue(from: collectionView, withIdentifier: NSStringFromClass(cellClass), indexPath: indexPath)
        cell.cellEventHandler = self
        cellHolder.didUpdateWith(container: collectionView, cell: cell, index: indexPath)
        return cell
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionViewHolder = dataSource[indexPath.section]
        if kind == UICollectionElementKindSectionHeader {
           guard let headerClass = sectionViewHolder.headerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
            let headerView = headerClass.dequeue(from: collectionView, ofKind: kind, withReuseIdentifier: NSStringFromClass(headerClass), for: indexPath)
            headerView.indexPath = indexPath
            headerView.kind = kind
            headerView.sectionEventHandler = self
            sectionViewHolder.didUpdateWith(container: collectionView, header: headerView, forSection: indexPath.section)
            return headerView
        }else if kind == UICollectionElementKindSectionFooter {
            guard let footerClass = sectionViewHolder.footerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
            let footerView = footerClass.dequeue(from: collectionView, ofKind: kind, withReuseIdentifier: NSStringFromClass(footerClass), for: indexPath)
            footerView.indexPath = indexPath
            footerView.kind = kind
            footerView.sectionEventHandler = self
            sectionViewHolder.didUpdateWith(container: collectionView, footer: footerView, forSection: indexPath.section)
            return footerView
        }else {
            guard let context = self.context else {
                print("Warning: You're supposed to provide the context for fetching other kinds of supplementary element!")
                return UICollectionReusableView(frame: CGRect.zero)
            }
            let reusableView = context.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            reusableView.indexPath = indexPath
            reusableView.kind = kind
            reusableView.sectionEventHandler = self
            return reusableView
        }
    }
}

extension CollectionAdaptor: UICollectionViewDelegate {
    //MARK: ViewDelegate
    @objc open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.willDisplayWith(container: collectionView, cell: cell, index: indexPath)
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section < dataSource.count, indexPath.row < dataSource[indexPath.section].cellCounts {
            let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
            cellHolder.didEndDisplayWith(container: collectionView, cell: cell, index: indexPath)
        }
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let sectionViewHolder = dataSource[indexPath.section]
        if elementKind == UICollectionElementKindSectionHeader {
            sectionViewHolder.willDisplayWith(container: collectionView, header: view, forSection: indexPath.section)
        }else if elementKind == UICollectionElementKindSectionFooter {
            sectionViewHolder.willDisplayWith(container: collectionView, footer: view, forSection: indexPath.section)
        }else {
            guard let context = self.context else {
                print("Warning: You're supposed to provide the context for handling other kinds of supplementary element event!")
                return
            }
            context.collectionView(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
        }
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if indexPath.section < dataSource.count {
            let sectionViewHolder = dataSource[indexPath.section]
            if elementKind == UICollectionElementKindSectionHeader {
                sectionViewHolder.didEndDisplayWith(container: collectionView, header: view, forSection: indexPath.section)
            }else if elementKind == UICollectionElementKindSectionFooter {
                sectionViewHolder.didEndDisplayWith(container: collectionView, footer: view, forSection: indexPath.section)
            }else {
                guard let context = self.context else {
                    print("Warning: You're supposed to provide the context for handling other kinds of supplementary element event!")
                    return
                }
                context.collectionView(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
            }
        }
    }
    
    
    @objc open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        return cellHolder.shouldSelectWith(container: collectionView, cell: cell, index: indexPath) 
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        return cellHolder.shouldDeselectWith(container: collectionView, cell: cell, index: indexPath) 
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.didSelectWith(container: collectionView, cell:cell , index: indexPath)
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.didDeselectWith(container: collectionView, cell: cell, index: indexPath)
    }
}

extension CollectionAdaptor: ViewCustomEventhandling {
    typealias CellClass = UICollectionViewCell
    typealias SectionViewClass = UICollectionReusableView
    
    func handleEvent(withName name: ViewCustomEventName, cell: UICollectionViewCell) {
        if handle(cell: cell, event: name) { return }
        guard let collection = view, let indexPath = collection.indexPath(for: cell) else { return }
        let cellHolder = dataSource[indexPath.section].cellHolders[indexPath.row]
        cellHolder.handleEvent(withName: name, container: collection, cell: cell, index: indexPath)
    }
    
    func handleEvent(withName name: ViewCustomEventName, sectionView: UICollectionReusableView) {
        guard let collection = view, let indexPath = sectionView.indexPath, let kind = sectionView.kind else { return }
        if kind == UICollectionElementKindSectionHeader {
            if handle(sectionHeader: sectionView, event: name) { return }
            dataSource[indexPath.section].handleEvent(withName: name, container: collection, header: sectionView, forSection: indexPath.section)
        }else if kind == UICollectionElementKindSectionFooter {
            if handle(sectionFooter: sectionView, event: name) { return }
            dataSource[indexPath.section].handleEvent(withName: name, container: collection, footer: sectionView, forSection: indexPath.section)
        }else {
            guard let context = self.context else {
                print("Warning: You're supposed to provide the context for handling other kinds of supplementary element event!")
                return
            }
            context.collectionViewHandleEvent(withName: name, collection, viewForSupplementaryElementOfKind: kind, at: indexPath)
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
    @objc open func handle(cell: UICollectionViewCell, event: ViewCustomEventName) -> Bool {
        if event == CellRemovedEvent, let indexPath = self.view?.indexPath(for: cell) {
            self.dataSource[indexPath.section].cellHolders.remove(at: indexPath.row)
            self.view?.deleteItems(at: [indexPath])
            return true
        }
        return false
    }
    
    /// Handle event emitted by sectionHeader.
    /// - Parameters:
    ///   - sectionHeader: The sectionHeader which emits the specified event
    ///   - event: event name
    /// - Returns: The adaptor successfully handled the event or not
    /// - Note: If the event isn't handled by the adaptor, it will be forwarded to the section view holder
    /// for further processing. for subclassing, you should call super  if you want the default
    /// event handling behaviour.
    @objc open func handle(sectionHeader: UICollectionReusableView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let indexPath = sectionHeader.indexPath {
            self.dataSource[indexPath.section].collapsed = false
            self.view?.reloadSections([indexPath.section])
            return true
        }else if event == SectionCollapseEvent, let indexPath = sectionHeader.indexPath {
            self.dataSource[indexPath.section].collapsed = true
            self.view?.reloadSections([indexPath.section])
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
    @objc open func handle(sectionFooter: UICollectionReusableView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let indexPath = sectionFooter.indexPath {
            self.dataSource[indexPath.section].collapsed = false
            self.view?.reloadSections([indexPath.section])
            return true
        }else if event == SectionCollapseEvent, let indexPath = sectionFooter.indexPath {
            self.dataSource[indexPath.section].collapsed = true
            self.view?.reloadSections([indexPath.section])
            return true
        }else {
            return false
        }
    }
}



extension  CollectionAdaptor {
    
    /// Append user datas to the section with specified index.
    /// - Parameters:
    ///   - sectionIndex: The index of which section the datas will be apppended to.
    ///   - datas: The user data will be dispalyed.
    ///   - cellClass: The cell class that is used to display user datas.
    /// - Returns: The result of appending operation. If the section index is out of bounds, append operation will fail and return false.
    @discardableResult
    public func append(toSection sectionIndex: Int, withDatas datas:[Any], cellClass: UICollectionViewCell.Type, cellHolderClass: CollectionCellViewHolder.Type? = nil) -> Bool {
        if sectionIndex < dataSource.count {
            let section = dataSource[sectionIndex]
            for data in datas {
                let cellHolder: CollectionCellViewHolder
                if let _cellHolderClass = cellHolderClass {
                    cellHolder = _cellHolderClass.init()
                    cellHolder.cellData = data
                    cellHolder.cellClass = cellClass
                }else{
                    cellHolder = CollectionCellViewHolder(data: data, cellClass: cellClass)
                }
                
                section.cellHolders.append(cellHolder)
            }
            return true
        }
        return false
    }
    
    /// Remove all cell holders in the section with specified index.
    /// - Parameter sectionIndex: The index of which section the datas will be removed.
    /// - Returns: The result of removing operation. If the section index is out of bounds, removing operation will fail and return false.
    @discardableResult
    public func clear(section sectionIndex: Int) -> Bool {
        if sectionIndex < dataSource.count {
            let section = dataSource[sectionIndex]
            section.cellHolders.removeAll()
            return true
        }
        return false
    }
    
    /// Reset the cell holders in the section with specified index and user datas.
    /// - Parameters:
    ///   - sectionIndex: The index of which section the datas will be reset to new datas.
    ///   - datas: The user data will be dispalyed.
    ///   - cellClass: The cell class that is used to display user datas.
    /// - Returns: The result of reseting operation. If the section index is out of bounds, reseting operation will fail and return false.
    @discardableResult
    public func set(section sectionIndex: Int, withDatas datas:[Any], cellClass: UICollectionViewCell.Type, cellHolderClass: CollectionCellViewHolder.Type? = nil) -> Bool {
        if clear(section: sectionIndex) {
            return append(toSection: sectionIndex, withDatas: datas, cellClass: cellClass, cellHolderClass: cellHolderClass)
        }
        return false
    }
    
    /// Append user datas to the last section of data source.
    /// - Parameters:
    ///   - section: The section which user datas will be append to. This is only used when There are no sections in data source. And if this is nil, a section holder will be automatically built to satisfy subsequent operations
    ///   - datas: The user data will be dispalyed.
    ///   - cellClass: The cell class that is used to display user datas.
    public func appendToLast(section:CollectionSectionViewHolder? = nil, datas:[Any], cellClass: UICollectionViewCell.Type, cellHolderClass: CollectionCellViewHolder.Type? = nil) {
        if let _section = section {
            dataSource.append(_section)
        }else{
            if dataSource.count == 0 {
                dataSource.append(CollectionSectionViewHolder())
            }
        }
        append(toSection: dataSource.count - 1, withDatas: datas, cellClass: cellClass, cellHolderClass: cellHolderClass)
    }
}



extension CollectionAdaptor {
    
    public subscript(_ index: Int) -> CollectionSectionViewHolder {
        get {
            self.dataSource[index]
        }
        set {
            self.dataSource[index] = newValue
        }
    }
    
    public subscript(_ indexPath: IndexPath) -> CollectionCellViewHolder {
        get {
            self.dataSource[indexPath.section][indexPath.item]
        }
        set {
            self.dataSource[indexPath.section][indexPath.item] = newValue
        }
    }
    
    public subscript(_ indexPath: IndexPath) -> Any? {
        get {
            self.dataSource[indexPath.section][indexPath.item].cellData
        }
        set {
            self.dataSource[indexPath.section][indexPath.item].cellData = newValue
        }
    }
    
    public subscript(section: Int, item: Int) -> CollectionCellViewHolder {
        get {
            self[IndexPath(item: item, section: section)]
        }
        set {
            self[IndexPath(item: item, section: section)] = newValue
        }
    }
    
    public subscript(section: Int, item: Int) -> Any? {
        get {
            self[IndexPath(item: item, section: section)].cellData
        }
        set {
            self[IndexPath(item: item, section: section)].cellData = newValue
        }
    }
    
    /// Find section view holder with specified user header data.
    /// - Parameters:
    ///   - headerData: The specified user header data.
    ///   - comparisonHandler: The customized comparision closure to define how to compare  the specified user header data with data source section view holder's header data.
    /// - Returns: The section view holder and its index in the data source. nil, if not found.
    public func getSectionHolder(withHeaderData headerData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (Int, CollectionSectionViewHolder)? {
        for (index, section) in dataSource.enumerated() {
            if comparisonHandler(headerData,section.headerData) {
                return (index, section)
            }
        }
        return nil
    }
    
    //convenient way to find section view holder by header data, when header data type confirms to Equatable.
    public func getSectionHolder<T: Equatable> (withHeaderData headerData: T) -> (Int, CollectionSectionViewHolder)? {
        for (index, section) in dataSource.enumerated() {
            if let h = section.headerData as? T, h == headerData {
                return (index, section)
            }
        }
        return nil
    }
    
    
    /// Find section view holder with specified user footer data.
    /// - Parameters:
    ///   - footerData: The specified user footer data.
    ///   - comparisonHandler: The customized comparision closure to define how to compare  the specified user footer data with data source section view holder's footer data.
    /// - Returns: The section view holder and its index in the data source. nil, if not found.
    public func getSectionHolder(withFooterData footerData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (Int, CollectionSectionViewHolder)? {
        for (index, section) in dataSource.enumerated() {
            if comparisonHandler(footerData,section.footerData) {
                return (index, section)
            }
        }
        return nil
    }
    
    //convenient way to find section view holder by footer data, when footerData type confirms to Equatable.
    public func getSectionHolder<T: Equatable> (withFooterData footerData: T) -> (Int, CollectionSectionViewHolder)? {
        for (index, section) in dataSource.enumerated() {
            if let f = section.footerData as? T, f == footerData {
                return (index, section)
            }
        }
        return nil
    }
    
    
    /// Find cell holder with specified user cell data
    /// - Parameters:
    ///   - cellData: The specified user cell data.
    ///   - comparisonHandler: The customized comparision closure to define how to compare  the specified user cell data with data source cell holder's user data.
    /// - Returns: The cell holder and its indexPath in the data source. nil, if not found.
    public func getCellHolder(withCellData cellData: Any, comparisonHandler: (_ origin: Any,_ comparison: Any?) -> Bool) -> (IndexPath, CollectionCellViewHolder)? {
        for (sIndex, section) in dataSource.enumerated() {
            for (cIndex, cell) in section.cellHolders.enumerated() {
                if comparisonHandler(cellData, cell.cellData) {
                    return (IndexPath(item: cIndex, section: sIndex), cell)
                }
            }
        }
        return nil
    }
    
    //convenient way to find cell holder by cell data, when cell data type confirms to Equatable.
    public func getCellHolder<T: Equatable>(withCellData cellData: T) -> (IndexPath, CollectionCellViewHolder)? {
        for (sIndex, section) in dataSource.enumerated() {
            for (cIndex, cell) in section.cellHolders.enumerated() {
                if let c = cell.cellData as? T, c == cellData {
                    return (IndexPath(row: cIndex, section: sIndex), cell)
                }
            }
        }
        return nil
    }
}

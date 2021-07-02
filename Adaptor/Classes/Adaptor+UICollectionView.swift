//
//  UICollectionView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"
private var delegateKey = "DelegateKey"

extension CollectionAdaptor: UICollectionViewDataSource{
    //MARK: DataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        guard let cellClass = cellHolder?.cellClass else { return UICollectionViewCell() }
        let cell = cellClass.dequeue(from: collectionView, withIdentifier: NSStringFromClass(cellClass), indexPath: indexPath)
        cell.cellEventHandler = self
        cell.update(data: cellHolder?.cellData)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionViewHolder = dataSource?[indexPath.section] else { return UICollectionReusableView(frame: CGRect.zero) }
        if kind == UICollectionElementKindSectionHeader {
           guard let headerClass = sectionViewHolder.headerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(headerClass), for: indexPath)
            headerView.indexPath = indexPath
            headerView.kind = kind
            headerView.sectionEventHandler = self
            headerView.update(data: sectionViewHolder.headerData, collasped: sectionViewHolder.collapsed, count: sectionViewHolder.cellHolders.count)
            return headerView
        }else if kind == UICollectionElementKindSectionFooter {
            guard let footerClass = sectionViewHolder.footerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(footerClass), for: indexPath)
            footerView.indexPath = indexPath
            footerView.kind = kind
            footerView.sectionEventHandler = self
            footerView.update(data: sectionViewHolder.footerData, collasped: sectionViewHolder.collapsed, count: sectionViewHolder.cellHolders.count)
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
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.willDisplayWith(container: collectionView, cell: cell, index: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didEndDisplayWith(container: collectionView, cell: cell, index: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard let sectionViewHolder = dataSource?[indexPath.section] else { return }
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
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let sectionViewHolder = dataSource?[indexPath.section] else { return }
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
    
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        return cellHolder?.shouldSelectWith(container: collectionView, cell: cell, index: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        return cellHolder?.shouldDeselectWith(container: collectionView, cell: cell, index: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didSelectWith(container: collectionView, cell:cell , index: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.didDeselectWith(container: collectionView, cell: cell, index: indexPath)
    }
}

extension CollectionAdaptor: ViewCustomEventhandling {
    typealias CellClass = UICollectionViewCell
    typealias SectionViewClass = UICollectionReusableView
    
    func handleEvent(withName name: ViewCustomEventName, cell: UICollectionViewCell) {
        if handle(cell: cell, event: name) { return }
        guard let collection = view, let indexPath = collection.indexPath(for: cell) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHolders[indexPath.row]
        cellHolder?.handleEvent(withName: name, container: collection, cell: cell, index: indexPath)
    }
    
    func handleEvent(withName name: ViewCustomEventName, sectionView: UICollectionReusableView) {
        guard let collection = view, let indexPath = sectionView.indexPath, let kind = sectionView.kind else { return }
        if kind == UICollectionElementKindSectionHeader {
            if handle(sectionHeader: sectionView, event: name) { return }
            dataSource?[indexPath.section].handleEvent(withName: name, container: collection, header: sectionView, forSection: indexPath.section)
        }else if kind == UICollectionElementKindSectionFooter {
            if handle(sectionFooter: sectionView, event: name) { return }
            dataSource?[indexPath.section].handleEvent(withName: name, container: collection, footer: sectionView, forSection: indexPath.section)
        }else {
            guard let context = self.context else {
                print("Warning: You're supposed to provide the context for handling other kinds of supplementary element event!")
                return
            }
            context.collectionViewHandleEvent(withName: name, collection, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
    
    @objc public func handle(cell: UICollectionViewCell, event: ViewCustomEventName) -> Bool {
        if event == CellRemovedEvent, let indexPath = self.view?.indexPath(for: cell) {
            self.dataSource?[indexPath.section].cellHolders.remove(at: indexPath.row)
            self.view?.deleteItems(at: [indexPath])
            return true
        }
        return false
    }
    
    @objc public func handle(sectionHeader: UICollectionReusableView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let indexPath = sectionHeader.indexPath {
            self.dataSource?[indexPath.section].collapsed = false
            self.view?.reloadSections([indexPath.section])
            return true
        }else if event == SectionCollapseEvent, let indexPath = sectionHeader.indexPath {
            self.dataSource?[indexPath.section].collapsed = true
            self.view?.reloadSections([indexPath.section])
            return true
        }else {
            return false
        }
    }
    
    @objc public func handle(sectionFooter: UICollectionReusableView, event: ViewCustomEventName) -> Bool {
        if event  == SectionExpandEvent, let indexPath = sectionFooter.indexPath {
            self.dataSource?[indexPath.section].collapsed = false
            self.view?.reloadSections([indexPath.section])
            return true
        }else if event == SectionCollapseEvent, let indexPath = sectionFooter.indexPath {
            self.dataSource?[indexPath.section].collapsed = true
            self.view?.reloadSections([indexPath.section])
            return true
        }else {
            return false
        }
    }
}

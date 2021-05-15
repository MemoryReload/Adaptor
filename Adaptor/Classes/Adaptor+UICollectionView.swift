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
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        guard let cellClass = cellHolder?.cellClass else { return UICollectionViewCell() }
        let cell = cellClass.dequeue(from: collectionView, withIdentifier: NSStringFromClass(cellClass), indexPath: indexPath)
        cell.update(data: cellHolder?.cellData)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionViewHolder = dataSource?[indexPath.section] else { return UICollectionReusableView(frame: CGRect.zero) }
        if kind == UICollectionElementKindSectionHeader {
           guard let headerClass = sectionViewHolder.headerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(headerClass), for: indexPath)
            headerView.update(data: sectionViewHolder.headerData)
            return headerView
        }else if kind == UICollectionElementKindSectionFooter {
            guard let footerClass = sectionViewHolder.footerViewClass else { return UICollectionReusableView(frame: CGRect.zero) }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(footerClass), for: indexPath)
            footerView.update(data: sectionViewHolder.footerData)
            return footerView
        }else {
            guard let context = self.context else {
                print("Warning: You're supposed to provide the context for fetching other kinds of supplementary element!")
                return UICollectionReusableView(frame: CGRect.zero)
            }
            return context.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
        }
    }
}

extension CollectionAdaptor: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.willDisplayWith(container: collectionView, cell: cell, index: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
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
                print("Warning: You're supposed to provide the context for fetching other kinds of supplementary element!")
            }
            
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
                print("Warning: You're supposed to provide the context for fetching other kinds of supplementary element!")
            }
            
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        return cellHolder?.shouldSelectWith(container: collectionView, cell: cell, index: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return false}
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        return cellHolder?.shouldDeselectWith(container: collectionView, cell: cell, index: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.didSelectWith(container: collectionView, cell:cell , index: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        cellHolder?.didDeselectWith(container: collectionView, cell: cell, index: indexPath)
    }
}

//
//  UICollectionView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"
private var delegateKey = "DelegateKey"

extension Adaptor where T: UICollectionView {
    //MARK: DataHandling
    public var dataSource:[CollectionSectionViewHolder]? {
        get {
            return objc_getAssociatedObject(self, &dataSourceKey) as? [CollectionSectionViewHolder]
        }
        set {
            objc_setAssociatedObject(self, &dataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        guard let cellClass = cellHolder?.cellClass else { return UICollectionViewCell() }
        let cell = cellClass.dequeue(from: collectionView, withIdentifier: NSStringFromClass(cellClass), indexPath: indexPath)
        cell.update(data: cellHolder?.cellData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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

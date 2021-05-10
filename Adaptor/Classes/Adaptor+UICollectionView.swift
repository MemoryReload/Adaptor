//
//  UICollectionView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"

extension Adaptor where T: UICollectionView {
    //MARK: DataHandling
    public var dataSource:[CollectionSectionViewHolder<CollectionCellViewHolder<UICollectionViewCell>, UICollectionReusableView>]? {
        get {
            return objc_getAssociatedObject(self, &dataSourceKey) as! [CollectionSectionViewHolder]?
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
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: NSStringFromClass(sectionViewHolder.headerViewClass), for: indexPath)
            headerView.update(data: sectionViewHolder.headerData)
            return headerView
        }else if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(sectionViewHolder.footerViewClass), for: indexPath)
            footerView.update(data: sectionViewHolder.footerData)
            return footerView
        }else {
            assert(false, "Custom supplementary view is not supported for now")
            return UICollectionReusableView(frame: CGRect.zero)
        }
    }
}

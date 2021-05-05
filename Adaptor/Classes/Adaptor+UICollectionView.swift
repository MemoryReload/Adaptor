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
}

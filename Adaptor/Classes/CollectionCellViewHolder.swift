//
//  CellViewHolder+UICollectionView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

open class CollectionCellViewHolder: CellViewHolderBaseProtocol {
    public typealias CellClass = UICollectionViewCell
    
    public var cellData: Any?
    public var cellClass: UICollectionViewCell.Type?
    
    public init() { }
    
    convenience init(data: Any?, cellClass: UICollectionViewCell.Type?) {
        self.init()
        cellData = data
        self.cellClass = cellClass
    }
}

extension CollectionCellViewHolder: CollectionCellViewHolderEventProtocol {
    
    public typealias ContainerClass = UICollectionView
    
    @objc open func didUpdateWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) {
        cell.update(data: cellData)
    }
    
    @objc open func willDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    @objc open func didEndDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    @objc open func shouldSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) -> Bool { true}
    @objc open func shouldDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) -> Bool { true }
    
    @objc open func didSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    @objc open func didDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
}



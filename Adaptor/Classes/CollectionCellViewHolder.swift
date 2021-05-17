//
//  CellViewHolder+UICollectionView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

public class CollectionCellViewHolder: CellViewHolderBaseProtocol {
    public typealias CellClass = UICollectionViewCell
    
    public var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: UICollectionViewCell.Type?
}

extension CollectionCellViewHolder: CollectionCellViewHolderEventProtocol {
    
    public typealias ContainerClass = UICollectionView
    
    @objc public func willDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    @objc public func didEndDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    @objc public func shouldSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) -> Bool { true}
    @objc public func shouldDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) -> Bool { true }
    
    @objc public func didSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    @objc public func didDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    @objc public func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
}



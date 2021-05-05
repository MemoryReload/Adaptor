//
//  CellViewHolder+UICollectionView.swift
//  Adaptor
//
//  Created by HePing on 2021/5/1.
//

import Foundation

public struct CollectionCellViewHolder<T: UICollectionViewCell>: CellViewHolderBaseProtocol {
    public typealias CellClass = T
    
    var cellHeight: CGFloat?
    public var cellData: Any?
    public var cellClass: CellClass.Type
}

extension CollectionCellViewHolder: CellViewHolderEventProtocol {
    public typealias ContainerClass = UICollectionView
    
    public func willDisplayWith(container: UICollectionView, cell: T, index: IndexPath) { }
    public func didEndDisplayWith(container: UICollectionView, cell: T, index: IndexPath) { }
    
    public func willSelectWith(container: UICollectionView, cell: T, index: IndexPath) { }
    public func didSelectWith(container: UICollectionView, cell: T, index: IndexPath) { }
    
    public func willDeselectWith(container: UICollectionView, cell: T, index: IndexPath) { }
    public func didDeselectWith(container: UICollectionView, cell: T, index: IndexPath) { }
}



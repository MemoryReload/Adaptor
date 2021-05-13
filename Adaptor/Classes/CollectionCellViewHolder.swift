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

extension CollectionCellViewHolder: CellViewHolderEventProtocol {
    public typealias ContainerClass = UICollectionView
    
    public func willDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    public func didEndDisplayWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    public func willSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    public func didSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    
    public func willDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
    public func didDeselectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) { }
}



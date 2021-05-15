//
//  CollectionSectionViewHodler.swift
//  Adaptor
//
//  Created by HePing on 2021/5/3.
//

import Foundation

public class CollectionSectionViewHolder: SectionViewHolderBaseProtocol  {
    
    public var headerData: Any?
    public var headerViewClass: UICollectionReusableView.Type?
    
    
    public var footerData: Any?
    public var footerViewClass: UICollectionReusableView.Type?
    
    public var cellHodlers: [CollectionCellViewHolder]?
    public var collapsed: Bool = false
    public var cellCounts: Int {
        get{
            if collapsed {
                return 0
            }
            return cellHodlers?.count ?? 0
        }
    }
    public init() { }
}


extension CollectionSectionViewHolder: CollectionSectionViewHolderEventProtocol {
    @objc public func willDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    @objc public func didEndDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    
    @objc public func willDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) {}
    @objc public func didEndDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) { }
}

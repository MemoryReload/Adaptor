//
//  CollectionSectionViewHolder.swift
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
    
    public var cellHolders: [CollectionCellViewHolder] = []
    public var collapsed: Bool = false
    public var cellCounts: Int {
        if collapsed {
            return 0
        }
        return cellHolders.count
    }
    public init() { }
}


extension CollectionSectionViewHolder: CollectionSectionViewHolderEventProtocol {
    public func didUpdateWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) {
        header.update(data: headerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc public func willDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    @objc public func didEndDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    
    public func didUpdateWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) {
        footer.update(data: footerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc public func willDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) {}
    @objc public func didEndDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) { }
    
    @objc public func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    @objc public func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) { }
}

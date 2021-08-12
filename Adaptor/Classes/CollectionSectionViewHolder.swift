//
//  CollectionSectionViewHolder.swift
//  Adaptor
//
//  Created by HePing on 2021/5/3.
//

import Foundation

open class CollectionSectionViewHolder: SectionViewHolderBaseProtocol  {
    
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
    
    convenience init(holders:[CollectionCellViewHolder], headerData: Any? = nil, headerClass: UICollectionReusableView.Type? = nil, footerData: Any? = nil, footerClass:UICollectionReusableView.Type? = nil) {
        self.init()
        cellHolders = holders
        self.headerData = headerData
        self.headerViewClass = headerClass
        self.footerData = footerData
        self.footerViewClass = footerClass
    }
}


extension CollectionSectionViewHolder: CollectionSectionViewHolderEventProtocol {
    @objc open func didUpdateWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) {
        header.update(data: headerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc open func willDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    @objc open func didEndDisplayWith(container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    
    @objc open func didUpdateWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) {
        footer.update(data: footerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc open func willDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) {}
    @objc open func didEndDisplayWith(container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) { }
    
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, header: UICollectionReusableView, forSection section: Int) { }
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UICollectionView, footer: UICollectionReusableView, forSection section: Int) { }
}

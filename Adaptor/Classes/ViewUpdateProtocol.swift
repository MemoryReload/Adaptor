//
//  AdaptorViewUpdateProtocol.swift
//  Adaptor
//
//  Created by HePing on 2021/4/30.
//

import Foundation

public protocol CellUpdateProtocol {
    func update(data:Any?)
}

public protocol SectionViewUpdateProtocol {
    func update(data:Any?, collasped:Bool, count: Int)
}

protocol TableCellViewReuseProtocol {
    associatedtype V
    static func dequeue(from container:UITableView, withIdentifier: String ) -> V?
}

protocol CollectionReusableViewReuseProtocol
{
    static func dequeue(from container:UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
}

protocol CollectionCellViewReuseProtocol
{
    static func dequeue(from container:UICollectionView, withIdentifier: String, indexPath: IndexPath ) -> UICollectionViewCell
}

extension UITableViewCell: TableCellViewReuseProtocol, CellUpdateProtocol
{
    public typealias V =  UITableViewCell
    
    static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewCell? {
        return container.dequeueReusableCell(withIdentifier: withIdentifier)
    }
    
    @objc open func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UITableViewHeaderFooterView: TableCellViewReuseProtocol, SectionViewUpdateProtocol
{
    public typealias V = UITableViewHeaderFooterView
    
    static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewHeaderFooterView? {
        container.dequeueReusableHeaderFooterView(withIdentifier: withIdentifier)
    }
    
    @objc open func update(data: Any?, collasped: Bool, count: Int) {
        assert(false, "subclass override stub!")
    }
}


extension UICollectionReusableView: CollectionReusableViewReuseProtocol, SectionViewUpdateProtocol {
    public typealias V = UICollectionReusableView
    
    static func dequeue(from container: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        container.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    @objc open func update(data: Any?, collasped: Bool, count: Int) {
        assert(false, "subclass override stub!")
    }
}

extension UICollectionViewCell: CollectionCellViewReuseProtocol, CellUpdateProtocol
{
    static func dequeue(from container: UICollectionView, withIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        container.dequeueReusableCell(withReuseIdentifier: withIdentifier, for: indexPath)
    }
    
    @objc open func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

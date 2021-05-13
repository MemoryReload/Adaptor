//
//  AdaptorViewUpdateProtocol.swift
//  Adaptor
//
//  Created by HePing on 2021/4/30.
//

import Foundation

public protocol ViewUpdateProtocol {
    func update(data:Any?)
}

protocol TableCellViewUpdateProtocol: ViewUpdateProtocol {
    associatedtype V
    static func dequeue(from container:UITableView, withIdentifier: String ) -> V?
}

protocol CollectionReusableViewUpdateProtocol: ViewUpdateProtocol
{
    static func dequeue(from container:UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
}

public protocol CollectionCellViewUpdateProtocol: ViewUpdateProtocol
{
    static func dequeue(from container:UICollectionView, withIdentifier: String, indexPath: IndexPath ) -> UICollectionViewCell
}

extension UITableViewCell: TableCellViewUpdateProtocol
{
    public typealias V =  UITableViewCell
    
    public static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewCell? {
        return container.dequeueReusableCell(withIdentifier: withIdentifier)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UITableViewHeaderFooterView: TableCellViewUpdateProtocol
{
    public typealias V = UITableViewHeaderFooterView
    
    static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewHeaderFooterView? {
        container.dequeueReusableHeaderFooterView(withIdentifier: withIdentifier)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}


extension UICollectionReusableView: CollectionReusableViewUpdateProtocol {
    public typealias V = UICollectionReusableView
    
    static func dequeue(from container: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        container.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UICollectionViewCell: CollectionCellViewUpdateProtocol
{
    public static func dequeue(from container: UICollectionView, withIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        container.dequeueReusableCell(withReuseIdentifier: withIdentifier, for: indexPath)
    }
}

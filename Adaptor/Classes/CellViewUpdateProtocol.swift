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

public protocol TableCellViewUpdateProtocol: ViewUpdateProtocol {
    associatedtype containerClass
    associatedtype cellClass
    
    static func dequeue(from container:containerClass, withIdentifier: String ) -> cellClass?
}

public protocol CollectionReusableViewUpdateProtocol: ViewUpdateProtocol
{
    associatedtype containerClass
    associatedtype cellClass
    
    static func dequeue(from container:containerClass, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> cellClass
}

public protocol CollectionCellViewUpdateProtocol: ViewUpdateProtocol
{
    associatedtype containerClass
    associatedtype cellClass
    
    static func dequeue(from container:containerClass, withIdentifier: String, indexPath: IndexPath ) -> cellClass
}

extension UITableViewCell: TableCellViewUpdateProtocol
{
    public typealias containerClass = UITableView
    public typealias cellClass =  UITableViewCell
    
    public static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewCell? {
        return container.dequeueReusableCell(withIdentifier: withIdentifier)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UITableViewHeaderFooterView: TableCellViewUpdateProtocol
{
    public typealias containerClass = UITableView
    public typealias cellClass = UITableViewHeaderFooterView
    
    public static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewHeaderFooterView? {
        container.dequeueReusableHeaderFooterView(withIdentifier: withIdentifier)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}


extension UICollectionReusableView: CollectionReusableViewUpdateProtocol {
    public typealias containerClass = UICollectionView
    public typealias cellClass = UICollectionReusableView
    
    public static func dequeue(from container: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        container.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UICollectionViewCell: CollectionCellViewUpdateProtocol
{
    public typealias containerClass = UICollectionView
    public typealias cellClass = UICollectionViewCell
    
    public static func dequeue(from container: UICollectionView, withIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        container.dequeueReusableCell(withReuseIdentifier: withIdentifier, for: indexPath)
    }
}

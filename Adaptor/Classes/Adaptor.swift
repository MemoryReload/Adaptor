//
//  TableAdaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation
import UIKit



/// The base protocol to define the most important elements to construct an adaptor.
public protocol AdaptingProtocol {
    associatedtype V
    associatedtype D
    associatedtype C
    
    /// The view  which adaptor is working for.
    var view: V? { get }
    /// The extra context that adaptor needed to work properly with controllers and so on.
    var context: C { get set }
    /// The display view model that adaptor needed to work with view.
    var dataSource:[D] { get set }
}

/// The adaptor protocol that works with UITableView
public protocol TableAdaptingProtocol: AdaptingProtocol, UITableViewDataSource, UITableViewDelegate { }

/// The adaptor protocol that works with UICollectionView
public protocol CollectionAdaptingProtocol: AdaptingProtocol, UICollectionViewDataSource, UICollectionViewDelegate { }

/// The base adaptor that  works with UITableView
open class TableAdaptor: NSObject, TableAdaptingProtocol {
    weak public fileprivate(set) var view: UITableView?
    weak public var context: AdaptorContextProtocol?
    public var dataSource:[TableSectionViewHolder] = []
}

/// The base adaptor that works with UICollectionView
open class CollectionAdaptor:NSObject, CollectionAdaptingProtocol {
    weak public fileprivate(set) var view: UICollectionView?
    weak public var context: AdaptorContextReusableProtocol?
    public var dataSource:[CollectionSectionViewHolder] = []
}


//MARK: AdaptorCompatible

public struct AdaptorWrapper<Base>{
    public var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol AdaptorCompatible {
    associatedtype V
    var ac: AdaptorWrapper<V> { get }
}

extension AdaptorCompatible {
    public var ac: AdaptorWrapper<Self> {
       return AdaptorWrapper(self)
    }
}

extension UITableView: AdaptorCompatible { }
extension UICollectionView: AdaptorCompatible { }

private var adaptorKey: Void?

extension AdaptorWrapper where Base: UITableView {
    public var adaptor: TableAdaptor? {
            return objc_getAssociatedObject(base, &adaptorKey) as? TableAdaptor
    }

    public func useAdaptor(_ adaptor: TableAdaptor? = TableAdaptor()) {
        objc_setAssociatedObject(base, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
        adaptor?.view = base
        base.delegate = adaptor
        base.dataSource = adaptor
    }
}


extension AdaptorWrapper where Base: UICollectionView {
    public var adaptor: CollectionAdaptor? {
            return objc_getAssociatedObject(base, &adaptorKey) as? CollectionAdaptor
    }

   public func useAdaptor(_ adaptor: CollectionAdaptor? = CollectionAdaptor()) {
        objc_setAssociatedObject(base, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
        adaptor?.view = base
        base.delegate = adaptor
        base.dataSource = adaptor
    }
}

//MARK: View Register

extension UITableView {
    
    /// regist table cell
    /// - Parameter cellClass: the specified table cell class to regist
    public func registerCell(cellClass: UITableViewCell.Type){
        self.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    
    /// regist table section view
    /// - Parameter viewClass: the specified table section class to regist
    public func registerSectionView(viewClass: UITableViewHeaderFooterView.Type){
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(viewClass))
    }
}

extension UICollectionView {
    
    /// regist collection cell
    /// - Parameter cellClass: the specified collection cell class to regist
    public func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    
    /// regist collection supplement view
    /// - Parameters:
    ///   - viewClass: the specified collection supplement view class to regist
    ///   - kind: the specified collection supplement view kind
    public func registerReusableView(viewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind kind: String) {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: NSStringFromClass(viewClass))
    }
}

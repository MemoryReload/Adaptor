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


//MARK: AdaptorProtocol

/// The protocol used to inject adaptor to the specified view
public protocol AdaptorProtocol: AnyObject {
    associatedtype T
    /// The adaptor for the specified view to work with
    var adaptor: T? { get }
    
    /// Connet the adaptor with the specified view
    /// - Parameter adaptor: the adaptor to use
    func useAdaptor(_ adaptor: T?)
}

private var adaptorKey = "Adaptor"

extension UITableView: AdaptorProtocol {
    public private(set) var adaptor: TableAdaptor? {
        get {
            return objc_getAssociatedObject(self, &adaptorKey) as? TableAdaptor
        }
        set {
            objc_setAssociatedObject(self, &adaptorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func useAdaptor(_ adaptor: TableAdaptor? = TableAdaptor()) {
        self.adaptor = adaptor
        self.adaptor?.view = self
        self.delegate = adaptor
        self.dataSource = adaptor
    }
}

extension UICollectionView: AdaptorProtocol {
    public private(set) var adaptor: CollectionAdaptor? {
        get {
            return objc_getAssociatedObject(self, &adaptorKey) as? CollectionAdaptor
        }
        set {
            objc_setAssociatedObject(self, &adaptorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func useAdaptor(_ adaptor: CollectionAdaptor? = CollectionAdaptor()) {
        self.adaptor = adaptor
        self.adaptor?.view = self
        self.delegate = adaptor
        self.dataSource = adaptor
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

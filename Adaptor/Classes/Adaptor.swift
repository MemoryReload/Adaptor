//
//  TableAdaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation
import UIKit

public protocol AdaptingProtocol {
    associatedtype V
    associatedtype D
    associatedtype C
    
    var view: V? { get }
    var context: C { get set }
    var dataSource:[D]? { get set }
}

public protocol TableAdaptingProtocol: AdaptingProtocol, UITableViewDataSource, UITableViewDelegate { }

public protocol CollectionAdaptingProtocol: AdaptingProtocol, UICollectionViewDataSource, UICollectionViewDelegate { }

public class TableAdaptor: NSObject, TableAdaptingProtocol {
    weak public fileprivate(set) var view: UITableView?
    public var context: AdaptorContextProtocol?
    public var dataSource:[TableSectionViewHolder]?
}

public class CollectionAdaptor:NSObject, AdaptingProtocol {
    weak public fileprivate(set) var view: UICollectionView?
    public var context: AdaptorContextReusableProtocol?
    public var dataSource:[CollectionSectionViewHolder]?
}


//MARK: AdaptorProtocol

public protocol AdaptorProtocol: AnyObject {
    associatedtype T
    var adaptor: T? { get }
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
    public func registerCell(cellClass: UITableViewCell.Type){
        self.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func registerSectionView(viewClass: UITableViewHeaderFooterView.Type){
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(viewClass))
    }
}

extension UICollectionView {
    public func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func regiserReusableView(viewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind kind: String) {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: NSStringFromClass(viewClass))
    }
}

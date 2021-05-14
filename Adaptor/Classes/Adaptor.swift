//
//  TableAdaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation
import UIKit

public protocol AdaptingProtocol {
    var context: AdaptorContextReusableProtocol? { get set }
    init(withView view: UIView)
}

public class TableAdaptor:NSObject, AdaptingProtocol {
    weak var view: UITableView?
    public var context: AdaptorContextReusableProtocol?
    required public init(withView view: UIView) {
        self.view = view as? UITableView
    }
}

public class CollectionAdaptor:NSObject, AdaptingProtocol {
    weak var view: UICollectionView?
    public var context: AdaptorContextReusableProtocol?
    required public init(withView view: UIView) {
        self.view = view as? UICollectionView
    }
}

public protocol AdaptorProtocol: AnyObject {
    func useAdaptor()
}

private var adaptorKey = "Adaptor"

extension UITableView: AdaptorProtocol {
    public var adaptor: TableAdaptor {
        get {
            if let adaptor = objc_getAssociatedObject(self, &adaptorKey) {
                return adaptor as! TableAdaptor
            }
            let adaptor = TableAdaptor(withView: self)
            objc_setAssociatedObject(self, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
            return adaptor
        }
    }
    
    public func useAdaptor() {
        self.delegate = adaptor
        self.dataSource = adaptor
    }
    
    public func registerCell(cellClass: UITableViewCell.Type){
        self.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func registerSectionView(viewClass: UITableViewHeaderFooterView.Type){
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(viewClass))
    }
}

extension UICollectionView: AdaptorProtocol {
    public var adaptor: CollectionAdaptor {
        get {
            if let adaptor = objc_getAssociatedObject(self, &adaptorKey) {
                return adaptor as! CollectionAdaptor
            }
            let adaptor = CollectionAdaptor(withView: self)
            objc_setAssociatedObject(self, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
            return adaptor
        }
    }
    
    public func useAdaptor() {
        self.delegate = adaptor
        self.dataSource = adaptor
    }
    
    public func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func regiserReusableView(viewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind kind: String) {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: NSStringFromClass(viewClass))
    }
}

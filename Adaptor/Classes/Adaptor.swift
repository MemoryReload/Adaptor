//
//  TableAdaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation
import UIKit

public final class Adaptor<T: AnyObject>: NSObject {
    weak var view: T?
    var context: AdaptorContextReusableProtocol?
    required init(withView view: T) {
        self.view = view
        super.init()
    }
}
 
public protocol AdaptorProtocol: AnyObject {
    associatedtype T: AnyObject
    var adaptor: Adaptor<T> { get }
    func useAdaptor()
}

private var adaptorKey = "Adaptor"

extension AdaptorProtocol
{
    public var adaptor: Adaptor<Self> {
        get {
            if let adaptor = objc_getAssociatedObject(self, &adaptorKey) {
                return adaptor as! Adaptor<Self>
            }
            let adaptor = Adaptor(withView: self)
            objc_setAssociatedObject(self, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
            return adaptor
        }
    }
}

extension UITableView: AdaptorProtocol {
    public func useAdaptor() {
        print("\(self) \(adaptor) \(self.adaptor)")
        self.delegate = adaptor as? UITableViewDelegate
        self.dataSource = adaptor as? UITableViewDataSource
    }
    
    public func registerCell(cellClass: UITableViewCell.Type){
        self.register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func registerSectionView(viewClass: UITableViewHeaderFooterView.Type){
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: NSStringFromClass(viewClass))
    }
}

extension UICollectionView: AdaptorProtocol {
    public func useAdaptor() {
        self.delegate = adaptor as? UICollectionViewDelegate
        self.dataSource = adaptor as? UICollectionViewDataSource
    }
    
    public func registerCell(cellClass: UICollectionViewCell.Type){
        self.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    public func regiserReusableView(viewClass: UICollectionReusableView.Type, forSupplementaryViewOfKind kind: String) {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: NSStringFromClass(viewClass))
    }
}

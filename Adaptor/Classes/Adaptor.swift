//
//  TableAdaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation
import UIKit

public class Adaptor<T: AnyObject>: NSObject {
    weak var view: T?
    required init(withView view: T) {
        self.view = view
        super.init()
    }
}
 
protocol AdaptorProtocol: AnyObject {
    associatedtype T
    var adaptor: T { get }
    func useAdaptor()
}

private var adaptorKey = "Adaptor"

extension AdaptorProtocol
{
    var adaptor: Adaptor<Self> {
        get {
            if let adaptor = objc_getAssociatedObject(self, &adaptorKey) {
                return adaptor as! Adaptor<Self>
            }
            let adaptor = Adaptor(withView: self)
            objc_setAssociatedObject(Self.self, &adaptorKey, adaptor, .OBJC_ASSOCIATION_RETAIN)
            return adaptor
        }
    }
}

extension UITableView: AdaptorProtocol {
    func useAdaptor() {
        self.delegate = adaptor as? UITableViewDelegate
        self.dataSource = adaptor as? UITableViewDataSource
    }
}

extension UICollectionView: AdaptorProtocol {
    func useAdaptor() {
        self.delegate = adaptor as? UICollectionViewDelegate
        self.dataSource = adaptor as? UICollectionViewDataSource
    }
}

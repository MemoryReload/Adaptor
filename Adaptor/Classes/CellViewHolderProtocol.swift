//
//  CellViewHolder.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

public protocol CellViewHolderBaseProtocol {
    associatedtype CellClass
    
    var cellData: Any? { get set }
    var cellClass: CellClass.Type { get set }
}

public protocol CellViewHolderEventProtocol {
    associatedtype CellClass
    associatedtype ContainerClass
    
    func willDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    func didEndDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    
    func willSelectWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    func didSelectWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    
    func willDeselectWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    func didDeselectWith(container: ContainerClass, cell: CellClass, index:IndexPath)
}


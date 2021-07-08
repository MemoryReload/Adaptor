//
//  CellViewHolder.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation


/// The base protocol for cell view holder
public protocol CellViewHolderBaseProtocol {
    associatedtype CellClass
    
    /// User data for the specified cell
    var cellData: Any? { get set }
    
    /// Cell class used for displaying the sepcified cell
    var cellClass: CellClass.Type? { get set }
}


/// The event handling protocol for cell view holder
public protocol CellViewHolderEventProtocol {
    associatedtype CellClass
    associatedtype ContainerClass
    
    /// Called when the specified cell needs to be updated with view holder's cellData
    /// - Parameters:
    ///   - container: The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    func didUpdateWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    
    
    /// Called when the specified cell will be displayed on the container
    /// - Parameters:
    ///   - container: The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    func willDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    
    /// Called when the specified cell ends displaying on the container
    /// - Parameters:
    ///   - container: The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    func didEndDisplayWith(container: ContainerClass, cell: CellClass, index:IndexPath)
    
    /// Called when the specified cell will be selected
    /// - Parameters:
    ///   - container:  The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    func shouldSelectWith(container: ContainerClass, cell: CellClass, index:IndexPath) -> Bool
    
    /// Called when the specified cell will be deselected
    /// - Parameters:
    ///   - container: The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    func shouldDeselectWith(container: ContainerClass, cell: CellClass, index:IndexPath) -> Bool
    
    /// Called when the specified cell emit event
    /// - Parameters:
    ///   - name: The name of the event
    ///   - container: The container of cell (UITableView, UICollection, ect)
    ///   - cell: The specified cell view
    ///   - index: The index path of specified cell view
    /// - Note: The event will be handled by adaptor at first. If container handle such event, this
    /// method will not be called. Or, this method should do further processing.
    func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, cell: CellClass, index:IndexPath)
}

public protocol TableCellViewHolderEventProtocol: CellViewHolderEventProtocol  {
    
}

public protocol CollectionCellViewHolderEventProtocol: CellViewHolderEventProtocol {
    
}

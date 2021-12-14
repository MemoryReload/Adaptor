//
//  SectionViewHolder.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/13.
//

import Foundation

public protocol SectionViewHolderBaseProtocol {
    associatedtype CellHolderClass
    associatedtype SectionViewClass
    
    
    /// The section header data
    var headerData: Any? { get set }
    
    /// The section header view class
    var headerViewClass: SectionViewClass.Type? { get set }
    
    
    /// The section footer data
    var footerData: Any? { get set }
    
    /// The section footer view class
    var footerViewClass: SectionViewClass.Type? { get set }
    
    /// The cell holders contained in this section
    var cellHolders: [CellHolderClass] { get set }
    
    /// If true, cells in this section will not be displayed. Default is false
    var collapsed: Bool { get set }
    
    /// The displayed cells counts. If not collapsed, should be equal to cellHolders.count. If not, return 0.
    var cellCounts: Int { get }
    
    /// the subscription support
    subscript(_ index: Int) -> CellHolderClass { get set }
}

public protocol SectionViewHolderEventProtocol {
    associatedtype SectionViewClass
    associatedtype ContainerClass
    
    /// Called when the specified header view needs to be updated with view holder's headerData
    /// - Parameters:
    ///   - container: The container of the specified header view  (UITableView, UICollection, ect)
    ///   - header: The specified header view
    ///   - section: The index path of specified header view
    func didUpdateWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
    
    /// Called when the specified header view will be displayed on the container
    /// - Parameters:
    ///   - container: The container of the specified header view (UITableView, UICollection, ect)
    ///   - header: The specified header view
    ///   - section: The index of specified header view
    func willDisplayWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
    
    /// Called when the specified header view ends displaying on the container
    /// - Parameters:
    ///   - container: The container of the specified header view (UITableView, UICollection, ect)
    ///   - header: The specified header view
    ///   - section: The index of specified header view
    func didEndDisplayWith(container: ContainerClass, header:SectionViewClass, forSection section: Int )
    
    
    /// Called when the specified footer view needs to be updated with view holder's footerData
    /// - Parameters:
    ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
    ///   - footer: The specified footer view
    ///   - section: The index of specified footer view
    func didUpdateWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int)
    
    /// Called when the specified footer view will be displayed on the container
    /// - Parameters:
    ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
    ///   - footer: The specified footer view
    ///   - section: The index of specified footer view
    func willDisplayWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int )
    
    /// Called when the specified footer view ends displaying on the container
    /// - Parameters:
    ///   - container: The container of the specified footer view (UITableView, UICollection, ect)
    ///   - footer: The specified footer view
    ///   - section: The index of specified footer view
    func didEndDisplayWith(container: ContainerClass, footer:SectionViewClass, forSection section: Int )
    
    /// Called when the specified header view emit event
    /// - Parameters:
    ///   - name: The name of the event
    ///   - container: The container of the specified header view  (UITableView, UICollection, ect)
    ///   - cell: The specified header view
    ///   - index: The index path of specified header view
    /// - Note: The event will be handled by adaptor at first. If container handle such event, this
    /// method will not be called. Or, this method should do further processing.
    func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, header:SectionViewClass, forSection section: Int)
    
    /// Called when the specified footer view emit event
    /// - Parameters:
    ///   - name: The name of the event
    ///   - container: The container of the specified footer view  (UITableView, UICollection, ect)
    ///   - cell: The specified footer view
    ///   - index: The index path of specified footer view
    /// - Note: The event will be handled by adaptor at first. If container handle such event, this
    /// method will not be called. Or, this method should do further processing.
    func handleEvent(withName name: ViewCustomEventName, container: ContainerClass, footer:SectionViewClass, forSection section: Int)
}

public protocol TableSectionViewHolderEventProtocol: SectionViewHolderEventProtocol  {
    
}

public protocol CollectionSectionViewHolderEventProtocol: SectionViewHolderEventProtocol {
    
}

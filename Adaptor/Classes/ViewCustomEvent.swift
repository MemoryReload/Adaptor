//
//  AdaptorCustomEvent.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/17.
//

import Foundation

public typealias ViewCustomEventName = String

/// The section expanding event name.
public let SectionExpandEvent: ViewCustomEventName = "SectionExpand"

/// The section collapseing event name.
public let SectionCollapseEvent: ViewCustomEventName = "SectionCollapse"

/// The cell removed event name.
public let CellRemovedEvent: ViewCustomEventName = "CellRemoved"

/// The base view custom event handling protocol. Any object that prefers to handle
/// view custom event should confirm (or maybe implement) this protocol.
protocol ViewCustomEventhandling {
    associatedtype CellClass
    associatedtype SectionViewClass
    
    /// Called when the specified cell emits event.
    /// - Parameters:
    ///   - name: The event name
    ///   - cell: The cell which emits such event.
    func handleEvent(withName name: ViewCustomEventName, cell: CellClass)
    
    /// Called when the specified section view emit event.
    /// - Parameters:
    ///   - name: The event name
    ///   - sectionView: The section view which emits such event
    func handleEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
}

/// The base cell custom event sending protocol. Any cell classes that prefer to send
/// custom event should confrim (or maybe implement) this protocol.
protocol CellEventSending {
    associatedtype A: ViewCustomEventhandling
    associatedtype CellClass
    
    /// The event handler which is honored to handle events emitted by custom cell views (generally speaking,
    /// this should be the adaptor).
    var  cellEventHandler: A? { get set }
    
    /// The event tiger method. A specified cell event will be sent to the handler after calling this method.
    /// - Parameters:
    ///   - name: The specified event name
    ///   - cell: The specified cell which sending the event
    func sendEvent(withName name: ViewCustomEventName, cell: CellClass)
}

/// The base section view custom event sending protocol. Any section view classes that prefer to send
/// custom event should confrim (or maybe implement) this protocol.
protocol SectionViewEventSending {
    associatedtype A: ViewCustomEventhandling
    associatedtype SectionViewClass
    
    /// The event handler which is honored to handle events emitted by custom section views (generally
    /// speaking, this should be the adaptor).
    var  sectionEventHandler: A? { get set }
    
    /// The event tiger method. A specified section event will be sent to the handler after calling this
    /// method.
    /// - Parameters:
    ///   - name: The specified event name
    ///   - sectionView: The specified section view which sending the event
    func sendEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
}

enum TableSectionViewType {
    /// header view of the table
    case Header
    /// footer view of the table
    case Footer
}


/// The table section view event sending protocol.
protocol TableSectionViewEventSending: SectionViewEventSending  {
    
    /// The type of the specified section view which sends custom event.
    var type: TableSectionViewType? { get set }
    
    /// the index of the specified section view in the table
    var index: Int? { get set }
}


/// The reusable view of collection view event sending protocol.
protocol CollectionReusableViewEventSending: SectionViewEventSending {
    
    /// The index path of the reusable view which sends custom event.
    var  indexPath: IndexPath? { get set }
    
    /// The supplementary view  kind of the reusable view.
    var  kind: String? { get set }
}

private var eventHandlerKey = "EventHandler"

extension UITableViewCell: CellEventSending {
    typealias A = TableAdaptor
    typealias CellClass = UITableViewCell
    
    var cellEventHandler: TableAdaptor? {
        get {
            return objc_getAssociatedObject(self, &eventHandlerKey) as? TableAdaptor
        }
        set {
            objc_setAssociatedObject(self, &eventHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func sendEvent(withName name: ViewCustomEventName, cell: UITableViewCell) {
        cellEventHandler?.handleEvent(withName: name, cell: cell)
    }
}

extension UICollectionViewCell: CellEventSending {
    typealias A = CollectionAdaptor
    typealias CellClass = UICollectionViewCell

    var cellEventHandler: CollectionAdaptor? {
        get {
            return objc_getAssociatedObject(self, &eventHandlerKey) as? CollectionAdaptor
        }
        set {
            objc_setAssociatedObject(self, &eventHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func sendEvent(withName name: ViewCustomEventName, cell: UICollectionViewCell) {
        cellEventHandler?.handleEvent(withName: name, cell: cell)
    }
}

private var sectionIndexKey = "sectionIndex"
private var elementKindKey = "elementKind"
private var sectionTypeKey = "sectionType"

extension UITableViewHeaderFooterView: SectionViewEventSending {
    typealias A = TableAdaptor
    typealias SectionViewClass = UITableViewHeaderFooterView
    
    var index: Int? {
        get {
            return objc_getAssociatedObject(self, &sectionIndexKey) as? Int
        }
        set {
            objc_setAssociatedObject(self, &sectionIndexKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var type: TableSectionViewType? {
        get {
            return objc_getAssociatedObject(self, &sectionTypeKey) as? TableSectionViewType
        }
        set {
            objc_setAssociatedObject(self, &sectionTypeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sectionEventHandler: TableAdaptor? {
        get {
            return objc_getAssociatedObject(self, &eventHandlerKey) as? TableAdaptor
        }
        set {
            objc_setAssociatedObject(self, &eventHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func sendEvent(withName name: ViewCustomEventName, sectionView: UITableViewHeaderFooterView) {
        sectionEventHandler?.handleEvent(withName: name, sectionView: sectionView)
    }
}

extension UICollectionReusableView: CollectionReusableViewEventSending {
    typealias A = CollectionAdaptor
    typealias SectionViewClass = UICollectionReusableView
    
    var indexPath: IndexPath? {
        get {
            return objc_getAssociatedObject(self, &sectionIndexKey) as? IndexPath
        }
        set {
            objc_setAssociatedObject(self, &sectionIndexKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var kind: String? {
        get {
            return objc_getAssociatedObject(self, &elementKindKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &elementKindKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var sectionEventHandler: CollectionAdaptor? {
        get {
            return objc_getAssociatedObject(self, &eventHandlerKey) as? CollectionAdaptor
        }
        set {
            objc_setAssociatedObject(self, &eventHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func sendEvent(withName name: ViewCustomEventName, sectionView: UICollectionReusableView) {
        sectionEventHandler?.handleEvent(withName: name, sectionView: sectionView)
    }
}


extension UITableViewCell {
    public func sendEvent(withName name: ViewCustomEventName) {
        sendEvent(withName: name, cell: self)
    }
}

extension UITableViewHeaderFooterView {
    public func sendEvent(withName name: ViewCustomEventName) {
        sendEvent(withName: name, sectionView: self)
    }
}

extension UICollectionReusableView {
    @objc public func sendEvent(withName name: ViewCustomEventName) {
        sendEvent(withName: name, sectionView: self)
    }
}

extension UICollectionViewCell {
    public override func sendEvent(withName name: ViewCustomEventName) {
        sendEvent(withName: name, cell: self)
    }
}

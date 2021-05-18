//
//  AdaptorCustomEvent.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/17.
//

import Foundation

public typealias ViewCustomEventName = String

let SectionExpandEvent: ViewCustomEventName = "SectionExpand"
let SectionCollapseEvent: ViewCustomEventName = "SectionCollapse"
let CellRemovedEvent: ViewCustomEventName = "CellRemoved"

protocol ViewCustomEventhandling {
    associatedtype CellClass
    associatedtype SectionViewClass

    func handleEvent(withName name: ViewCustomEventName, cell: CellClass)
    func handleEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
}

protocol CellCustomEventSending {
    associatedtype A: ViewCustomEventhandling
    associatedtype CellClass
    
    var  cellEventHandler: A? { get set }
    func sendEvent(withName name: ViewCustomEventName, cell: CellClass)
}

protocol SectionViewEventSending {
    associatedtype A: ViewCustomEventhandling
    associatedtype SectionViewClass
    
    var  sectionEventHandler: A? { get set }
    func sendEvent(withName name: ViewCustomEventName, sectionView: SectionViewClass)
}

enum TableSectionViewType {
    case Header
    case Footer
}

protocol TableSectionViewEventSending: SectionViewEventSending  {
    var type: TableSectionViewType? { get set }
    var index: Int? { get set }
}

protocol CollectionReusableViewEventSending: SectionViewEventSending {
    var  indexPath: IndexPath? { get set }
    var  kind: String? { get set }
}

private var eventHandlerKey = "EventHandler"

extension UITableViewCell: CellCustomEventSending {
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

extension UICollectionViewCell: CellCustomEventSending {
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
            return objc_getAssociatedObject(self, &sectionIndexKey) as? TableSectionViewType
        }
        set {
            objc_setAssociatedObject(self, &sectionIndexKey, newValue, .OBJC_ASSOCIATION_RETAIN)
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

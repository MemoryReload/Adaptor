//
//  SectionViewModel.swift
//  Adaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

open class TableSectionViewHolder: SectionViewHolderBaseProtocol {
    
    public var headerData: Any?
    
    /// If header view is fixed height, assign the proper height for the header. If nil, the header view
    /// will be auto-dimensioned. Default is nil.
    public var headerHeight: CGFloat?
    public var headerViewClass: UITableViewHeaderFooterView.Type?
    
    
    public var footerData: Any?
    /// If footer view is fixed height, assign the proper height for the footer. If nil, the footer view
    /// will be auto-dimensioned. Default is nil.
    public var footerHeight: CGFloat?
    public var footerViewClass: UITableViewHeaderFooterView.Type?
    
    public var cellHolders: [TableCellViewHolder] = []
    public var collapsed: Bool = false
    public var cellCounts: Int {
        if collapsed {
            return 0
        }
        return cellHolders.count
    }
    public required init() { }
    
    convenience init(holders:[TableCellViewHolder], headerData: Any? = nil, headerClass: UITableViewHeaderFooterView.Type? = nil, headerHeight: CGFloat? = 0, footerData: Any? = nil, footerClass:UITableViewHeaderFooterView.Type? = nil, footerHeight: CGFloat? = 0) {
        self.init()
        cellHolders = holders
        self.headerData = headerData
        self.headerViewClass = headerClass
        self.headerHeight = headerHeight
        self.footerData = footerData
        self.footerViewClass = footerClass
        self.footerHeight = footerHeight
    }
    
    public subscript(_ index: Int) -> TableCellViewHolder {
        get {
            cellHolders[index]
        }
        set {
            cellHolders[index] = newValue
        }
    }
    
    public subscript(_ index: Int) -> Any? {
        get {
            self[index].cellData
        }
        set {
            self[index].cellData = newValue
        }
    }
}

extension TableSectionViewHolder: TableSectionViewHolderEventProtocol {
    @objc open func didUpdateWith(container: UITableView, header: UITableViewHeaderFooterView, forSection section: Int) {
        header.update(data: headerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc open func willDisplayWith(container: UITableView, header: UITableViewHeaderFooterView, forSection section: Int) { }
    @objc open func didEndDisplayWith(container: UITableView, header: UITableViewHeaderFooterView, forSection section: Int) { }
    
    @objc open func didUpdateWith(container: UITableView, footer: UITableViewHeaderFooterView, forSection section: Int) {
        footer.update(data: footerData, collapsed: collapsed, count: cellHolders.count)
    }
    @objc open func willDisplayWith(container: UITableView, footer: UITableViewHeaderFooterView, forSection section: Int) { }
    @objc open func didEndDisplayWith(container: UITableView, footer: UITableViewHeaderFooterView, forSection section: Int) { }
    
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UITableView, header: UITableViewHeaderFooterView, forSection section: Int) { }
    @objc open func handleEvent(withName name: ViewCustomEventName, container: UITableView, footer: UITableViewHeaderFooterView, forSection section: Int) { }
}

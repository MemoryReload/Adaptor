//
//  UITableView+Adaptor.swift
//  TableAdaptor
//
//  Created by HePing on 2021/4/18.
//

import Foundation

private var dataSourceKey = "DataSource"

extension Adaptor where T: UITableView {
    //MARK: DataHandling
    public var dataSource:[SectionViewHolder]? {
        get {
            return objc_getAssociatedObject(self, &dataSourceKey) as! [SectionViewHolder]?
        }
        set {
            objc_setAssociatedObject(self, &dataSourceKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    //MARK: DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?[section].cellCounts ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        guard let cellClass = cellData?.cellClass else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(cellClass)) {
            cell.update(data: cellData)
            return cell
        }
        let cell = cellClass.init(style: .default, reuseIdentifier: NSStringFromClass(cellClass))
        cell.update(data: cellData)
        return cell
    }
    //MARK: ViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellHolder = dataSource?[indexPath.section].cellHodlers?[indexPath.row]
        if let heightCallback = cellHolder?.cellHeight {
            return heightCallback(cellHolder?.cellData)
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let sectionHolder = dataSource?[section]
        if let heightCallback = sectionHolder?.headerHeight  {
            return heightCallback(sectionHolder?.headerData)
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionHolder = dataSource?[section]
        guard let headerViewClass  = sectionHolder?.headerViewClass else { return nil }
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(headerViewClass)) {
            headerView.update(data: sectionHolder?.headerData)
            return headerView
        }
        let headerView:UIView = headerViewClass.init(frame:CGRect.zero)
        headerView.update(data: sectionHolder?.headerData)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        let sectionHolder = dataSource?[section]
        if let heightCallback = sectionHolder?.footerHeight  {
            return heightCallback(sectionHolder?.footerData)
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let sectionHolder = dataSource?[section]
        guard let footerViewClass  = sectionHolder?.footerViewClass else { return nil }
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(footerViewClass)) {
            footerView.update(data: sectionHolder?.footerData)
            return footerView
        }
        let footerView:UIView = footerViewClass.init(frame:CGRect.zero)
        footerView.update(data: sectionHolder?.footerData)
        return footerView
    }
}

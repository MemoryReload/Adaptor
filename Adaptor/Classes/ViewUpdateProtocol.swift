//
//  AdaptorViewUpdateProtocol.swift
//  Adaptor
//
//  Created by HePing on 2021/4/30.
//

import Foundation


/// The base protocol for cell updating data.
public protocol CellUpdateProtocol {
    
    /// Called when the cell holder set data for the specified cell view.
    /// - Parameter data: user custom data
    func update(data:Any?)
}

/// The base protocol for section view updating data.
public protocol SectionViewUpdateProtocol {
    
    /// Called when the section view holder set data for the specified section view.
    /// - Parameters:
    ///   - data: The user custom data
    ///   - collapsed: The current display status for the specified section ( whether the section is
    ///   collapsed or not now).
    ///   - count: The display count for the specified section.
    /// - Note: The count here will be the actual cell view holders count of this section, even if
    ///   the section is collapsed. You should handle collapsing all by yourself.
    func update(data:Any?, collapsed:Bool, count: Int)
}


/// Table view cell reusing protocol.
protocol TableCellViewReuseProtocol {
    associatedtype V
    
    /// Dequeue a cell with its identifier from its container.
    /// - Parameters:
    ///   - container: The cell container
    ///   - withIdentifier: The reusing identifier of the cell
    static func dequeue(from container:UITableView, withIdentifier: String ) -> V?
}

/// Collection view supplementary view (header, footer, etc) reusing protocol.
protocol CollectionReusableViewReuseProtocol
{
    /// Dequeue a supplementary view from its container
    /// - Parameters:
    ///   - container: The supplementary view container
    ///   - elementKind: The kind of the supplementary view
    ///   - identifier: The reusing identifier of the supplementary view
    ///   - indexPath: The index path of the supplementary view
    static func dequeue(from container:UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView
}

/// Collection view cell reusing protocol
protocol CollectionCellViewReuseProtocol
{
    /// Deaueue a collection view cell from its container
    /// - Parameters:
    ///   - container: The cell container
    ///   - withIdentifier: The reusing identifier of the cell
    ///   - indexPath: The index path of the cell
    static func dequeue(from container:UICollectionView, withIdentifier: String, indexPath: IndexPath ) -> UICollectionViewCell
}

extension UITableViewCell: TableCellViewReuseProtocol, CellUpdateProtocol
{
    public typealias V =  UITableViewCell
    
    static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewCell? {
        return container.dequeueReusableCell(withIdentifier: withIdentifier)
    }
    
    @objc open func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

extension UITableViewHeaderFooterView: TableCellViewReuseProtocol, SectionViewUpdateProtocol
{
    public typealias V = UITableViewHeaderFooterView
    
    static func dequeue(from container: UITableView, withIdentifier: String) -> UITableViewHeaderFooterView? {
        container.dequeueReusableHeaderFooterView(withIdentifier: withIdentifier)
    }
    
    @objc open func update(data: Any?, collapsed: Bool, count: Int) {
        assert(false, "subclass override stub!")
    }
}


extension UICollectionReusableView: CollectionReusableViewReuseProtocol, SectionViewUpdateProtocol {
    public typealias V = UICollectionReusableView
    
    static func dequeue(from container: UICollectionView, ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        container.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
    }
    
    @objc open func update(data: Any?, collapsed: Bool, count: Int) {
        assert(false, "subclass override stub!")
    }
}

extension UICollectionViewCell: CollectionCellViewReuseProtocol, CellUpdateProtocol
{
    static func dequeue(from container: UICollectionView, withIdentifier: String, indexPath: IndexPath) -> UICollectionViewCell {
        container.dequeueReusableCell(withReuseIdentifier: withIdentifier, for: indexPath)
    }
    
    @objc open func update(data:Any?) {
        assert(false, "subclass override stub!")
    }
}

//
//  AdaptorContextProtocol.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/14.
//

import Foundation


/// The outside context to work with adaptor
public protocol AdaptorContextProtocol: NSObjectProtocol {
    /// The view controller for the view which use the specified adaptor
    var containerVC: UIViewController? { get }
}

extension AdaptorContextProtocol {
    public var containerVC: UIViewController? {
        return nil
    }
}

/// The outside context to work with customized reusable supplement view of collection view
public protocol AdaptorContextReusableProtocol: AdaptorContextProtocol {
    
    /// Return the specified kind of customized supplement view for the adaptor
    /// - Parameters:
    ///   - collectionView: Collection view to cooperate with the adaptor
    ///   - kind: The kind of customized supplement view
    ///   - indexPath: The index path of customized supplement view
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    
    
    /// Called when the specified kind of customized supplement view will be displayed by the collection view
    /// - Parameters:
    ///   - collectionView: Collection view to cooperate with the adaptor
    ///   - view: The specified kind of customized supplement view
    ///   - elementKind: The kind of customized supplement view
    ///   - indexPath: The index path of customized supplement view
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
    
    
    /// Called when the specified kind of customized supplement view ends displaying on the collection view
    /// - Parameters:
    ///   - collectionView: Collection view to cooperate with the adaptor
    ///   - view: The specified kind of customized supplement view
    ///   - elementKind: The kind of customized supplement view
    ///   - indexPath: The index path of customized supplement view
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
    
    
    /// Called when the specified kind of customized supplement view emit event
    /// - Parameters:
    ///   - name: The event name
    ///   - collectionView: Collection view to cooperate with the adaptor
    ///   - kind: The kind of customized supplement view
    ///   - indexPath: The index path of customized supplement view
    func collectionViewHandleEvent(withName name: ViewCustomEventName, _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath)
}

extension AdaptorContextReusableProtocol {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        assert(false, "subclass override stub!")
        return UICollectionReusableView(frame: CGRect.zero)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) { }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) { }
    
    public func collectionViewHandleEvent(withName name: ViewCustomEventName, _ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) { }
}

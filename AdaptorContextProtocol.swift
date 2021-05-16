//
//  AdaptorContextProtocol.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/14.
//

import Foundation

public protocol AdaptorContextProtocol: NSObjectProtocol {
    var containerVC: UIViewController? { get set}
}

public protocol AdaptorContextReusableProtocol: AdaptorContextProtocol {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath)
}

extension AdaptorContextReusableProtocol {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        assert(false, "subclass override stub!")
        return UICollectionReusableView(frame: CGRect.zero)
    }
}

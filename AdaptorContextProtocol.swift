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
}

extension AdaptorContextReusableProtocol {
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        assert(false, "subclass override stub!")
        return UICollectionReusableView(frame: CGRect.zero)
    }
}

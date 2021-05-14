//
//  AdaptorContextProtocol.swift
//  Adaptor
//
//  Created by 何平 on 2021/5/14.
//

import Foundation

protocol AdaptorContextProtocol {
    var containerVC: UIViewController? { get set}
}

protocol AdaptorContextReusableProtocol: AdaptorContextProtocol {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
}

open class CollectionAdaptorContext: AdaptorContextReusableProtocol {
    weak var containerVC: UIViewController?
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        assert(false, "subclass override stub!")
        return UICollectionReusableView(frame: CGRect.zero)
    }
}

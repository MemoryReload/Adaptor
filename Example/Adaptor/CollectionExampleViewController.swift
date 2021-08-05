//
//  CollectionExampleViewController.swift
//  Adaptor_Example
//
//  Created by 何平 on 2021/7/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import Adaptor

class CollectionExampleViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerCell(cellClass: MyCollectionCell.self)
        collectionView.registerReusableView(viewClass: MyCollectionSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader)
//        collectionView.registerReusableView(viewClass: MyCollectionSection.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter)
        collectionView.useAdaptor()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout = getLayout()
        collectionView.adaptor?.dataSource = getData()
        collectionView.reloadData()
    }
    
    func getData() ->
    [CollectionSectionViewHolder] {
        var sectionHolders: [CollectionSectionViewHolder] = []
        for i in 1...3 {
            let sectionHolder = CollectionSectionViewHolder()
            sectionHolder.headerViewClass = MyCollectionSection.self
            sectionHolder.headerData = "header\(i)"
//            sectionHolder.footerViewClass = MyCollectionSection.self
//            sectionHolder.footerData = "footer: \(i)"
            sectionHolders.append(sectionHolder)
            for j in 1...4 {
                let cellHolder = CollectionCellViewHolder()
                cellHolder.cellClass = MyCollectionCell.self
                cellHolder.cellData = "row:\(j)"
                sectionHolder.cellHolders.append(cellHolder)
            }
        }
        return sectionHolders
    }
    
    func getLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.headerReferenceSize = CGSize(width: 44, height: 44)
//        layout.footerReferenceSize = CGSize(width: 44, height: 44)
        return layout
    }
}

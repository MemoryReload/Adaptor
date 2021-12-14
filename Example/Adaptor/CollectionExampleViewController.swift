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
        let sectionHolder = CollectionSectionViewHolder()
        sectionHolder.headerViewClass = MyCollectionSection.self
        sectionHolder.headerData = "header0"
        collectionView.adaptor?.appendToLast(section:sectionHolder, datas: ["row:1","row:2","row:3",], cellClass: MyCollectionCell.self, cellHolderClass: MyCollectionCellViewHolder.self)
        collectionView.adaptor?.dataSource.append(contentsOf: getData())
        collectionView.adaptor?.appendToLast(datas: ["row:5","row:5","row:6",], cellClass: MyCollectionCell.self, cellHolderClass: MyCollectionCellViewHolder.self)
        testSectionSubscrib()
        testAdaptorSubscrib()
        collectionView.reloadData()
    }
    
    func getData() ->
    [CollectionSectionViewHolder] {
        var sectionHolders: [CollectionSectionViewHolder] = []
        for i in 1...3 {
            let sectionHolder = CollectionSectionViewHolder(headerData: "header\(i)", headerClass: MyCollectionSection.self)
//            sectionHolder.footerViewClass = MyCollectionSection.self
//            sectionHolder.footerData = "footer: \(i)"
            sectionHolders.append(sectionHolder)
            for j in 1...4 {
                let cellHolder = CollectionCellViewHolder(data: "row:\(j)", cellClass: MyCollectionCell.self)
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
    
    func testSectionSubscrib(){
        collectionView.adaptor?.dataSource[0][0].cellData = "test1"
        collectionView.adaptor?.dataSource[0][1] = "test2"
    }
    
    func testAdaptorSubscrib() {
        collectionView.adaptor?[IndexPath(item: 0, section: 1)].cellData = "AdTest1"
        collectionView.adaptor?[IndexPath(item: 1, section: 1)].cellData = "AdTest2"
    }
}

class MyCollectionCellViewHolder: CollectionCellViewHolder {
    override func didSelectWith(container: UICollectionView, cell: UICollectionViewCell, index: IndexPath) {
        debugPrint("Collection Cell Clicked!")
    }
}

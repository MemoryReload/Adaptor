//
//  ViewController.swift
//  Adaptor
//
//  Created by MemoryReload on 04/18/2021.
//  Copyright (c) 2021 MemoryReload. All rights reserved.
//

import UIKit
import Adaptor

class TableExampleViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.registerCell(cellClass: MyCell.self)
        table.registerSectionView(viewClass: MySection.self)
        table.useAdaptor()
        // Do any additional setup after loading the view, typically from a nib.
        table.adaptor?.appendToLast(datas: ["row:1","row:2","row:3",], cellClass: MyAutoSizeCell.self)
        table.adaptor?.dataSource.append(contentsOf: getData())
        table.adaptor?.appendToLast(datas: ["row:4","row:5","row:6"], cellClass: MyAutoSizeCell.self)
        table.reloadData()
    }

    func getData() ->
    [TableSectionViewHolder] {
        var sectionHolders: [TableSectionViewHolder] = []
        for i in 1...3 {
            let sectionHolder = TableSectionViewHolder()
            sectionHolder.headerViewClass = MySection.self
            sectionHolder.headerHeight = 44
            sectionHolder.headerData = "header\(i)"
//            sectionHolder.footerViewClass = MySection.self
//            sectionHolder.footerHeight = 20
//            sectionHolder.footerData = "footer: \(i)"
            sectionHolders.append(sectionHolder)
            for j in 1...4 {
                if j % 2 == 0 {
                    let cellHolder = TableCellViewHolder()
                    cellHolder.cellClass = MyAutoSizeCell.self
                    cellHolder.cellData = "row:\(j)"
                    sectionHolder.cellHolders.append(cellHolder)
                }else{
                    let cellHolder = TableCellViewHolder()
                    cellHolder.cellClass = MyCell.self
                    cellHolder.cellData = "row:\(j)"
                    cellHolder.cellHeight = 80
                    sectionHolder.cellHolders.append(cellHolder)
                }
            }
        }
        return sectionHolders
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


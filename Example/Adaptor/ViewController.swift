//
//  ViewController.swift
//  Adaptor
//
//  Created by MemoryReload on 04/18/2021.
//  Copyright (c) 2021 MemoryReload. All rights reserved.
//

import UIKit
import Adaptor

class ViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.registerCell(cellClass: MyCell.self)
        table.registerSectionView(viewClass: MySection.self)
        table.useAdaptor()
        // Do any additional setup after loading the view, typically from a nib.
        table.adaptor?.dataSource = getData()
        table.reloadData()
    }

    func getData() ->
    [TableSectionViewHolder] {
        var sectionHolders: [TableSectionViewHolder] = []
        for i in 1...3 {
            let sectionHolder = TableSectionViewHolder()
            sectionHolder.headerViewClass = MySection.self
            sectionHolder.headerHeight = 20
            sectionHolder.headerData = "header\(i)"
//            sectionHolder.footerViewClass = MySection.self
//            sectionHolder.footerHeight = 20
//            sectionHolder.footerData = "footer: \(i)"
            sectionHolders.append(sectionHolder)
            for j in 1...4 {
                let cellHolder = TableCellViewHolder()
                cellHolder.cellClass = MyCell.self
                cellHolder.cellData = "row:\(j)"
                cellHolder.cellHeight = 80
                sectionHolder.cellHodlers.append(cellHolder)
            }
        }
        return sectionHolders
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


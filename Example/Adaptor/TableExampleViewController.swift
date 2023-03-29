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
        table.ac.useAdaptor()
        // Do any additional setup after loading the view, typically from a nib.
        table.ac.adaptor?.appendToLast(datas: ["row:1","row:2","row:3",], cellClass: MyAutoSizeCell.self, cellHolderClass: MyCellViewHolder.self)
        table.ac.adaptor?.dataSource.append(contentsOf: getData())
        table.ac.adaptor?.appendToLast(datas: ["row:4","row:5","row:6"], cellClass: MyCell.self,cellHeight: 80, cellHolderClass: MyCellViewHolder.self)
        testSectionSubscrib()
        testAdaptorSubscrib()
        testSearch()
        table.reloadData()
    }

    func getData() ->
    [TableSectionViewHolder] {
        var sectionHolders: [TableSectionViewHolder] = []
        for i in 1...3 {
            let sectionHolder = TableSectionViewHolder(headerData: "header\(i)", headerClass: MySection.self, headerHeight: 44)
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
                    let cellHolder = TableCellViewHolder(data: "row:\(j)", cellClass: MyCell.self, cellHeight: 80)
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

    func testSectionSubscrib(){
        table.ac.adaptor?.dataSource[0][0].cellData = "test1"
        table.ac.adaptor?.dataSource[0][1] = "test2"
    }
    
    func testAdaptorSubscrib() {
        table.ac.adaptor?[IndexPath(row: 0, section: 1)].cellData = "AdTest1"
        table.ac.adaptor?[IndexPath(row: 1, section: 1)].cellData = "AdTest2"
    }
    
    func testSearch() {
        if let section = table.ac.adaptor?.getSectionHolder(withHeaderData: "header1", comparisonHandler: { $0 as? String == $1 as? String}) {
            print("found1 at Index \(section.0), section \(section.1)")
        }
        if let section = table.ac.adaptor?.getSectionHolder(withHeaderData: "header1") {
            print("found2 foun at Index \(section.0), section \(section.1)")
        }
        if let c = table.ac.adaptor?.getCellHolder(withCellData: "AdTest1", comparisonHandler: {$0 as? String == $1 as? String}) {
            print("found1 at index \(c.0), cell \(c.1)")
        }
        if let c = table.ac.adaptor?.getCellHolder(withCellData: "AdTest2") {
            print("found2 at index \(c.0), cell \(c.1)")
        }
    }
}

class MyCellViewHolder: TableCellViewHolder {
    override func didSelectWith(container: UITableView, cell: UITableViewCell, index: IndexPath) {
        debugPrint("Table Cell Clicked!")
    }
}


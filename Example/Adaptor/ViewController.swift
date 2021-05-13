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
        table.useAdaptor()
        // Do any additional setup after loading the view, typically from a nib.
        table.adaptor.dataSource = getData()
        table.reloadData()
    }

    func getData() ->
    [TableSectionViewHolder] {
        var cellHolders: [TableCellViewHolder]
        for i in 0..<4 {
            
        }
        return []
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


//
//  ViewController.swift
//  Boost
//
//  Created by Thong Hao Yi on 18/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let vm = ViewControllerVM()
    
    let cellIdentifier = "HYTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        initData()
    }
    
    func initTableView() {
        tableView.register(UINib(nibName: "HYTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.dataSource = self
    }
    
    func initData() {
        vm.getJSON()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HYTableViewCell ?? { () -> HYTableViewCell in
            return HYTableViewCell.init()
        }()
        
        cell.setupVM(vm: vm.generateTableViewVM(user: vm.users[indexPath.row]))
        
        return cell
    }
}


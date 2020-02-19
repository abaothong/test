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
    let refreshControl = UIRefreshControl()
    let loadingView = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let vm = ViewControllerVM()
    let cellIdentifier = "HYTableViewCell"
    
    var isPullToRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.delegate = self
        initUI()
        initTableView()
        initData()
    }
    
    func initUI() {
        self.navigationItem.title = "Contacts"
        let rightBtn = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewItem)
        )
        rightBtn.tintColor = ColorConstant.themeColor
        self.navigationItem.rightBarButtonItem = rightBtn
        initLoadingView()
    }
    func initTableView() {
        tableView.register(UINib(nibName: "HYTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        initRefreshController()
    }
    
    func initRefreshController() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func initLoadingView() {
        let loadingIndicator = UIActivityIndicatorView(
            frame: CGRect(
                x: 10,
                y: 5,
                width: 50,
                height: 50
            )
        )
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        loadingView.view.addSubview(loadingIndicator)
    }
    
    func initData() {
        vm.getJSON()
    }
    
    @objc func pullToRefresh() {
        isPullToRefresh = true
        tableView.refreshControl?.beginRefreshing()
        initData()
    }
    
    @objc func addNewItem() {
        
    }
}
extension ViewController: ViewControllerVMDelegate {
    func beginLoading() {
        present(loadingView, animated: true, completion: nil)
    }
    
    func endLoading() {
        if loadingView.isBeingPresented {
            loadingView.dismiss(animated: true, completion: nil)
        }
        
        if isPullToRefresh {
            isPullToRefresh = false
            tableView.refreshControl?.endRefreshing()
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.contentOffset = .zero
            })
        }
    }
    
    func updateUI() {
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}


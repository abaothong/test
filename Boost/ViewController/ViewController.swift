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
    
    var vm: ViewControllerVM? = nil
    var router: ViewControllerRouter? = nil
    
    let cellIdentifier = "HYTableViewCell"
    
    var isPullToRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = ViewControllerVM()
        vm?.delegate = self
        router = ViewControllerRouter(vc: self)
        
        initUI()
        initTableView()
        initData()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LoadingManager.shared.hide()
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
    }
    func initTableView() {
        tableView.register(UINib(nibName: "HYTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        initRefreshController()
    }
    
    func initRefreshController() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func initData() {
        vm?.getJSON()
    }
    
    @objc func pullToRefresh() {
        isPullToRefresh = true
        tableView.refreshControl?.beginRefreshing()
        initData()
    }
    
    @objc func addNewItem() {
        router?.navigateToForm(
            delegate: self,
            type: .create
        )
    }
}
extension ViewController: ViewControllerVMDelegate {
    func beginLoading() {
        LoadingManager.shared.show(vc: self)
    }
    
    func endLoading() {
        LoadingManager.shared.hide()
        
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

extension ViewController: FormDataDelgate {
    func createUser(user: User) {
        //
    }
    
    func updateUser(user: User, at index: Int) {
        //
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let vm = vm else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HYTableViewCell ?? { () -> HYTableViewCell in
            return HYTableViewCell.init()
            }()
        
        cell.setupVM(vm: vm.generateTableViewVM(user: vm.users[indexPath.row]))
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = vm?.users[indexPath.row] {
            router?.navigateToForm(
                delegate: self,
                type: .edit(
                    user: user,
                    index: indexPath.row
                )
            )
        }
    }
}


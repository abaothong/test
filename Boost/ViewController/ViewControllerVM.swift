//
//  ViewControllerVM.swift
//  Boost
//
//  Created by Thong Hao Yi on 18/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import Foundation

protocol ViewControllerVMDelegate {
    func beginLoading()
    func endLoading()
    func updateUI()
}

class ViewControllerVM {
    
    var delegate: ViewControllerVMDelegate? = nil
    var users: [User] = []
    
    func getJSON() {
        guard let delegate = self.delegate else {
            print("delegate lost")
            return
        }
        delegate.beginLoading()
        
        if let path = Bundle.main.path(forResource: "data",ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    self.users = users
                    delegate.endLoading()
                    delegate.updateUI()
                } catch {
                    self.users = []
                    print(error.localizedDescription)
                    delegate.endLoading()
                }
            } catch {
                self.users = []
                print(error.localizedDescription)
                delegate.endLoading()
            }
        }
    }
    
    func generateTableViewVM(user: User) -> HYTableViewCellVM {
        return HYTableViewCellVM(
            avatar: nil,
            name: "\(user.firstName) \(user.lastName)"
        )
    }
}




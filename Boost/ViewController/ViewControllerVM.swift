//
//  ViewControllerVM.swift
//  Boost
//
//  Created by Thong Hao Yi on 18/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import Foundation

class ViewControllerVM {

    var users: [User] = []
    
    func getJSON() {
        if let path = Bundle.main.path(forResource: "data",ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    self.users = users
                } catch {
                    self.users = []
                    print(error.localizedDescription)
                }
            } catch {
                self.users = []
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




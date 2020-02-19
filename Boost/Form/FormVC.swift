//
//  FormVC.swift
//  Boost
//
//  Created by Thong Hao Yi on 19/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

enum FormType {
    case create
    case edit(user: User, index: Int)
}

protocol FormDataDelgate {
    func createUser(user: User)
    func updateUser(user: User, at index: Int)
}

class FormVC: UIViewController {

    var vm: FormVCVM? = nil
    var delegate: FormDataDelgate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

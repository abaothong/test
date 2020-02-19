//
//  ViewControllerRouter.swift
//  Boost
//
//  Created by Thong Hao Yi on 19/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

class ViewControllerRouter {

    let mVC: ViewController
    
    init(vc: ViewController) {
        mVC = vc
    }
    
    func navigateToForm(delegate: FormDataDelgate) {
        let storyboard = UIStoryboard(name: "Form", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FormVC")
        if let vc = controller as? FormVC {
             vc.delegate = delegate
             vc.vm = FormVCVM(type: .create)
             
             mVC.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
}

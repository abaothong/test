//
//  LoadingManager.swift
//  Boost
//
//  Created by Thong Hao Yi on 20/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

private var window: UIWindow?

class LoadingManager  {
    
    static let shared = LoadingManager()
    let loadingView = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    init() {
        initLoadingView()
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
    
    func show(vc: UIViewController) {
        if !loadingView.isBeingPresented {
            vc.present(loadingView, animated: true, completion: nil)
        }
    }
    
    func hide(complete: (()->())? = nil) {
        DispatchQueue.main.async{
            self.loadingView.dismiss(animated: true, completion: complete)
        }
    }
}

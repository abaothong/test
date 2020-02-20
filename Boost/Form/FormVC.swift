//
//  FormVC.swift
//  Boost
//
//  Created by Thong Hao Yi on 20/02/2020.
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

class FormVC: UITableViewController {
    
    var vm: FormVCVM? = nil
    var delegate: FormDataDelgate? = nil
    
    @IBOutlet weak var avatarView: UIView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm?.delegate = self
        initUI()
        initData()
    }
    
    func initUI() {
               
        let rightBtn = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(save)
        )
        rightBtn.tintColor = ColorConstant.themeColor
        self.navigationItem.rightBarButtonItem = rightBtn
        
        let leftButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancel)
        )
        leftButton.tintColor = ColorConstant.themeColor
        self.navigationItem.leftBarButtonItem = leftButton
        
        avatarView.backgroundColor = ColorConstant.themeColor
        avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
        avatarView.clipsToBounds = true
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LoadingManager.shared.hide()
    }
    
    func initData() {
        guard let vm = vm else {
            return
        }
        switch vm.type {
        case .create:
            break
        case .edit(let user, _):
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
            emailTextField.text = user.email
            phoneTextField.text = user.phone
        }
    }
    @objc func save() {
        guard let vm = vm else {
            return
        }
        vm.saveUser(
            firstName: firstNameTextField.text,
            lastName: lastNameTextField.text,
            email: emailTextField.text,
            phone: phoneTextField.text
        )
    }
    
    @objc func cancel() {
        popCancelWarning()
    }
    
    func popCancelWarning() {
        LoadingManager.shared.hide()
        let alert = UIAlertController(
            title: "Warning",
            message: "You want to cancel create new user?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
                
        }))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: { action in
                self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FormVC: FormVCVMDelegate {
    
    func beginLoading() {
        LoadingManager.shared.show(vc: self)
    }
    
    func endLoading() {
        LoadingManager.shared.hide()
    }
    
    func saveDone() {
        LoadingManager.shared.hide(complete: {
            let alert = UIAlertController(
                title: "Done",
                message: "Save Success",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    self.dismiss(animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
            }))
            DispatchQueue.main.async{
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func popError(message: String) {
        LoadingManager.shared.hide(complete: {
            let alert = UIAlertController(
                title: "Alert",
                message: message,
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
            }))
            DispatchQueue.main.async{
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension FormVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

//
//  FormVCVM.swift
//  Boost
//
//  Created by Thong Hao Yi on 19/02/2020.
//  Copyright © 2020 Abao. All rights reserved.
//

import UIKit

protocol FormVCVMDelegate {
    func beginLoading()
    func endLoading()
    func saveDone()
    func popError(message: String)
}

class FormVCVM {
    
    var delegate: FormVCVMDelegate? = nil
    let type: FormType
    
    init(type: FormType) {
        self.type = type
    }
    
    func saveUser(firstName: String?,
                  lastName: String?,
                  email: String?,
                  phone: String?) {
        let check = validate(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone
        )
        
        if check.validate {
            switch type {
            case .create:
                save(
                    user: User(
                        id: getRandomId(),
                        firstName: firstName!,
                        lastName: lastName!,
                        email: email,
                        phone: phone
                    ),
                    index: nil
                )
            case .edit(let user, let index):
                save(
                    user: User(
                        id: user.id,
                        firstName: firstName!,
                        lastName: lastName!,
                        email: email,
                        phone: phone
                    ),
                    index: index
                )
                break
            }
            
        } else {
            delegate?.popError(message: check.errorMessage)
        }
    }
    
    func validate(firstName: String?,
                  lastName: String?,
                  email: String?,
                  phone: String?) -> (validate: Bool, errorMessage :String) {
        
        guard let firstName = firstName,
            firstName.count > 0 else {
                return (false, "Please fill in First Name")
        }
        
        guard let lastName = lastName,
            lastName.count > 0 else {
                return (false, "Please fill in Last Name")
        }
        
        //verify email
        //        if let email = email {
        //            if !isValidEmail(email) {
        //                return (false, "Please fill in correct email")
        //            }
        //        }
        
        return (true, "")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func getRandomId() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).map{ _ in letters.randomElement()! })
        
    }
    
    func save(user: User, index: Int?) {
        if let delegate = delegate {
            delegate.beginLoading()
        }
        getJSON { (isError, users) in
            if !isError {
                var newUser = users
                if let index = index {
                    newUser[index] = user
                } else {
                    newUser.append(user)
                }
                saveJSON(users: newUser) { (isError) in
                    if isError {
                        if let delegate = delegate {
                            delegate.endLoading()
                            delegate.popError(message: "Save Json Error")
                        }
                    } else {
                        if let delegate = delegate {
                            delegate.endLoading()
                            delegate.saveDone()
                        }
                    }
                }
            } else {
                if let delegate = delegate {
                    delegate.endLoading()
                    delegate.popError(message: "Get Json Error")
                }
            }
        }
    }
    
    func getJSON(complete: ((_ isError: Bool, _ users: [User]) -> ())) {
        if let path = Bundle.main.path(forResource: "data",ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe)
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    complete(false, users)
                } catch {
                    print(error.localizedDescription)
                    complete(true, [])
                }
            } catch {
                print(error.localizedDescription)
                complete(true, [])
            }
        }
    }
    func saveJSON(users: [User],
                  complete: ((_ isError: Bool) ->())) {
        var jsonData: Data!
        do {
            jsonData = try JSONEncoder().encode(users)
        } catch {
            print(error.localizedDescription)
            complete(true)
        }
//
//        // Write that JSON to the file created earlier
//        if let path = Bundle.main.path(forResource: "data",ofType: "json") {
//            let url = URL(fileURLWithPath: path)
//            do {
//                let file = try FileHandle(forWritingTo: url)
//                file.write(jsonData)
//                try file.close()
//                complete(true)
//            } catch {
//                print(error.localizedDescription)
//                complete(true)
//            }
//        }
        
        if let filePath = Bundle.main.url(forResource: "data", withExtension: "json") {
            
            do {
                try jsonData.write(to: filePath, options: .atomic)
                complete(false)
            } catch {
                print(error)
                 complete(true)
            }
            
        }
    }
}

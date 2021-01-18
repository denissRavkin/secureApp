//
//  RegisterViewController.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit
import Locksmith

class RegisterViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveLoginPassword() {
        
        guard let login = loginTF.text, let password = passwordTF.text else { return }
        
        if password.count < 8 {
            presentAlertController(with: "", message: "пароль должен содержать больше 8 символов")
            return
        }
        
        if Locksmith.loadDataForUserAccount(userAccount: login) != nil {
            presentAlertController(with: "", message: "этот логин занят другим пользователем")
            return
        }
        
        do {
            try Locksmith.saveData(data: ["login": login, "password": password], forUserAccount: login)
            print("forUserAccount:\(login)")
        } catch  {
            print("не удалось сохранить")
        }
    }

}

extension RegisterViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case loginTF:
            loginTF.resignFirstResponder()
            passwordTF.becomeFirstResponder()
        case passwordTF:
            saveLoginPassword()
        default:
            break
        }
        
        return true
    }
}

extension RegisterViewController {
    func presentAlertController(with title: String, message: String) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            alertC.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self.present(alertC, animated: true, completion: nil)
        }
    }
}

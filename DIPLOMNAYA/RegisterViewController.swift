//
//  RegisterViewController.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit
import Locksmith
import CryptoSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveLoginPassword() {
        
        guard let login = loginTF.text, let password = passwordTF.text else { return }
        
        if password.count < 8 {
            presentAlertController(with: "", message: "пароль повинен містити більше 8 символів")
            return
        }
        
        if LocksmithManager.loadDataForUserAccount(userAccount: login) != nil {
            presentAlertController(with: "", message: "цей логін зайнятий іншим користувачем")
            return
        }
        
        let hashPassword = CryptoHelper.hash(password: password, for: login)
        do {
            var startTime = CFAbsoluteTimeGetCurrent()
            try LocksmithManager.saveData(data: ["login": login, "password": hashPassword], forUserAccount: login)
            var time = CFAbsoluteTimeGetCurrent() - startTime
            print("сохранение в кейчейн \(time)")
            startTime = CFAbsoluteTimeGetCurrent()
            UserDefaultsManager.isUserRegistered = true
            time = CFAbsoluteTimeGetCurrent() - startTime
            print("сохранение в UserDefaults \(time)")
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

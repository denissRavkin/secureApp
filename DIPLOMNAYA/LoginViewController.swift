//
//  LoginViewController.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var biometricAuthButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    let biometric = Biometric()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTF.delegate = self
        passwordTF.delegate = self
        
        switch biometric.biometricType() {
        case .touchID:
            biometricAuthButton.setTitle("Увійти за допомогою Touch id", for: .normal)
        case .faceID:
            biometricAuthButton.setTitle("Увійти за допомогою Face id", for: .normal)
        case .none:
            biometricAuthButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let time = CFAbsoluteTimeGetCurrent() - startTime
        print("извлечение из UserDefaults \(time)")
        if UserDefaultsManager.isUserRegistered {
            biometricAuthButton.isHidden = false
        } else {
            biometricAuthButton.isHidden = true
        }
    }
    
    @IBAction func enter() {
        guard let login = loginTF.text, let password = passwordTF.text else { return }
        var startTime = CFAbsoluteTimeGetCurrent()
        guard let userDictionary = LocksmithManager.loadDataForUserAccount(userAccount: login) else {
            presentAlertController(with: "", message: "неверный логин")
            return
        }
        var time = CFAbsoluteTimeGetCurrent() - startTime
        print("извлечь из Keychain - \(time)")
        startTime = CFAbsoluteTimeGetCurrent()
        let hashPassword = CryptoHelper.hash(password: password, for: login)
        time = CFAbsoluteTimeGetCurrent() - startTime
        print("хеширование - \(time)")
        if userDictionary["password"] as! String == hashPassword {
            LocksmithManager.saveEvaluatedPolicyDomainState(domainState: biometric.context.evaluatedPolicyDomainState)
            performSegue(withIdentifier: "toUsersTableVC", sender: nil)
        }
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func biometricAuthButtonAction() {
        biometric.authenticateUser() { [weak self] message in
          if let _ = message {
            DispatchQueue.main.async {
                self?.loginTF.becomeFirstResponder()
                let alertView = UIAlertController(title: "Помилка",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true, completion: nil)
            }
          } else {
            self?.performSegue(withIdentifier: "toUsersTableVC", sender: self)
          }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
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
            enter()
        default:
            break
        }
        return true
    }
}

extension LoginViewController {
    func presentAlertController(with title: String, message: String) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            alertC.addAction(.init(title: "OK", style: .cancel, handler: nil))
            self.present(alertC, animated: true, completion: nil)
        }
    }
}

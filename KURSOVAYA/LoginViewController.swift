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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTF.delegate = self
        passwordTF.delegate = self
    }
    
    
    @IBAction func enter() {
        
        guard let login = loginTF.text, let password = passwordTF.text else { return }
        
        let userDictionary = Locksmith.loadDataForUserAccount(userAccount: login)
        print("login-\(login)")
        if userDictionary == nil {
            presentAlertController(with: "", message: "неверный логин")
            return
        }
        
        guard let userDict = userDictionary else { return }
        
        if userDict["password"] as! String == password {
            performSegue(withIdentifier: "toUsersTableVC", sender: nil)
        }
        
    }
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

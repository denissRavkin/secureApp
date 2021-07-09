//
//  Biometric.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 03.05.2021.
//

import Foundation
import LocalAuthentication
import Locksmith

enum BiometricType {
  case none
  case touchID
  case faceID
}

class Biometric {
    let context = LAContext()
    var oldDomainState: Data? {
       getOldDomainStatus()
    }
    
    func getOldDomainStatus() -> Data? {
        if let userDictionary = LocksmithManager.loadDataForUserAccount(userAccount: "user") {
             let data = userDictionary["oldDomainState"] as? Data 
             return data
         }
         return nil
    }
    
  func biometricType() -> BiometricType {
   // let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    switch context.biometryType {
    case .none:
      return .none
    case .touchID:
      return .touchID
    case .faceID:
      return .faceID
    }
  }

  func canEvaluatePolicy() -> Bool {
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }

  func authenticateUser(completion: @escaping (String?) -> Void) {
    guard canEvaluatePolicy() else {
      completion("Touch ID not available")
      return
    }
    if let domainState = context.evaluatedPolicyDomainState, domainState == oldDomainState {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Вхід у застосунок") { (success, evaluateError) in
          if success {
            DispatchQueue.main.async {
              completion(nil)
            }
          } else {
            let message: String
            switch evaluateError {
            case LAError.authenticationFailed?:
              message = "Не вдалося підтвердити вашу особу."
            case LAError.userCancel?:
              message = "Ви натиснули cancel."
            case LAError.userFallback?:
              message = "Ви натиснули пароль."
            case LAError.biometryNotAvailable?:
              message = "Face ID / Touch ID недоступні."
            case LAError.biometryNotEnrolled?:
              message = "Face ID / Touch ID не налаштовано."
            case LAError.biometryLockout?:
              message = "Face ID / Touch ID заблоковано."
            default:
              message = "Face ID / Touch ID може бути не налаштовано"
            }
            completion(message)                            }
        }
    } else {
        completion("Ви оновили біометрію, введіть логін і пароль")
    }
  }
}

//
//  LocksmithManager.swift
//  DIPLOMNAYA
//
//  Created by Denis Ravkin on 05.06.2021.
//

import Foundation
import Locksmith

class LocksmithManager {
    static func loadDataForUserAccount(userAccount: String) -> [String : Any]? {
        return Locksmith.loadDataForUserAccount(userAccount: userAccount)
    }
    static func saveEvaluatedPolicyDomainState(domainState: Data?) {
        if let domainState = domainState {
            do {
                try Locksmith.saveData(data: ["oldDomainState" : domainState], forUserAccount: "user")
            } catch  {
                do {
                    try Locksmith.updateData(data: ["oldDomainState" : domainState], forUserAccount: "user")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    static func saveData(data: [String : Any], forUserAccount userAccount: String) throws {
        try Locksmith.saveData(data: data, forUserAccount: userAccount)
    }
}

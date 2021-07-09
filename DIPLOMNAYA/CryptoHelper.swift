//
//  CryptoHelper.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 02.05.2021.
//

import Foundation
import CryptoSwift

class CryptoHelper {
    private static let salt = "jalLdjAkflWd.aqsd,()msafgPaZalsLd"

    static func hash(password: String, for login: String) -> String {
      let salt = "jalLdjAkflWd.aqsd,()msafgPaZalsLd"
        return "\(password).\(login).\(salt)".sha3(.sha512)
    }
}

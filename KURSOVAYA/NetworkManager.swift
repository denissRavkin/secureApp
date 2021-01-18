//
//  NetworkManager.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 03.01.2021.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
  case users
  
  static let baseURLString = "https://jsonplaceholder.typicode.com/users"
  
  func asURLRequest() throws -> URLRequest {
    let url = URL(string: Router.baseURLString)!
    return URLRequest(url: url)
  }
    
}

final class NetworkClient {
  
  let evaluators = [
    "jsonplaceholder.typicode.com":
      PinnedCertificatesTrustEvaluator(certificates: [
        Certificates.stackExchange
        ])
  ]
  
  let session: Session
  
  private init() {
    session = Session(
      serverTrustManager: ServerTrustManager(evaluators: evaluators)
    )
  }
  
  private static let shared = NetworkClient()
  
  static func request(_ convertible: URLRequestConvertible) -> DataRequest {
    return shared.session.request(convertible)
  }
}

struct Certificates {
  static let stackExchange =
    Certificates.certificate(filename: "snicloudflaresslcom_cert_out")
  
  private static func certificate(filename: String) -> SecCertificate {
    let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
    let certificate = SecCertificateCreateWithData(nil, data as CFData)!
    
    return certificate
  }
}

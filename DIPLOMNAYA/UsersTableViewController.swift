//
//  UsersTableViewController.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit
import Alamofire

class UsersTableViewController: UITableViewController {

    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startTime = CFAbsoluteTimeGetCurrent()
        NetworkClient.request(Router.users).responseDecodable { (response: AFDataResponse<Users>) in
            switch response.result {
            case .success(let value):
                self.users = value
            case .failure(let error):
              let isServerTrustEvaluationError =
                error.asAFError?.isServerTrustEvaluationError ?? false
              let message: String
              if isServerTrustEvaluationError {
                message = "Certificate Pinning Error"
              } else {
                message = error.localizedDescription
              }
                print(response.result)
              self.presentError(withTitle: "ой!", message: message)
            }
          }
        let time = CFAbsoluteTimeGetCurrent() - startTime
        print("время сетевого запроса с SSl закреплением\(time)")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.item]
        return cell.configureCell(user: user)
    }
}

extension UsersTableViewController {
  func presentError(withTitle title: String,
                    message: String,
                    actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]) {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    actions.forEach { action in
      alertController.addAction(action)
    }
    present(alertController, animated: true)
  }
}

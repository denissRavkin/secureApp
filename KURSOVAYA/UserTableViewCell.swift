//
//  UserTableViewCell.swift
//  KURSOVAYA
//
//  Created by Denis Ravkin on 04.01.2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabal: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func configureCell(user: User) -> UITableViewCell {
        nameLabal.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        return self
    }

}

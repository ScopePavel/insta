//
//  UserCell.swift
//  Insta
//
//  Created by 18529728 on 27.04.2021.
//

import UIKit
import SDWebImage

final class UserCell: UITableViewCell, ReusableView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        customView.backgroundColor = .tasksBack
        iconImageView.layer.cornerRadius = iconImageView.bounds.height/2
        customView.layer.cornerRadius = 20
    }

    func config(model: User) {
        nameLabel.text = model.username
        guard
            let picUrl = model.profile_pic_url,
            let url = URL(string: picUrl)
        else { return }
        iconImageView.sd_setImage(with: url, completed: nil)
    }
}

protocol ReusableView: class {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

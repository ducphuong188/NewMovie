//
//  UserTableViewCell.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    static let identifier = "UserTableViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .black
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titlesPosterUIImageView.frame = CGRect(x: 20, y: 20, width: 40, height: 40)
        titleLabel.frame = CGRect(x: 80, y: 20, width: 200, height: 40)
    }
    func configure(image: String, title: String) {
        titleLabel.text = title
        titlesPosterUIImageView.image = UIImage(systemName: image)
    }
}


//
//  CollectionViewCell.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit
import SDWebImage
class CollectionViewCell: UICollectionViewCell {
    static let identifier = "cell123"
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = CGColor(gray: 20, alpha: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        imageView.sd_setImage(with: url)
    }
}


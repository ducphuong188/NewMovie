//
//  CollectionViewCell2.swift
//  NewMovie
//
//  Created by macbook on 29/01/2024.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    private let imageView: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "netflix_logo")
        return image
    }()
    private let label1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .systemBackground
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .heavy)
        return label
    }()
    static let identifier = "cell2"
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label1)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = CGColor(gray: 20, alpha: 20)
        label1.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label1.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
    }
    func configure(title: String) {
        label1.text = title
    }
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor.alpha,
            UIColor.black.cgColor.alpha
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}


//
//  UserInfoCollectionViewCell.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

final class UserInfoCollectionViewCell: UICollectionViewCell {
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()

    private let nameContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userImageView)
        contentView.addSubview(nameContainerView)
        nameContainerView.addSubview(nameLabel)
        setupConstraints()
        layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 100),
            userImageView.heightAnchor.constraint(equalToConstant: 100),

            nameContainerView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -50),
            nameContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .zero),
            nameContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: .zero),
            nameContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            nameLabel.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8)
        ])
        contentView.bringSubviewToFront(userImageView)
    }

    // MARK: - Binding

    func bind(name: String?, imageURL: String?) {
        nameLabel.text = name
        if let url = URL(string: imageURL ?? "") {
            userImageView.setImage(from: url)
        }
    }
}

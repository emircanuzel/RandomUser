//
//  UserLocationCollectionViewCell.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import UIKit
import Foundation

final class UserLocationCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Location Info"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }()

    private let countryIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "globe.europe.africa"))
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        return label
    }()

    private lazy var addressRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationIcon, addressLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        return stack
    }()

    private lazy var countryRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [countryIcon, countryLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressRow, countryRow])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainStack)
        setupConstraints()
        backgroundColor = .white
        layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Binding

    func bind(with model: LocationModel) {
        let streetPart = [model.street?.name, model.state, model.city]
            .compactMap { $0 }
            .joined(separator: ", ")

        addressLabel.text = streetPart
        countryLabel.text = model.country
    }
}

//
//  UserCollectionViewCell.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

final class UserCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Delegate

    weak var delegate: UserCollectionViewCellDelegate?
    var model: UserListCellPresentationModel?

    // MARK: - UI Elements

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "trash") // SF Symbol
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, phoneLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(userImageView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(deleteButton)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Cell
    
    private func setupCell() {
        backgroundColor = .white
        roundCorners(radius: 12)
        addShadow()
        setupConstraints()
        setupDeleteAction()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),

            labelsStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 12),
            labelsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor, constant: -8),

            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupDeleteAction() {
        let action = UIAction { [weak self] _ in
            guard let self = self, let model = self.model else { return }
            self.delegate?.actionDeleteButton(with: model)
        }
        deleteButton.addAction(action, for: .touchUpInside)
    }

    // MARK: - Binding

    func bind(with model: UserListCellPresentationModel) {
        nameLabel.text = model.name
        phoneLabel.text = model.phone
        emailLabel.text = model.email
        if let url = URL(string: model.imageURL ?? "") {
            userImageView.setImage(from: url)
        }
        self.model = model
    }
}

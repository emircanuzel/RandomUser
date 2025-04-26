//
//  UserDetailInfoCollectionViewCell.swift
//  RandomUser
//
//  Created by emircan.uzel on 25.04.2025.
//

import Foundation
import UIKit

final class UserDetailInfoCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Info"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoStack)
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            infoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            infoStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Binding

    func bind(registeredDate: String?, gender: String?, email: String?) {
        infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let dateText = registeredDate?.toReadableDate()
        let registeredView = createInfoRow(imageSystemName: "calendar", text: dateText)
        let genderView = createInfoRow(imageSystemName: "person", text: gender)
        let emailView = createInfoRow(imageSystemName: "envelope", text: email)
        
        [genderView, emailView, registeredView].forEach { infoStack.addArrangedSubview($0) }
    }

    private func createInfoRow(imageSystemName: String, text: String?) -> UIStackView {
        let icon = UIImageView(image: UIImage(systemName: imageSystemName))
        icon.tintColor = .darkGray
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.numberOfLines = 1
        
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }
}

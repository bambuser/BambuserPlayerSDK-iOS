//
//  CartItemCell.swift
//  Demo
//
//  Created by Saeid Basirnia on 2024-01-17.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import UIKit

final class CartItemCell: UITableViewCell {

    static let id = "PlayerListCell"

    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let quantityLabel = UILabel()
    private let increaseButton = UIButton()
    private let decreaseButton = UIButton()

    var viewModel: CartItemCellModel? {
        didSet {
            self.viewModelDidSet()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }

    private func viewModelDidSet() {
        titleLabel.text = viewModel?.title
        quantityLabel.text = "Quantity: \(viewModel?.quantity ?? 0)"
        viewModel?.fetchImage(completion: { [weak self] image in
            guard let image, let self else { return }
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        })
    }

    private func setupViews() {
        productImageView.contentMode = .scaleToFill

        increaseButton.setTitle("+", for: .normal)
        increaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        increaseButton.setTitleColor(.blue, for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)

        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        decreaseButton.setTitleColor(.blue, for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(decreaseButton)

        productImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),

            quantityLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),

            increaseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            increaseButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),

            decreaseButton.trailingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: -10),
            decreaseButton.centerYAnchor.constraint(equalTo: increaseButton.centerYAnchor)
        ])
    }

    @objc private func increaseQuantity() {
        viewModel?.increaseQuantity()
        quantityLabel.text = "Quantity: \(viewModel?.quantity ?? 0)"
    }

    @objc private func decreaseQuantity() {
        viewModel?.decreaseQuantity()
        quantityLabel.text = "Quantity: \(viewModel?.quantity ?? 0)"
    }
}

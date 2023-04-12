//
//  HomePickerCell.swift
//  Demo
//
//  Created by Pontus Jacobsson on 2023-03-29.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import UIKit

class HomePickerCell: UITableViewCell {

    init(item: HomeCellViewModel<String>, options: [String]) {
        self.item = item
        self.options = options
        super.init(style: .default, reuseIdentifier: "")
        setupUI()
    }

    required init?(coder: NSCoder) { nil }


    var item: HomeCellViewModel<String>!
    var options: [String]

    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var menuButton = UIButton()
    private var menu: UIMenu?


    private func setupUI() {
        [iconImageView, titleLabel, menuButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: menuButton.leftAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            menuButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        ])

        contentView.isHidden = true
        setup()

        selectionStyle = .none
        iconImageView.tintColor = .label
        backgroundColor = .systemBackground
    }

    func setup() {
        titleLabel.text = item.title
        iconImageView.image = item.image
        iconImageView.contentMode = .scaleAspectFit

        setupMenu()
        menuButton.setTitle(item.value, for: .normal)
        menuButton.setTitleColor(.systemBlue, for: .normal)
        menuButton.showsMenuAsPrimaryAction = true
        menuButton.menu = menu
    }

    func setupMenu() {
        menu = UIMenu(children: options.map {
            UIAction(title: $0) { action in
                self.menuWasTapped(action.title)
            }
        })
    }

    func menuWasTapped(_ string: String) {
        item.onValueChanged?(string)
        menuButton.setTitle(string, for: .normal)
    }
}

//
//  HomeDatePickerCell.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import UIKit

class HomeDatePickerCell: UITableViewCell {

    init(item: HomeCellViewModel<Date>) {
        self.item = item
        super.init(style: .default, reuseIdentifier: "")
        setupUI()
    }

    required init?(coder: NSCoder) { nil }


    var item: HomeCellViewModel<Date>!

    private var iconImageView = UIImageView()
    private var titleLabel = UILabel()
    private var datePicker = UIDatePicker()


    private func setupUI() {
        [iconImageView, titleLabel, datePicker].forEach {
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
            titleLabel.rightAnchor.constraint(equalTo: datePicker.leftAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),

            datePicker.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            datePicker.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        contentView.isHidden = true

        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
        setup()
        selectionStyle = .none
        iconImageView.tintColor = .label
        backgroundColor = .systemBackground
    }

    func setup() {
        titleLabel.text = item.title
        titleLabel.numberOfLines = 0
        if let value = item.value {
            datePicker.date = value
        }
        iconImageView.image = item.image
        iconImageView.contentMode = .scaleAspectFit

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
    }
}

@objc
private extension HomeDatePickerCell {
    func onDateChanged() {
        item.onValueChanged?(datePicker.date)
    }
}

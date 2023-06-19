//
//  HomeCenteredImageCell.swift
//  Demo
//
//  Created by Anton Yereshchenko on 08.06.2023.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import UIKit

class HomeCenteredImageCell: UITableViewCell {
    
    init(image: UIImage?) {
        self.item = .init(
            title: String(),
            image: image,
            value: nil,
            onValueChanged: nil
        )
        
        super.init(style: .default, reuseIdentifier: "")
        
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private var item: HomeCellViewModel<Int>?
    
    private var iconImageView = UIImageView()
    
    private func setupUI() {
        [iconImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        setup()
        selectionStyle = .none
        iconImageView.tintColor = .label
        backgroundColor = .systemBackground
    }
    
    func setup() {
        iconImageView.image = item?.image
        iconImageView.contentMode = .scaleAspectFit
    }
}

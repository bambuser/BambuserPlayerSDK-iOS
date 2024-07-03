//
//  CartViewController.swift
//  Demo-UIKit
//
//  Created by Saeid Basirnia on 2024-06-27.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import Foundation
import UIKit

final class CartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.textColor = .label
        label.text = "Cart View"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

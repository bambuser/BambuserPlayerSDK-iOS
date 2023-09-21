//
//  HomeCellViewModel.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import UIKit

final class HomeCellViewModel<T> {
    
    internal init(
        title: String,
        image: UIImage?,
        value: T?,
        accessoryType: UITableViewCell.AccessoryType = .none,
        autocapitalizationType: UITextAutocapitalizationType  = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default,
        onValueChanged: ((T) -> Void)?) {
        self.title = title
        self.image = image
        self.value = value
        self.accessoryType = accessoryType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.onValueChanged = onValueChanged
    }
    
    let title: String
    let image: UIImage?
    let value: T?
    let accessoryType: UITableViewCell.AccessoryType
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    let onValueChanged: ((T) -> Void)?
}

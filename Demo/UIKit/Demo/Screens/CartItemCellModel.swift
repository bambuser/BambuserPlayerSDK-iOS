//
//  CartItemCellModel.swift
//  Demo
//
//  Created by Saeid Basirnia on 2024-01-17.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func increaseProductQuantity(_ id: String)
    func decreaseProductQuantity(_ id: String)
}

final class CartItemCellModel {

    var productId: String
    var title: String
    var quantity: Int = 1
    var imageURL: URL?
    weak var delegate: CartItemCellDelegate?

    init(
        productId: String,
        title: String,
        quantity: Int,
        imageURL: URL?,
        delegate: CartItemCellDelegate?
    ) {
        self.productId = productId
        self.title = title
        self.quantity = quantity
        self.imageURL = imageURL
        self.delegate = delegate
    }

    func increaseQuantity() {
        quantity += 1
        delegate?.increaseProductQuantity(productId)
    }

    func decreaseQuantity() {
        guard quantity > 0 else {
            return
        }
        quantity -= 1
        delegate?.decreaseProductQuantity(productId)
    }

    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}

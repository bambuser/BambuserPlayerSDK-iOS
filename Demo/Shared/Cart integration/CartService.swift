//
//  DemoSettings+CartDelegate.swift
//  Demo
//
//  Created by Anton Yereshchenko on 04.08.2023.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import BambuserPlayerSDK
import Combine

final class CartService: PlayerCartDelegate, PlayerCartDataSource, ProductDetailsDataSource, ObservableObject {

    @Published var mockedProduct: MockedProduct = .none

    var productsInCart: [InCartProductModel] = []

    func playerCartItems() -> [InCartProductModel] {
        productsInCart
    }

    func updateProductInCart(_ product: InCartProductModel, isItemRemoved: Bool) {
        playerCartSyncItem?(product, isItemRemoved)
    }
    
    func playerCartItemUpdated(_ item: InCartProductModel, isRemoved: Bool) {
        guard let index = productsInCart.firstIndex(of: item) else {
            productsInCart.append(item)
            return
        }
        if isRemoved {
            productsInCart.remove(at: index)
            return
        }
        productsInCart[index] = item
    }

    func productDetails(
        for product: Product.Request
    ) async throws -> Product.Hydrated? {
        try await Task.sleep(nanoseconds: 5_000_000_00) // 0.5 second mocked latency
        return mockedProduct.product
    }

    var playerCartCheckoutTapped = {
        print("Cart Checkout is tapped - Navigating to checkout screen")
    }

    // No implementation is needed
    var playerCartSyncItem: ((InCartProductModel, Bool) -> Void)?
}

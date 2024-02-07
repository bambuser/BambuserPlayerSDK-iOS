//
//  CartViewModel.swift
//  Demo
//
//  Created by Saeid Basirnia on 2024-01-15.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import Foundation
import BambuserPlayerSDK

/// This is representing in-app cart for host app which is hosting BambuserPlayerSDK
/// this demonstrate how in-app cart and BambuserPlayerSDK can be synced when
/// a change happens in either of them.
final class HostInAppCartViewModel: ObservableObject {
    
    @Published var products: [InCartProductModel] = []
    var cartService: CartService!
        
    func setupCartService(_ service: CartService) {
        self.cartService = service
        self.products = cartService.productsInCart
    }
    
    private func cartUpdated(_ product: InCartProductModel, isRemoved: Bool) {
        cartService.productsInCart = products
        cartService.playerCartSyncItem?(product, isRemoved)
    }
    
    func addProductOrIncrementQuantity(_ product: InCartProductModel) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].quantity += 1
        } else {
            products.append(product)
        }
        cartUpdated(product, isRemoved: false)
    }

    func decrementQuantity(of product: InCartProductModel) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        if product.quantity == 1 {
            products.remove(at: index)
            cartUpdated(product, isRemoved: true)
        } else {
            products[index].quantity -= 1
            cartUpdated(product, isRemoved: false)
        }
    }
}

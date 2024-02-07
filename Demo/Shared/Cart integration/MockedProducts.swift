//
//  MockedProducts.swift
//  Demo
//
//  Created by Pontus Jacobsson on 2023-10-05.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import Foundation
import BambuserPlayerSDK

enum MockedProduct: String, CaseIterable {
    case none
    case hoodie
    case rainbow
    case sneaker

    var product: Product.Hydrated? {
        switch self {
        case .none: return nil
        case .hoodie: return .hoodie
        case .rainbow: return .rainbow
        case .sneaker: return .sneaker
        }
    }
    
    var inCartProducts: InCartProductModel? {
        switch self {
        case .none: return nil
        case .hoodie, .rainbow, .sneaker:
            guard let product = product,
                  let color = product.colors.first,
                  let size = color.sizes.first
            else { return nil }
            return InCartProductModel(
                product: product,
                selectedColor: color,
                selectedSize: size,
                quantity: 1
            )
        }
    }
}

fileprivate extension Product.Hydrated {
    static var hoodie: Product.Hydrated {
        let currencyCode = "USD"
        let price: Decimal = 45

        return .init(
            id: "1737",
            name: "Activity Hoodie",
            brand: "THE BRAND",
            shortDescription: "Jacket in sweatshirt fabric",
            description: "Jacket in sweatshirt fabric with a jersey-lined drawstring hood, zip down the front, side pockets and ribbing at the cuffs and hem. Soft brushed inside. Regular Fit.",
            price: price,
            originalPrice: nil,
            currency: currencyCode,
            colors: [
                .init(
                    id: "1737_black", 
                    name: "Black",
                    color: .black,
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-front.png",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-right.jpeg",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-back.jpeg",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/black-hoodie-left.jpeg"
                    ].compactMap { URL(string: $0) },
                    sizes: ["Small", "Medium", "Large", "XL"].map {
                        SizeVariant(
                            id: "1737_black_\($0)",
                            name: $0,
                            quantityInStock: 1,
                            currencyCode: currencyCode,
                            currentPrice: price)
                    }
                ),
                .init(
                    id: "1737_gray",
                    name: "Gray",
                    color: .gray,
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-front.png",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-right.jpeg",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-back.jpeg",
                        "https://demo.bambuser.shop/wp-content/uploads/2021/07/white-hoodie-left.jpeg"
                    ].compactMap { URL(string: $0) },
                    sizes: [("Small", 5), ("Medium", 0), ("Large", 1)].map {
                        SizeVariant(
                            id: "1737_gray_\($0.0)",
                            name: $0.0,
                            quantityInStock: $0.1,
                            currencyCode: currencyCode,
                            currentPrice: price)
                    }
                )
            ]
        )
    }

    static var rainbow: Product.Hydrated {
        .init(
            id: "1810",
            name: "8-pieces Rainbow",
            brand: "THE BRAND",
            shortDescription: "Nice looking child decoration",
            description: "This playful rainbow consists of bows in different colors and sizes. Stack them in the right order, and a nice rainbow emerges. Or experiment and make your own unique designs. Fun to play with and at the same time looks nice in the children’s room.",
            price: 16,
            originalPrice: nil,
            currency: "USD",
            colors: [
                .init(
                    id: "1810_OneColor",
                    name: "One color",
                    color: nil,
                    imageUrls: [
                        "https://demo.bambuser.shop/wp-content/uploads/2023/06/Kids_1.1-1.png",
                        "https://demo.bambuser.shop/wp-content/uploads/2023/06/Kids_1.2-1-600x600.png",
                        "https://demo.bambuser.shop/wp-content/uploads/2023/06/Kids_1.3-1-600x600.png"
                    ].compactMap { URL(string: $0) },
                    sizes: [
                        .init(
                            id: "1810_OneColor_OneSize",
                            name: "One size",
                            quantityInStock: 1,
                            currencyCode: "USD",
                            currentPrice: 16
                        )
                    ])
            ]
        )
    }

    static var sneaker: Product.Hydrated {
        .init(
            id: "1253",
            name: "Venturi Sneakers",
            brand: "THE BRAND",
            shortDescription: "Sneakers in high fashion street style",
            description: "Step into comfort and style with our exceptional pair of sneakers. Designed with modern aesthetics and crafted with premium materials, these sneakers are the perfect fusion of fashion and functionality.",
            price: 128,
            originalPrice: 150,
            currency: "USD",
            colors: [
                .init(
                    id: "1253_OneColor",
                    name: "One Color",
                    color: nil,
                    imageUrls: ["https://demo.bambuser.shop/wp-content/uploads/2023/05/Fashion_4.png"]
                        .compactMap { URL(string: $0) },
                    sizes: (28...56).map {
                        SizeVariant(
                            id: "1253_OneColor_\($0)",
                            name: "\($0)",
                            quantityInStock: 5,
                            currencyCode: "USD",
                            currentPrice: 128,
                            originalPrice: 150
                        )
                    }
                )
            ]
        )
    }
}

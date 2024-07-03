//
//  CartView.swift
//  Demo
//
//  Created by Saeid Basirnia on 2024-01-15.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import SwiftUI

struct HostInAppCartView: View {
    
    @EnvironmentObject private var settings: DemoSettings
    @ObservedObject var viewModel = HostInAppCartViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.products, id: \.id) { product in
                    HStack {
                        AsyncImage(url: product.product.colors.first?.imageUrls.first) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                            } else if phase.error != nil {
                                Image(systemName: "photo").resizable()
                            } else {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(product.product.name)
                            Text("Quantity: \(product.quantity)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button {
                            viewModel.decrementQuantity(of: product)
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                        Button {
                            viewModel.addProductOrIncrementQuantity(product)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                        
                    }
                    .buttonStyle(.borderless)
                }
            }
            .navigationBarTitle("Shopping Cart")
            .navigationBarItems(trailing: Menu("Add Product") {
                Button("Add Product 1") { 
                    viewModel.addProductOrIncrementQuantity(MockedProduct.hoodie.inCartProducts!)
                }
                Button("Add Product 2") {
                    viewModel.addProductOrIncrementQuantity(MockedProduct.rainbow.inCartProducts!)
                }
                Button("Add Product 3") {
                    viewModel.addProductOrIncrementQuantity(MockedProduct.sneaker.inCartProducts!)
                }
            })
        }
        .onAppear(perform: {
            viewModel.setupCartService(settings.cartService)
        })
    }
}

#Preview {
    HostInAppCartView()
        .environmentObject(DemoSettings())
}

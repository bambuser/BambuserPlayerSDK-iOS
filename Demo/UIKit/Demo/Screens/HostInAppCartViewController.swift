//
//  HostInAppCartViewController.swift
//  Demo
//
//  Created by Saeid Basirnia on 2024-01-17.
//  Copyright © 2024 Bambuser AB. All rights reserved.
//

import UIKit
import BambuserPlayerSDK

final class HostInAppCartViewController: UIViewController, CartItemCellDelegate {

    private let settings: DemoSettings
    private let tableView = UITableView()
    private let inCartProduct = MockedProduct.hoodie.inCartProducts!
    private var cellsViewModel: [String: CartItemCellModel] = [:]

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        return [.portrait, .portraitUpsideDown]
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    init(settings: DemoSettings) {
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false

        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let orientationValue = preferredInterfaceOrientationForPresentation.rawValue
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
        }
    }

    func setupViews() {
        navigationItem.title = "In-App Shopping Cart"
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.allowsSelection = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Item",
            style: .plain,
            target: self,
            action: #selector(addItemTapped)
        )
    }

    func increaseProductQuantity(_ id: String) {
        addProductOrIncrementQuantity(id)
    }

    func decreaseProductQuantity(_ id: String) {
        decrementQuantity(id)
    }

    @objc func addItemTapped() {
        addProductOrIncrementQuantity(inCartProduct.id)
    }

    private func cartUpdated(_ product: InCartProductModel, isRemoved: Bool) {
        settings.cartService.playerCartSyncItem?(product, isRemoved)
        tableView.reloadData()
    }

    private func addProductOrIncrementQuantity(_ productId: String) {
        var product: InCartProductModel
        if let index = settings.cartService.productsInCart.firstIndex(where: { $0.id == productId }) {
            product = settings.cartService.productsInCart[index]
            product.quantity += 1
            settings.cartService.productsInCart[index] = product
        } else {
            product = inCartProduct
            settings.cartService.productsInCart.append(product)
        }
        cartUpdated(product, isRemoved: false)
    }

    private func decrementQuantity(_ productId: String) {
        guard let index = settings.cartService.productsInCart.firstIndex(where: { $0.id == productId }) else { return }
        var product = settings.cartService.productsInCart[index]
        if product.quantity == 1 {
            settings.cartService.productsInCart.remove(at: index)
            cartUpdated(product, isRemoved: true)
        } else {
            product.quantity -= 1
            settings.cartService.productsInCart[index] = product
            cartUpdated(product, isRemoved: false)
        }
    }
}

// MARK: - UITableViewControllerDelegate
extension HostInAppCartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UITableViewControllerDataSource

extension HostInAppCartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        settings.cartService.productsInCart.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.cartService.productsInCart.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartItems = settings.cartService.productsInCart

        guard cartItems.count > 0 else {
            cellsViewModel.removeAll()
            return UITableViewCell()
        }
        let item = cartItems[indexPath.row]

        let cell = CartItemCell()
        if let viewModel = cellsViewModel[item.id] {
            cell.viewModel = viewModel
        } else {
            let viewModel = CartItemCellModel(
                productId: item.id,
                title: item.product.name,
                quantity: item.quantity,
                imageURL: item.selectedColor.imageUrls.first,
                delegate: self
            )
            cellsViewModel[item.id] = viewModel
            cell.viewModel = viewModel
        }
        return cell
    }
}

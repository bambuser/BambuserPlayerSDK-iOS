//
//  HomeViewController.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI
import UIKit
import BambuserPlayerSDK

/**
 This is the first main screen in the demo. It presents many
 menu alternatives and registers a PiP restore listener that
 is responsible for restoring PiP players that exit PiP when
 the source player screen has been deallocated.
 */
class HomeViewController: UITableViewController {
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) { nil }

    var preferredLocaleIdentifier: String {
        get {
            settings.preferredLocale?.identifier ??
            Locale.default.identifier
        }
        set { settings.preferredLocale = Locale(identifier: newValue) }
    }
    
    var selectedEnvironment: SelectableEnvironment {
        get { .init(environment: settings.environment) }
        set { settings.environment = newValue.environment(otherName: otherEnvironmentName) }
    }
    var otherEnvironmentName: String = "" {
        didSet { settings.environment = .other(name: otherEnvironmentName) }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCells()
        
        title = "Demo"
        view.backgroundColor = .white
        
        tableView.contentInset = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.backgroundColor = .systemGray6

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerPictureInPictureRestoreAction { [weak self] completion in
            print("Restoring parentless PiP player...")
            self?.showPlayerAsSheet(completion: completion)
        }
        registerPictureInPictureCloseAction {
            print("Closing parentless PiP player...")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Properties
    
    var settings = DemoSettings()
    var staticCells: [[UITableViewCell]] = []
    var headerTitles: [String] = []
    
    // MARK: - Section 0
    
    private lazy var showPlayerCell = HomeNormalCell(
        item: HomeCellViewModel(
            title: "Show player",
            image: .player,
            value: nil,
            accessoryType: .disclosureIndicator,
            onValueChanged: nil))
    
    private lazy var showPlayerAsSheetCell = HomeNormalCell(
        item: HomeCellViewModel(
            title: "Show player as sheet",
            image: .sheet,
            value: nil,
            accessoryType: .disclosureIndicator,
            onValueChanged: nil))
    
    private lazy var fullScreenCoverCell = HomeNormalCell(
        item: HomeCellViewModel(
            title: "Show player as full screen cover",
            image: .cover,
            value: nil,
            accessoryType: .disclosureIndicator,
            onValueChanged: nil))
    
    private lazy var showMultiplePlayers = HomeNormalCell(
        item: HomeCellViewModel(
            title: "Show multiple players in list",
            image: .cover,
            value: nil,
            accessoryType: .disclosureIndicator,
            onValueChanged: nil))

    // MARK: - Section 1
    
    private lazy var showHostInAppCart = HomeNormalCell(
        item: HomeCellViewModel(
            title: "Open Host In-App Cart",
            image: .bag,
            value: nil,
            accessoryType: .disclosureIndicator,
            onValueChanged: nil))

    // MARK: - Section 2

    private lazy var preferredLocaleCell = HomeTextFieldCell(
        item: HomeCellViewModel(
            title: "Preferred locale",
            image: .globe,
            value: preferredLocaleIdentifier,
            autocapitalizationType: .none,
            autocorrectionType: .no) {
                self.preferredLocaleIdentifier = $0
            })
    
    // MARK: - Section 3

    private var showIdCell: HomeTextFieldCell {
        HomeTextFieldCell(
            item: HomeCellViewModel(
                title: "Show ID",
                image: .id,
                value: settings.showId) { newValue in
                    self.settings.showId = newValue
                })
    }

    private lazy var environmentCell = HomePickerCell(
        item: HomeCellViewModel(
            title: "Environment",
            image: .server,
            value: selectedEnvironment.rawValue.capitalized) {
                self.selectedEnvironment = .init(rawValue: $0.lowercased()) ?? .auto
                self.loadCells()
            },
        options: SelectableEnvironment.allCases.map { $0.rawValue.capitalized }
    )

    private lazy var otherEnvironmentCell = HomeTextFieldCell(
        item: HomeCellViewModel(
            title: "Other environment name",
            image: .otherEnvironment,
            value: otherEnvironmentName) {
                self.otherEnvironmentName = $0
            })

    private lazy var autoSwitchShowCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Auto switch to next show",
            image: .pipEnter,
            value: settings.automaticallyLoadNextShow) {
                self.settings.automaticallyLoadNextShow = $0
                self.loadCells()
            })
    
    // MARK: - Section 3

    private lazy var pipEnabledCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Enabled",
            image: .pipEnter,
            value: settings.isPiPEnabled) {
                self.settings.isPiPEnabled = $0
            })

    private lazy var pipAutomaticCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Automatic",
            image: .pipExit,
            value: settings.isPiPAutomatic) {
                self.settings.isPiPAutomatic = $0
            })

    private lazy var hideUiOnPipCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Hide UI",
            image: .rectangle,
            value: settings.hideUiOnPip) {
                self.settings.hideUiOnPip = $0
            })

    private lazy var pipRestoreAutomaticallyCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Restore automatically",
            image: .pipRestore,
            value: settings.shouldRestorePiPAutomatically) {
                self.settings.shouldRestorePiPAutomatically = $0
            })
    
    // MARK: - Section 4
    
    private lazy var allUiCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "All UI",
            image: .ui,
            value: settings.allUI) {
            self.settings.allUI = $0
        })
    
    private lazy var showNumberOfViewersCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show number of viewers",
            image: .number,
            value: settings.showNumberOfViewers) {
            self.settings.showNumberOfViewers = $0
        })
    
    private lazy var chatOverlayCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show chat overlay",
            image: .chat,
            value: settings.chatOverlay) {
            self.settings.chatOverlay = $0
        })
    
    private lazy var emojiOverlayCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show emoji overlay",
            image: .heart,
            value: settings.emojiOverlay) {
            self.settings.emojiOverlay = $0
        })
    
    private lazy var productListCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show product list",
            image: .product,
            value: settings.productList) {
            self.settings.productList = $0
        })

    private lazy var productListStyleCell = HomePickerCell(
        item: .init(
            title: "Product list",
            image: .productList,
            value: settings.productListLayout.rawValue,
            onValueChanged: { newValue in
                self.settings.productListLayout = .init(
                    rawValue: newValue,
                    date: self.settings.productListLayoutDate
                )

                self.loadCells()
            }), options: PlayerUIConfiguration.HighlightedProductsLayout
            .allCases.map({ $0.rawValue })
    )

    private var productListStyleDateCell: HomeDatePickerCell? {
        if case .configurable(date: let date) = settings.productListLayout {
            return HomeDatePickerCell(item: .init(
                title: "Product list breaking point date",
                image: .calendar,
                value: date,
                onValueChanged: { newValue in
                    self.settings.productListLayoutDate = newValue
                    self.settings.productListLayout = .configurable(date: newValue)
                }))
        } else {
            return nil
        }
    }

    // MARK: - Section 5

    private lazy var actionBarCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show action bar",
            image: .actionBar,
            value: settings.actionBar) {
            self.settings.actionBar = $0
        })

    private lazy var emojiButtonCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show emoji button",
            image: .heart,
            value: settings.emojiButton) {
            self.settings.emojiButton = $0
        })

    private lazy var cartButtonCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show cart button",
            image: .cart,
            value: settings.cartButton) {
            self.settings.cartButton = $0
        })

    private lazy var chatVisibilityButtonCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show chat visibility button",
            image: .chat,
            value: settings.chatVisibilityButton) {
            self.settings.chatVisibilityButton = $0
        })

    private lazy var chatInputFieldCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show chat input field",
            image: .textField,
            value: settings.chatInputField) {
            self.settings.chatInputField = $0
        })
    
    private lazy var shareButtonCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show share button",
            image: .share,
            value: settings.shareButton) {
            self.settings.shareButton = $0
        })
    
    // MARK: - Curtain
    
    private lazy var pdpCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Open PDP on product tap",
            image: .product,
            value: settings.showPDPOnProductTap) {
            self.settings.showPDPOnProductTap = $0
        })
    
    private lazy var productsCurtainCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show products on curtain",
            image: .bag,
            value: settings.productsOnCurtain) {
            self.settings.productsOnCurtain = $0
        })
    
    private lazy var productPlayCell = HomeToggleCell(
        item: HomeCellViewModel(
            title: "Show product play button",
            image: .timestamp,
            value: settings.productPlayButton) {
            self.settings.productPlayButton = $0
        })

    private lazy var mockedProductCell = HomePickerCell(
        item: .init(
            title: "Mocked product",
            image: .shippingBox,
            value: MockedProduct.none.rawValue,
            onValueChanged: { newValue in
                self.settings.mockedProduct = .init(rawValue: newValue) ?? MockedProduct.none
            }),
        options: MockedProduct.allCases.map { $0.rawValue } )
}

// MARK: - Load Cells

extension HomeViewController {
    func loadCells() {
        updateHeaderTitles()

        let otherEnvCell: UITableViewCell? = selectedEnvironment == .other ? otherEnvironmentCell : nil
    
        let upcomingShowsSection: [UITableViewCell]? = settings.automaticallyLoadNextShow ? upcomingCells() : nil
                
        staticCells = [
            [showPlayerCell, showPlayerAsSheetCell, fullScreenCoverCell, showMultiplePlayers],
            [showHostInAppCart],
            [preferredLocaleCell],
            [showIdCell, environmentCell, otherEnvCell, autoSwitchShowCell].compactMap({ $0 }),
            upcomingShowsSection,
            [pipEnabledCell, pipAutomaticCell, hideUiOnPipCell, pipRestoreAutomaticallyCell],
            [allUiCell, showNumberOfViewersCell, chatOverlayCell, emojiOverlayCell,
             productListCell, productListStyleCell, productListStyleDateCell].compactMap({ $0 }),
            [actionBarCell, emojiButtonCell, cartButtonCell, chatVisibilityButtonCell, chatInputFieldCell, shareButtonCell],
            [pdpCell, productsCurtainCell, productPlayCell, mockedProductCell]
        ].compactMap({ $0 })

        tableView.reloadData()
    }
}

// MARK: - UITableViewControllerDelegate

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: showPlayer()
            case 1: showPlayerAsSheet()
            case 2: showPlayerAsFullscreenModal()
            case 3: showPlayerList()
            default: break
            }
        }
        
        if indexPath.section == 1 {
            navigateToInAppCart()
        }

        // Upcoming shows section. Click on '+' button
        if settings.automaticallyLoadNextShow,
           indexPath.section == 3,
            settings.upcomingShows.count == indexPath.row {
            if !settings.upcomingShows.contains(where: { $0.isEmpty }) {
                settings.upcomingShows.append(String())
                loadCells()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return settings.automaticallyLoadNextShow &&
           indexPath.section == 3 &&
           settings.upcomingShows.count > indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            settings.upcomingShows.remove(at: indexPath.row)
            loadCells()
        }
    }
}

// MARK: - UITableViewControllerDataSource

extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        staticCells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        staticCells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        staticCells[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headerTitles[section]
    }
}

// MARK: - Private Functionality

private extension HomeViewController {
    
    var playerController: PlayerViewController {
        let viewController = PlayerViewController(settings: settings)
        viewController.onViewDidDisappear = { [weak self] in
            guard let self = self else { return }
            if self.settings.automaticallyLoadNextShow {
                self.loadCells()
            }
        }
        return viewController
    }
    
    var inAppCartViewController: HostInAppCartViewController {
        HostInAppCartViewController(settings: settings)
    }

    func showPlayer() {
        navigationController?.pushViewController(playerController, animated: true)
    }
    
    func navigateToInAppCart() {
        navigationController?.pushViewController(inAppCartViewController, animated: true)
    }

    func showPlayerAsSheet(completion: (() -> Void)? = nil) {
        present(playerController, animated: true, completion: completion)
    }
    
    func showPlayerAsFullscreenModal() {
        let playerVC = playerController
        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true, completion: nil)
    }
    
    func showPlayerList() {
        let controller = PlayerListViewController(settings: settings)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Notifications

@objc private extension HomeViewController {

    func didBecomeActive() {
        if settings.shouldRestorePiPAutomatically && PictureInPictureState.shared.isPictureInPictureActive {
            PictureInPictureState.shared.restorePlayer()
        }
    }
}
